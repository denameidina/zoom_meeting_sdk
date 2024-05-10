enum ZoomError {
  // Auth fail: account not enable sdk
  authretAccountNotEnableSdk(8),
  // Auth fail: account not support
  authretAccountNotSupport(7),
  // The Api calls failed because auth client version don't support.
  authretClientIncompatiblee(4),
  // Auth fail: key or secret error
  authretKeyOrSecretError(6),
  // The authentication rate limit is exceeded.
  authretLimitExceededException(9),
  // The jwt token to authenticate is wrong
  authretTokenwrong(5),
  // The device is not supported by ZOOM.
  deviceNotSupported(99),
  // The domain is not support
  domainDontSupport(101),
  // The Api calls failed because the key or secret is illegal.
  illegalAppKeyOrSecret(2),
  // The Api calls failed due to one or more invalid arguments.
  invalidArguments(1),
  // The Api calls failed because the network is unavailable.
  networkUnavailable(3),
  // Api calls successfully.
  success(0),
  // The Api calls failed due to an unknown reason.
  unknown(100);

  const ZoomError(this.value);

  final int value;

  static ZoomError fromValue(int? value) {
    if (value == null) {
      return ZoomError.unknown;
    }
    return ZoomError.values
        .firstWhere((e) => e.value == value, orElse: () => ZoomError.unknown);
  }
}
