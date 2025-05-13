import '../../exports/index.dart';

enum AuthErrorCode {
  emailAlreadyInUse('email-already-in-use', 'Email Already In Use'),
  invalidEmail('invalid-email', 'Invalid Email'),
  operationNotAllowed('operation-not-allowed', 'Operation Not Allowed'),
  weakPassword('weak-password', 'Weak Password'),
  missingEmail('weak-password', 'Weak Password'),
  authInvalidEmail('auth/invalid-email', 'Auth/Invalid Email'),

  // authMissingAndroidPkgName('auth/missing-android-pkg-name', 'Auth/'),
  // authMissingContinueUri('auth/missing-continue-uri', 'Auth/'),
  // authMissingIosBundleId('auth/missing-ios-bundle-id', 'Auth/'),
  // authInvalidContinueUri('auth/invalid-continue-uri', 'Auth/'),
  // authUnauthorizedContinueUri('auth/unauthorized-continue-uri', 'Auth/'),

  authUserNotFound('auth/user-not-found', 'Auth/User Not Found'),
  wrongPassword('wrong-password', 'Wrong Password'),
  userDisabled('user-disabled', 'User is Disabled'),
  userNotFound('user-not-found', 'User Not Found'),

  noInternetConnection('network-request-failed', 'No internet connection !'),
  tooManyRequests('too-many-requests', 'Too many requests. Try again later!'),

  nullError(null, null);

  const AuthErrorCode(this.error, this.detail);
  final String? error;
  final String? detail;

  static AuthErrorCode getError(FirebaseAuthException exception) =>
      AuthErrorCode.values.firstWhere(
        (error) => exception.code == error.error,
        orElse: () => nullError,
      );
}
