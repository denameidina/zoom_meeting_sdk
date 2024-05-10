import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zoom_meeting_sdk/src/model/join_meeting_options.dart';
import 'package:zoom_meeting_sdk/src/model/join_meeting_params.dart';
import 'package:zoom_meeting_sdk/src/model/zoom_sdk_init_params.dart';
import 'package:zoom_meeting_sdk/src/result/meeting_error.dart';
import 'package:zoom_meeting_sdk/src/result/meeting_status.dart';
import 'package:zoom_meeting_sdk/src/result/zoom_error.dart';

import 'zoom_meeting_sdk_method_channel.dart';

abstract class ZoomMeetingSdkPlatform extends PlatformInterface {
  /// Constructs a ZoomMeetingSdkPlatform.
  ZoomMeetingSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZoomMeetingSdkPlatform _instance = MethodChannelZoomMeetingSdk();

  /// The default instance of [ZoomMeetingSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelZoomMeetingSdk].
  static ZoomMeetingSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZoomMeetingSdkPlatform] when
  /// they register themselves.
  static set instance(ZoomMeetingSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<ZoomError> initZoom({
    required ZoomSDKInitParams zoomSDKInitParams,
  }) {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  Future<MeetingError> joinMeting({
    required JoinMeetingOptions joinMeetingOptions,
    required JoinMeetingParams joinMeetingParams,
  }) {
    throw UnimplementedError('joinMeting() has not been implemented.');
  }

  Stream<MeetingStatus> listenMeetingStatus() {
    throw UnimplementedError('listenMeetingStatus() has not been implemented.');
  }
}
