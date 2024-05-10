import 'dart:convert';

class ZoomSDKInitParams {
  ZoomSDKInitParams({
    this.autoRetryVerifyApp = false,
    this.domain = 'zoom.us',
    this.enableGenerateDump = false,
    this.enableLog = false,
    required this.jwtToken,
    this.logSize,
  });

  // If it is TRUE, Zoom SDK will retry to call verifyApp automatically. Otherwise user needs to call verifyApp manually once initialize failed.
  final bool autoRetryVerifyApp;
  // ZOOM domain name. Default value: zoom.us
  final String domain;
  // Enable/Disable sdk catch crash. For Java Thread.setUncaughtExceptionHandler(Thread.UncaughtExceptionHandler)
  final bool enableGenerateDump;
  // Enable/Disable the default debug log.
  final bool enableLog;
  // jwtToken got from developer. if you use jwtToken to initialize, no need to set appKey and appSecret. if you set both jwtToken and appKey and appSecret, we will use jwtToken to initialize first.
  final String jwtToken;
  // Log File Size. 1-50M
  final int? logSize;

  Map<String, dynamic> toMap() {
    return {
      'autoRetryVerifyApp': autoRetryVerifyApp,
      'domain': domain,
      'enableGenerateDump': enableGenerateDump,
      'enableLog': enableLog,
      'jwtToken': jwtToken,
      'logSize': logSize,
    };
  }

  factory ZoomSDKInitParams.fromMap(Map<String, dynamic> map) {
    return ZoomSDKInitParams(
      autoRetryVerifyApp: map['autoRetryVerifyApp'] ?? false,
      domain: map['domain'],
      enableGenerateDump: map['enableGenerateDump'] ?? false,
      enableLog: map['enableLog'] ?? false,
      jwtToken: map['jwtToken'] ?? '',
      logSize: map['logSize']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoomSDKInitParams.fromJson(String source) =>
      ZoomSDKInitParams.fromMap(json.decode(source));
}
