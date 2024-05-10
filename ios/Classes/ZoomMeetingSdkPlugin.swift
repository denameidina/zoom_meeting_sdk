import Flutter
import UIKit
import MobileRTC

public class ZoomMeetingSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "zoom_meeting_sdk", binaryMessenger: registrar.messenger())
    let instance = ZoomMeetingSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initZoom":
      guard let arguments = call.arguments as? Dictionary<String, Any> else { return }
      setupSDK(arguments, result)
    case "joinMeeting":
      guard let arguments = call.arguments as? Dictionary<String, Any> else { return }
      self.joinMeeting(arguments)
    }
  }

  func getDeviceID() -> String {
    return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
  }

  func getRootController() -> UIViewController {
    let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
    let topController = (keyWindow?.rootViewController)!
    return topController
  }
}

extension SwiftZoomNativeSdkPlugin{
    func joinAMeetingButtonPressed(meetingNumber: String, meetingPassword: String){
        //        requestSaveClientJoiningTime(id: id)

        // 1. The Zoom SDK requires a UINavigationController to update the UI for us. Here we are supplying the SDK with the ViewControllers' navigationController.
        MobileRTC.sharedRTC().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        //     window?.makeKeyAndVisible()
        // start your meetingA
        //        joinMeeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword)
    }

    func joinMeeting(arguments: Dictionary<String, Any>) {
        MobileRTC.sharedRTC().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        if let meetingService = MobileRTC.sharedRTC().getMeetingService() {
            
            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            meetingService.delegate = self

            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.noAudio = args["no_audio"] ?? false
            joinMeetingParameters.noVideo = args["no_video"] ?? false
            if let customerKey = args["customer_key"] {
              joinMeetingParameters.customerKey = customerKey
            }
            if let vanityID = args["vanityID"] {
              joinMeetingParameters.vanityID = vanityID
            }
            joinMeetingParameters.meetingNumber = args["meetingNo"] ?? ""
            if let displayName = args["displayName"] {
              joinMeetingParameters.userName = displayName
            }
            if let password = args["password"] {
              joinMeetingParameters.password = password
            }
            if let webinarToken = args["webinar_token"] {
              joinMeetingParameters.webinarToken = webinarToken
            }
            if let zak = args["zak"] {
              joinMeetingParameters.zak = zak
            }
            if let appPrivilegeToken = args["appPrivilegeToken"] {
              joinMeetingParameters.appPrivilegeToken = appPrivilegeToken
            }
            joinMeetingParameters.isMyVoiceInMix = args["isMyVoiceInMix"] ?? false
            joinMeetingParameters.isAudioRawDataStereo = args["isAudioRawDataStereo"] ?? false

            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.muteMyVideo(true)
            meetingService.muteMyAudio(false)

            //  meetingService.video
            meetingService.joinMeeting(with: joinMeetingParameters)
        }else{
            print("Error get Meeting Service")
        }
    }

}
extension SwiftZoomNativeSdkPlugin: MobileRTCMeetingServiceDelegate {
  // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
  public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
    switch error {
    case MobileRTCMeetError.passwordError:
        print("MobileRTCMeeting   :   Could not join or start meeting because the meeting password was incorrect.")
    default:
        print("MobileRTCMeeting   :   Could not join or start meeting with MobileRTCMeetError: \(error) \(message ?? "")")
    }
  }

  // Is called when the user joins a meeting.
  public func onJoinMeetingConfirmed() {
    print("MobileRTCMeeting   :   Join meeting confirmed.")
  }

  // Is called upon meeting state changes.
  public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
    print("MobileRTCMeeting   :   Current meeting state: \(state.rawValue)")
    switch state{

    case .idle:
        print("idle")
    case .connecting:
        print("connecting")

    case .waitingForHost:
        print("waitingForHost")

    case .inMeeting:
        print("inMeeting")

    case .disconnecting:
        print("disconnecting")

    case .reconnecting:
        print("reconnecting")

    case .failed:
        print("failed")

    case .ended:
        print("ended")

    case .unknow:
        print("unknow")

    case .locked:
        print("locked")

    case .unlocked:
        print("unlocked")

    case .inWaitingRoom:
        print("inWaitingRoom")

    case .webinarPromote:
        print("webinarPromote")

    case .webinarDePromote:
        print("webinarDePromote")

    case .joinBO:
        print("joinBO")

    case .leaveBO:
        print("leaveBO")
    @unknown default:
        break
    }
  }
}

extension SwiftZoomNativeSdkPlugin: MobileRTCAuthDelegate {
  /// setupSDK Creates, Initializes, and Authorizes an instance of the Zoom SDK. This must be called before calling any other SDK functions.
  func setupSDK(arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
    let context = MobileRTCSDKInitContext()
    context.domain = args["domain"] ?? "zoom.us"
    context.enableLog = args["enableLog"] ?? false

    let sdkInitializedSuccessfully = MobileRTC.sharedRTC().initialize(context)

    if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.sharedRTC().getAuthService() {
        authorizationService.delegate = self
        authorizationService.jwtToken = args["jwtToken"] ?? ""
        authorizationService.sdkAuth()
    }
  }

  // Result of calling sdkAuth(). MobileRTCAuthError_Success represents a successful authorization.
  public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
    switch returnValue {
    case MobileRTCAuthError.success:
        print("SDK successfully initialized.")
    case MobileRTCAuthError.tokenWrong
        print("SDK jwtToken is not valid.")
    case MobileRTCAuthError.keyOrSecretEmpty:
        print("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
    case MobileRTCAuthError.keyOrSecretWrong, MobileRTCAuthError.unknown:
        print("SDK Key/Secret is not valid.")
    default:
        print("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
    }
  }

  private func onMobileRTCLoginReturn(_ returnValue: Int) {
    switch returnValue {
    case 0:
        print("Successfully logged in")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
    case 1002:
        print("Password incorrect")
    default:
        print("Could not log in. Error code: \(returnValue)")
    }
  }
  public func onMobileRTCLogoutReturn(_ returnValue: Int) {
    switch returnValue {
    case 0:
        print("Successfully logged out")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
    default:
        print("Could not log out. Error code: \(returnValue)")
    }
  }

  public func applicationWillTerminate(_ application: UIApplication) {
    // Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
    if let authorizationService = MobileRTC.sharedRTC().getAuthService() {
        // Call logoutRTC() to log the user out.
        authorizationService.logoutRTC()
    }
  }
}
