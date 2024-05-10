import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zoom_meeting_sdk/src/model/join_meeting_options.dart';
import 'package:zoom_meeting_sdk/src/model/join_meeting_params.dart';
import 'package:zoom_meeting_sdk/src/model/zoom_sdk_init_params.dart';
import 'package:zoom_meeting_sdk/src/result/meeting_error.dart';
import 'package:zoom_meeting_sdk/src/result/meeting_status.dart';
import 'package:zoom_meeting_sdk/src/result/zoom_error.dart';

import 'zoom_meeting_sdk_platform_interface.dart';

/// An implementation of [ZoomMeetingSdkPlatform] that uses method channels.
class MethodChannelZoomMeetingSdk extends ZoomMeetingSdkPlatform {
  /// The method channel used to interact with the meeting platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zoom_meeting_sdk');

  /// The event channel used to interact with the meeting platform.
  @visibleForTesting
  final eventChannel =
      const EventChannel('zoom_meeting_sdk:listen_meeting_status');

  @override
  Future<ZoomError> initZoom({
    required ZoomSDKInitParams zoomSDKInitParams,
  }) async {
    final zoomError = await methodChannel.invokeMethod<int>(
      'initZoom',
      zoomSDKInitParams.toMap(),
    );
    return ZoomError.fromValue(zoomError);
  }

  @override
  Future<MeetingError> joinMeting({
    required JoinMeetingOptions joinMeetingOptions,
    required JoinMeetingParams joinMeetingParams,
  }) async {
    Map<String, dynamic> arguments = {};
    arguments.addAll(joinMeetingOptions.toMap());
    arguments.addAll(joinMeetingParams.toMap());

    final meetingError = await methodChannel.invokeMethod<int>(
      'joinMeeting',
      arguments,
    );
    return MeetingError.fromValue(meetingError);
  }

  @override
  Stream<MeetingStatus> listenMeetingStatus() {
    return eventChannel.receiveBroadcastStream().map(
          (event) => MeetingStatus.values.firstWhere(
            (element) =>
                element.name.toLowerCase() == event.toString().toLowerCase(),
          ),
        );
  }
}
