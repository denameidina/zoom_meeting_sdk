import 'dart:convert';

class JoinMeetingOptions {
  JoinMeetingOptions({
    this.noAudio = false,
    this.webinarToken,
    this.customMeetingId,
    this.customerKey,
    this.inviteOptions,
    this.meetingViewsOptions,
    this.noBottomToolbar = false,
    this.noChatMsgToast = false,
    this.noDialInViaPhone = false,
    this.noDialOutToPhone = false,
    this.noDisconnectAudio = false,
    this.noDrivingMode = false,
    this.noInvite = false,
    this.noMeetingEndMessage = false,
    this.noMeetingErrorMessage = false,
    this.noRecord = false,
    this.noShare = false,
    this.noTitlebar = false,
    this.noUnmuteConfirmDialog = false,
    this.noVideo = false,
    this.noWebinarRegisterDialog = false,
  });

  // Set it to TRUE to disconnect the audio when the user joins the meeting.
  final bool noAudio;
  // The webinar token is null.
  final String? webinarToken;
  // Set to change meeting ID displayed on meeting view title.
  final String? customMeetingId;
  // Participant ID.
  final String? customerKey;
  // Invitation options.
  final int? inviteOptions;
  // Meeting view options.
  final int? meetingViewsOptions;
  // Query whether to hide TOOLBAR at bottom.
  final bool noBottomToolbar;
  // Set whether to hide chat message toast when receive a chat message
  final bool noChatMsgToast;
  // Query whether to hide CALL IN BY PHONE.
  final bool noDialInViaPhone;
  // Query whether to hide CALL OUT.
  final bool noDialOutToPhone;
  // Query whether to hide DISCONNECT AUDIO.
  final bool noDisconnectAudio;
  // Query whether to hide DRIVING MODE.
  final bool noDrivingMode;
  // Query whether to hide INVITATION.
  final bool noInvite;
  // Query whether to hide MESSAGE OF ENDING MEETING.
  final bool noMeetingEndMessage;
  // Query whether to hide MEETING ERROR MESSAGE.
  final bool noMeetingErrorMessage;
  // Set whether hide record
  final bool noRecord;
  // Query whether to hide SHARE.
  final bool noShare;
  // Query whether to hide MEETING TITLE-BAR.
  final bool noTitlebar;
  // Query whether to hide host unmute yourself confirm dialog.
  final bool noUnmuteConfirmDialog;
  // Query whether to hide VIDEO.
  final bool noVideo;
  // Query whether to hide webinar need register dialog.
  final bool noWebinarRegisterDialog;

  Map<String, dynamic> toMap() {
    return {
      'no_audio': noAudio,
      'webinar_token': webinarToken,
      'custom_meeting_id': customMeetingId,
      'customer_key': customerKey,
      'invite_options': inviteOptions,
      'meeting_views_options': meetingViewsOptions,
      'no_bottom_toolbar': noBottomToolbar,
      'no_chat_msg_toast': noChatMsgToast,
      'no_dial_in_via_phone': noDialInViaPhone,
      'no_dial_out_to_phone': noDialOutToPhone,
      'no_disconnect_audio': noDisconnectAudio,
      'no_driving_mode': noDrivingMode,
      'no_invite': noInvite,
      'no_meeting_end_message': noMeetingEndMessage,
      'no_meeting_error_message': noMeetingErrorMessage,
      'no_record': noRecord,
      'no_share': noShare,
      'no_titlebar': noTitlebar,
      'no_unmute_confirm_dialog': noUnmuteConfirmDialog,
      'no_video': noVideo,
      'no_webinar_register_dialog': noWebinarRegisterDialog,
    };
  }

  factory JoinMeetingOptions.fromMap(Map<String, dynamic> map) {
    return JoinMeetingOptions(
      noAudio: map['no_audio'] ?? false,
      webinarToken: map['webinar_token'],
      customMeetingId: map['custom_meeting_id'],
      customerKey: map['customer_key'],
      inviteOptions: map['invite_options']?.toInt(),
      meetingViewsOptions: map['meeting_views_options']?.toInt(),
      noBottomToolbar: map['no_bottom_toolbar'] ?? false,
      noChatMsgToast: map['no_chat_msg_toast'] ?? false,
      noDialInViaPhone: map['no_dial_in_via_phone'] ?? false,
      noDialOutToPhone: map['no_dial_out_to_phone'] ?? false,
      noDisconnectAudio: map['no_disconnect_audio'] ?? false,
      noDrivingMode: map['no_driving_mode'] ?? false,
      noInvite: map['no_invite'] ?? false,
      noMeetingEndMessage: map['no_meeting_end_message'] ?? false,
      noMeetingErrorMessage: map['no_meeting_error_message'] ?? false,
      noRecord: map['no_record'] ?? false,
      noShare: map['no_share'] ?? false,
      noTitlebar: map['no_titlebar'] ?? false,
      noUnmuteConfirmDialog: map['no_unmute_confirm_dialog'] ?? false,
      noVideo: map['no_video'] ?? false,
      noWebinarRegisterDialog: map['no_webinar_register_dialog'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinMeetingOptions.fromJson(String source) =>
      JoinMeetingOptions.fromMap(json.decode(source));
}
