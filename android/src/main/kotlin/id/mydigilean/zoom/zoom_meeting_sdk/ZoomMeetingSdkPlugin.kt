package id.mydigilean.zoom.zoom_meeting_sdk

import androidx.annotation.NonNull

import android.app.Activity
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import java.net.URL
import java.net.HttpURLConnection
import android.graphics.BitmapFactory

import us.zoom.sdk.*

/** ZoomMeetingSdkPlugin */
class ZoomMeetingSdkPlugin: FlutterPlugin, MethodCallHandler, MeetingServiceListener, ActivityAware, EventChannel.StreamHandler {
  
  private lateinit var channel: MethodChannel
  private var eventSink : EventChannel.EventSink? = null

  private var activity: Activity? = null
  private var zoomSDK: ZoomSDK? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zoom_meeting_sdk")
    channel.setMethodCallHandler(this)

    val event = EventChannel(flutterPluginBinding.binaryMessenger, "zoom_meeting_sdk:listen_meeting_status")  
    event.setStreamHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "initZoom" -> {
          initZoom(call.arguments<Map<String, Any>>(), result)
      }
      "joinMeeting" -> {
          joinMeeting(call.arguments<Map<String, Any>>(), result)
      }
      else -> {
          result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun initZoom(arguments: Map<String, Any>?, result: Result) {
      zoomSDK = ZoomSDK.getInstance()
      val initParams = ZoomSDKInitParams()
      initParams.autoRetryVerifyApp = arguments?.get("autoRetryVerifyApp") as? Boolean ?: false
      initParams.domain = arguments?.get("domain") as? String ?: ""
      initParams.enableGenerateDump = arguments?.get("enableGenerateDump") as? Boolean ?: false
      initParams.enableLog = arguments?.get("enableLog") as? Boolean ?: false
      initParams.jwtToken = arguments?.get("jwtToken") as? String ?: ""
      if (arguments?.get("logSize") != null) {
         initParams.logSize = arguments?.get("logSize") as? Int ?: 0
      }

      zoomSDK?.initialize(activity, object: ZoomSDKInitializeListener {
        override fun onZoomSDKInitializeResult(zoomError: Int, internalZoomError: Int) {
            result.success(zoomError)
        }

        override fun onZoomAuthIdentityExpired() {}
      }, initParams)
    }

    fun joinMeeting(arguments: Map<String, Any>?, result: Result) {
      val meetingService = zoomSDK?.meetingService
      val opts = JoinMeetingOptions()

      opts.no_audio = arguments?.get("no_audio") as? Boolean ?: false
      if (arguments?.get("webinar_token") != null) {
        opts.webinar_token = arguments?.get("webinar_token") as? String ?: ""
      }
      if (arguments?.get("custom_meeting_id") != null) {
        opts.custom_meeting_id = arguments?.get("custom_meeting_id")  as? String ?: ""
      }
      if (arguments?.get("customer_key") != null) {
        opts.customer_key = arguments?.get("customer_key") as? String ?: ""
      }
      if (arguments?.get("invite_options") != null) {
        opts.invite_options = arguments?.get("invite_options") as? Int ?: 0
      }
      if (arguments?.get("meeting_views_options") != null) {
        opts.meeting_views_options = arguments?.get("meeting_views_options") as? Int ?: 0
      }
      opts.no_bottom_toolbar = arguments?.get("no_bottom_toolbar") as? Boolean ?: false
      opts.no_chat_msg_toast = arguments?.get("no_chat_msg_toast") as? Boolean ?: false
      opts.no_dial_in_via_phone = arguments?.get("no_dial_in_via_phone") as? Boolean ?: false
      opts.no_dial_out_to_phone = arguments?.get("no_dial_out_to_phone") as? Boolean ?: false
      opts.no_disconnect_audio = arguments?.get("no_disconnect_audio") as? Boolean ?: false
      opts.no_driving_mode = arguments?.get("no_driving_mode") as? Boolean ?: false
      opts.no_invite = arguments?.get("no_invite") as? Boolean ?: false
      opts.no_meeting_end_message = arguments?.get("no_meeting_end_message") as? Boolean ?: false
      opts.no_meeting_error_message = arguments?.get("no_meeting_error_message") as? Boolean ?: false
      opts.no_record = arguments?.get("no_record") as? Boolean ?: false
      opts.no_share = arguments?.get("no_share") as? Boolean ?: false
      opts.no_titlebar = arguments?.get("no_titlebar") as? Boolean ?: false
      opts.no_unmute_confirm_dialog = arguments?.get("no_unmute_confirm_dialog") as? Boolean ?: false
      opts.no_video = arguments?.get("no_video") as? Boolean ?: false
      opts.no_webinar_register_dialog = arguments?.get("no_webinar_register_dialog") as? Boolean ?: false
      

      val params = JoinMeetingParams()
      if (arguments?.get("appPrivilegeToken") != null) {
        params.appPrivilegeToken = arguments?.get("appPrivilegeToken") as? String ?: ""
      }
      if (arguments?.get("displayName") != null) {
        params.displayName = arguments?.get("displayName") as? String ?: ""
      }
      params.isAudioRawDataStereo = arguments?.get("isAudioRawDataStereo") as? Boolean ?: false
      params.isMyVoiceInMix = arguments?.get("isMyVoiceInMix") as? Boolean ?: false
      if (arguments?.get("join_token") != null) {
        params.join_token = arguments?.get("join_token") as? String ?: ""
      }
      params.meetingNo = arguments?.get("meetingNo") as? String ?: ""
      if (arguments?.get("password") != null) {
        params.password = arguments?.get("password") as? String ?: "" 
      }
      if (arguments?.get("vanityID") != null) {
        params.vanityID = arguments?.get("vanityID") as? String ?: ""
      }
      if (arguments?.get("webinarToken") != null) {
        params.webinarToken = arguments?.get("webinarToken") as? String ?: ""
      }

      if (meetingService == null) {
        result.success(999)
      } else {
        val meetingError = meetingService?.joinMeetingWithParams(activity, params, opts)
        meetingService?.addListener(this)

        if (arguments?.get("urlVirtualBackground") != null) {
            try {
              val url = URL(arguments?.get("urlVirtualBackground") as? String ?: "")
              val connection = url.openConnection() as HttpURLConnection
              connection.doInput = true
              connection.connect()
              val input = connection.inputStream
              val bitmap = BitmapFactory.decodeStream(input)
              if (bitmap != null) {
                  zoomSDK?.inMeetingService?.inMeetingVirtualBackgroundController?.addBGImage(bitmap)
              }
              connection.disconnect()
          } catch (e: Exception) {
          }
        }

        result.success(meetingError)
      }
    }

    override fun onMeetingStatusChanged(meetingStatus: MeetingStatus, errorCode: Int, internalErrorCode: Int) {
        var result = "unknown"
        when (meetingStatus) {
            MeetingStatus.MEETING_STATUS_CONNECTING -> result = "connecting"
            MeetingStatus.MEETING_STATUS_DISCONNECTING -> result = "disconnecting"
            MeetingStatus.MEETING_STATUS_ENDED -> result = "ended"
            MeetingStatus.MEETING_STATUS_FAILED -> result = "failed"
            MeetingStatus.MEETING_STATUS_IDLE -> result = "idle"
            MeetingStatus.MEETING_STATUS_IN_WAITING_ROOM -> result = "inWaitingRoom"
            MeetingStatus.MEETING_STATUS_INMEETING -> result = "inMeeting"
            MeetingStatus.MEETING_STATUS_JOIN_BREAKOUT_ROOM -> result = "joinBreakoutRoom"
            MeetingStatus.MEETING_STATUS_LEAVE_BREAKOUT_ROOM -> result = "leaveBreakoutRoom"
            MeetingStatus.MEETING_STATUS_LOCKED -> result = "locked"
            MeetingStatus.MEETING_STATUS_RECONNECTING -> result = "reconnecting"
            MeetingStatus.MEETING_STATUS_UNKNOWN -> result = "unknown"
            MeetingStatus.MEETING_STATUS_UNLOCKED -> result = "unlocked"
            MeetingStatus.MEETING_STATUS_WAITINGFORHOST -> result = "waitingForHost"
            MeetingStatus.MEETING_STATUS_WEBINAR_DEPROMOTE -> result = "webinarDepromote"
            MeetingStatus.MEETING_STATUS_WEBINAR_PROMOTE -> result = "webinarPromote"
        }

        eventSink?.success(result)
    }

    override fun onMeetingParameterNotification(meetingParameter: MeetingParameter) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        channel.setMethodCallHandler(null);
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
