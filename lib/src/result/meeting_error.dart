enum MeetingError {
  // App privilege token error.
  appPrivilegeTokenError(500),
  // Join failed because this Meeting SDK key is blocked by the host’s account admin.
  blockedByAccountAdmin(64),
  // ZOOM SDK version is too low to connect to the meeting.
  clientIncompatible(4),
  // It is disallowed to register the webinar with the host's email.
  disallowHostRegisterWebinar(17),
  // It is disallowed to register the webinar with the panelist's email.
  disallowPanelistRegisterWebinar(18),
  // User leaves the meeting when waiting for the host to start.
  exitWhenWaitingHostStart(21),
  // The registration of the webinar is rejected by the host.
  hostDenyEmailRegisterWebinar(19),
  // Forbidden to join meeting
  hostDisallowOutsideUserJoin(62),
  // The meeting number is wrong.
  incorrectMeetingNumber(1),
  // Meeting is failed due to invalid arguments.
  invalidArguments(99),
  // Meeting API can not be called now.
  invalidStatus(101),
  // Jmak user email not match
  jmakUserEmailNotMatch(1143),
  // Meeting is locked.
  locked(12),
  // Meeting dose not exist.
  meetingNotExist(9),
  // Meeting ends.
  meetingOver(8),
  // MMR server error.
  mmrError(6),
  // Need sign in using the same account as the meeting organizer.
  needSignInForPrivateMeeting(82),
  // Network error.
  networkError(5),
  // The network is unavailable.
  networkUnavailable(3),
  // There is no MMR server available for the current meeting.
  noMmr(11),
  // The number of registers exceeds the upper limit of webinar.
  registerWebinarFull(16),
  // Meeting fail.
  removedByHost(22),
  // Meeting is restricted.
  restricted(13),
  // It is disabled to join meeting before host.
  restrictedJbh(14),
  // Session error.
  sessionError(7),
  // Start meeting successfully.
  success(0),
  // Timeout.
  timeout(2),
  // To join a meeting hosted by an external Zoom account, your SDK app has to be published on Zoom Marketplace.
  unableToJoinExternalMeeting(63),
  // Unknown error.
  unknown(100),
  // The number of participants exceeds the upper limit.
  userFull(10),
  // Failed to request web service.
  webServiceFailed(15),
  // User needs to log in if he wants to join the webinar.
  webinarEnforceLogin(20),
  // User needs to log in if he wants to join the webinar.
  zoomNotInit(999);

  const MeetingError(this.value);

  final int value;

  static MeetingError fromValue(int? value) {
    if (value == null) {
      return MeetingError.unknown;
    }
    return MeetingError.values.firstWhere((e) => e.value == value,
        orElse: () => MeetingError.unknown);
  }
}
