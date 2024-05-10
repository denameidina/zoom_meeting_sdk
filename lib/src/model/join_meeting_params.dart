import 'dart:convert';

class JoinMeetingParams {
  JoinMeetingParams({
    this.appPrivilegeToken,
    this.displayName,
    this.isAudioRawDataStereo = false,
    this.isMyVoiceInMix = false,
    this.joinToken,
    required this.meetingNo,
    this.password,
    this.vanityID,
    this.webinarToken,
    this.urlVirtualBackground,
  });

  // App privilege token
  final String? appPrivilegeToken;
  // User's screen name in the meeting.
  final String? displayName;
  // Is audio raw data stereo? The default is mono
  final bool isAudioRawDataStereo;
  // Is my voice in the mixed audio raw data?
  final bool isMyVoiceInMix;
  // Join Meeting token.
  final String? joinToken;
  // The scheduled meeting number.
  final String meetingNo;
  // Meeting password.
  final String? password;
  // Meeting vanity ID, what is personal link name.
  final String? vanityID;
  // WebinarToken.
  final String? webinarToken;
  // Url Virtual Background.
  final String? urlVirtualBackground;

  Map<String, dynamic> toMap() {
    return {
      'appPrivilegeToken': appPrivilegeToken,
      'displayName': displayName,
      'isAudioRawDataStereo': isAudioRawDataStereo,
      'isMyVoiceInMix': isMyVoiceInMix,
      'join_token': joinToken,
      'meetingNo': meetingNo,
      'password': password,
      'vanityID': vanityID,
      'webinarToken': webinarToken,
      'urlVirtualBackground': urlVirtualBackground,
    };
  }

  factory JoinMeetingParams.fromMap(Map<String, dynamic> map) {
    return JoinMeetingParams(
      appPrivilegeToken: map['appPrivilegeToken'] ?? '',
      displayName: map['displayName'] ?? '',
      isAudioRawDataStereo: map['isAudioRawDataStereo'] ?? false,
      isMyVoiceInMix: map['isMyVoiceInMix'] ?? false,
      joinToken: map['join_token'] ?? '',
      meetingNo: map['meetingNo'] ?? '',
      password: map['password'] ?? '',
      vanityID: map['vanityID'] ?? '',
      webinarToken: map['webinarToken'] ?? '',
      urlVirtualBackground: map['urlVirtualBackground'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinMeetingParams.fromJson(String source) =>
      JoinMeetingParams.fromMap(json.decode(source));
}
