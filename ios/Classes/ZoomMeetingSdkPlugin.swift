import Flutter
import UIKit
import MobileRTC

public class ZoomMeetingSdkPlugin: NSObject, FlutterPlugin, MobileRTCMeetingServiceDelegate {
    private var channel: FlutterMethodChannel?
    private var eventSink: FlutterEventSink?
    private var zoomSDK: MobileRTC?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = ZoomMeetingSdkPlugin()
        
        let channel = FlutterMethodChannel(name: "zoom_meeting_sdk", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)

        let eventChannel = FlutterEventChannel(name: "zoom_meeting_sdk:listen_meeting_status", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initZoom":
            if let arguments = call.arguments as? [String: Any] {
                initZoom(arguments: arguments, result: result)
            }
        case "joinMeeting":
            if let arguments = call.arguments as? [String: Any] {
                joinMeeting(arguments: arguments, result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initZoom(arguments: [String: Any], result: @escaping FlutterResult) {
        let context = MobileRTCSDKInitContext()
        context.domain = arguments["domain"] as? String ?? "zoom.us"
        context.enableLog = arguments["enableLog"] as? Bool ?? false

        zoomSDK = MobileRTC.sharedRTC()
        zoomSDK?.initialize(context)

        if let authService = zoomSDK?.getAuthService() {
            if let jwtToken = arguments["jwtToken"] as? String {
              authService.jwtToken = jwtToken
            }
            authService.delegate = {
                class InlineMobileRTCAuthDelegate: MobileRTCAuthDelegate {
                    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
                    switch returnValue {
                        case .success:
                            result(0) // ZoomError.success.value
                        case .keyOrSecretEmpty:
                            result(2) // ZoomError.illegalAppKeyOrSecret.value
                        case .keyOrSecretWrong:
                            result(6) // ZoomError.authretKeyOrSecretError.value
                        case .serviceTimeout:
                            result(9) // ZoomError.authretLimitExceededException.value
                        case .networkIssue:
                            result(3) // ZoomError.networkUnavailable.value
                        case .tokenWrong:
                            result(5) // ZoomError.tokenWrong.value
                        case .unknown:
                            result(100) // ZoomError.unknown.value
                        @unknown default:
                            result(100) // ZoomError.unknown.value
                        }
                    }

                    func onMobileRTCAuthExpired() {
                    }

                    func onMobileRTCLoginResult(_ resultValue: MobileRTCLoginFailReason) {
                    }

                    func onMobileRTCLogoutReturn(_ returnValue: NSInteger) {
                    }

                    func onNotificationServiceStatus(_ status: MobileRTCNotificationServiceStatus, error: MobileRTCNotificationServiceError) {
                    }
                }
                return InlineMobileRTCAuthDelegate()
            }()
            authService.sdkAuth()
        }
    }

    private func joinMeeting(arguments: [String: Any], result: @escaping FlutterResult) {
        guard let meetingService = zoomSDK?.getMeetingService() else {
            result(999) // MeetingError.zoomNotInit.value
            return
        }

        let joinMeetingParameters = MobileRTCMeetingJoinParam()
        if let meetingNo = arguments["meetingNo"] as? String {
            joinMeetingParameters.meetingNumber = meetingNo
        }
        if let password = arguments["password"] as? String {
            joinMeetingParameters.password = password
        }
        if let displayName = arguments["displayName"] as? String {
            joinMeetingParameters.userName = displayName
        }
        if let customerKey = arguments["customerKey"] as? String {
            joinMeetingParameters.customerKey = customerKey
        }
        if let vanityID = arguments["vanityID"] as? String {
            joinMeetingParameters.vanityID = vanityID
        }
        if let webinarToken = arguments["webinarToken"] as? String {
            joinMeetingParameters.webinarToken = webinarToken
        }
        if let zak = arguments["zak"] as? String {
            joinMeetingParameters.zak = zak
        }
        if let appPrivilegeToken = arguments["appPrivilegeToken"] as? String {
            joinMeetingParameters.appPrivilegeToken = appPrivilegeToken
        }
        if let join_token = arguments["join_token"] as? String {
            joinMeetingParameters.join_token = join_token
        }

        joinMeetingParameters.noAudio = arguments["no_audio"] as? Bool ?? false
        joinMeetingParameters.noVideo = arguments["no_video"] as? Bool ?? false
        joinMeetingParameters.isMyVoiceInMix = arguments["isMyVoiceInMix"] as? Bool ?? false
        joinMeetingParameters.isAudioRawDataStereo = arguments["isAudioRawDataStereo"] as? Bool ?? false

        meetingService.delegate = self
        let meetingError = meetingService.joinMeetingWithJoinParam(with: joinMeetingParameters)

        // Adding virtual background
        if let urlVirtualBackground = arguments["urlVirtualBackground"] as? String {
            let url = URL(string: urlVirtualBackground)!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error downloading virtual background image: \(String(describing: error))")
                    return
                }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        meetingService.addBGImage(image)
                    }
                }
            }
            task.resume()
        }

        switch meetingError {
            case .success:
                result(0) // MeetingError.success.value
            case .networkError, .videoError, .audioAutoStartError:
                result(5) // MeetingError.networkError.value
            case .reconnectError, .sessionError:
                result(7) // MeetingError.sessionError.value
            case .mmrError:
                result(6) // MeetingError.mmrError.value
            case .passwordError, .invalidArguments:
                result(99) // MeetingError.invalidArguments.value
            case .meetingOver:
                result(8) // MeetingError.meetingOver.value
            case .meetingNotStart, .invalidStatus:
                result(101) // MeetingError.invalidStatus.value
            case .meetingNotExist:
                result(9) // MeetingError.meetingNotExist.value
            case .meetingUserFull:
                result(10) // MeetingError.userFull.value
            case .meetingClientIncompatible:
                result(4) // MeetingError.clientIncompatible.value
            case .noMMR:
                result(11) // MeetingError.noMmr.value
            case .meetingLocked:
                result(12) // MeetingError.locked.value
            case .meetingRestricted:
                result(13) // MeetingError.restricted.value
            case .meetingRestrictedJBH:
                result(14) // MeetingError.restrictedJbh.value
            case .cannotEmitWebRequest:
                result(15) // MeetingError.webServiceFailed.value
            case .cannotStartTokenExpire:
                result(2) // MeetingError.timeout.value
            case .registerWebinarFull:
                result(16) // MeetingError.registerWebinarFull.value
            case .registerWebinarHostRegister:
                result(17) // MeetingError.disallowHostRegisterWebinar.value
            case .registerWebinarPanelistRegister:
                result(18) // MeetingError.disallowPanelistRegisterWebinar.value
            case .registerWebinarDeniedEmail:
                result(19) // MeetingError.hostDenyEmailRegisterWebinar.value
            case .registerWebinarEnforceLogin:
                result(20) // MeetingError.webinarEnforceLogin.value
            case .zCCertificateChanged, .vanityNotExist:
                result(100) // MeetingError.unknown.value
            case .joinWebinarWithSameEmail:
                result(1143) // MeetingError.jmakUserEmailNotMatch.value
            case .writeConfigFile:
                result(100) // MeetingError.unknown.value
            case .removedByHost:
                result(22) // MeetingError.removedByHost.value
            case .hostDisallowOutsideUserJoin:
                result(62) // MeetingError.hostDisallowOutsideUserJoin.value
            case .unableToJoinExternalMeeting:
                result(63) // MeetingError.unableToJoinExternalMeeting.value
            case .blockedByAccountAdmin:
                result(64) // MeetingError.blockedByAccountAdmin.value
            case .needSignInForPrivateMeeting:
                result(82) // MeetingError.needSignInForPrivateMeeting.value
            case .invalidUserType, .inAnotherMeeting, .tooFrequenceCall, .wrongUsage, .failed, .vbBase, .vbSetError, .vbMaximumNum, .vbSaveImage, .vbRemoveNone, .vbNoSupport, .vbGreenScreenNoSupport:
                result(100) // MeetingError.unknown.value
            case .appPrivilegeTokenError:
                result(500) // MeetingError.appPrivilegeTokenError.value
            case .unknown:
                result(100) // MeetingError.unknown.value
            @unknown default:
                result(100) // MeetingError.unknown.value
        }
    }

    public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        var result = "Unknown"
        switch state {
          case .idle:
              result = "idle"
          case .connecting:
              result = "connecting"
          case .waitingForHost:
              result = "waitingForHost"
          case .inMeeting:
              result = "inMeeting"
          case .disconnecting:
              result = "disconnecting"
          case .reconnecting:
              result = "reconnecting"
          case .failed:
              result = "failed"
          case .ended:
              result = "ended"
          case .locked:
              result = "locked"
          case .unlocked:
              result = "unlocked"
          case .inWaitingRoom:
              result = "inWaitingRoom"
          case .webinarPromote:
              result = "webinarPromote"
          case .webinarDePromote:
              result = "webinarDepromote"
          case .joinBO:
              result = "joinBreakoutRoom"
          case .leaveBO:
              result = "leaveBreakoutRoom"
          default:
              result = "unknown"
        }
        eventSink?(result)
    }
}

