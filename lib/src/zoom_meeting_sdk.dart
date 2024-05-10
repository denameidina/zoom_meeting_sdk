import 'package:zoom_meeting_sdk/src/model/join_meeting_options.dart';
import 'package:zoom_meeting_sdk/src/model/join_meeting_params.dart';
import 'package:zoom_meeting_sdk/src/model/zoom_sdk_init_params.dart';
import 'package:zoom_meeting_sdk/src/result/meeting_error.dart';
import 'package:zoom_meeting_sdk/src/result/meeting_status.dart';
import 'package:zoom_meeting_sdk/src/result/zoom_error.dart';

import 'zoom_meeting_sdk_platform_interface.dart';

class ZoomMeetingSdk {
  Future<ZoomError> initZoom({required ZoomSDKInitParams zoomSDKInitParams}) {
    return ZoomMeetingSdkPlatform.instance.initZoom(
      zoomSDKInitParams: zoomSDKInitParams,
    );
  }

  Future<MeetingError> joinMeting({
    required JoinMeetingOptions joinMeetingOptions,
    required JoinMeetingParams joinMeetingParams,
  }) {
    return ZoomMeetingSdkPlatform.instance.joinMeting(
      joinMeetingOptions: joinMeetingOptions,
      joinMeetingParams: joinMeetingParams,
    );
  }

  Stream<MeetingStatus> listenMeetingStatus() {
    return ZoomMeetingSdkPlatform.instance.listenMeetingStatus();
  }
}
