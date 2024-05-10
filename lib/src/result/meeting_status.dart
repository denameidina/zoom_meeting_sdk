enum MeetingStatus {
  // Status when the meeting is connecting to the server
  connecting,
  // Status when the meeting is disconnecting from the server
  disconnecting,
  // Status when the meeting has ended
  ended,
  // Status when the meeting has failed
  failed,
  // Status when no meeting is running
  idle,
  // Status when participants are in the waiting room
  inWaitingRoom,
  // Status when the meeting is in progress
  inMeeting,
  // Status when a participant joins the breakout room
  joinBreakoutRoom,
  // Status when a participant leaves the breakout room
  leaveBreakoutRoom,
  // Status when the meeting is locked
  locked,
  // Status when the meeting is reconnecting
  reconnecting,
  // Status when the meeting status is unknown
  unknown,
  // Status when the meeting is unlocked
  unlocked,
  // Status when waiting for the host to start the meeting
  waitingForHost,
  // Status when demoting the attendees from the panelist in a webinar
  webinarDepromote,
  // Status when promoting the attendees to panelist in a webinar
  webinarPromote,
}
