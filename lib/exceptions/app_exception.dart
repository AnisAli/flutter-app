import 'package:otrack/exports/index.dart';

class AppException implements Exception {
  final String? title;
  final String? detail;

  AppException({
    this.title,
    this.detail,
  }) {
    detail != null
        ? CustomSnackBar.showCustomErrorSnackBar(
            title: title ?? '',
            message: detail ?? '',
          )
        : CustomSnackBar.showCustomErrorToast(message: title ?? '');
  }

  factory AppException.error(String title) => AppException(title: title);

  factory AppException.unknownError() => AppException(
        title: 'An Unknown Error occurred.',
      );

  factory AppException.wentWrong() => AppException(
        title: 'Something Went Wrong.',
      );

  factory AppException.firebase(FirebaseAuthException error) {
    AuthErrorCode authError = AuthErrorCode.getError(error);
    return AppException(
      title: authError.detail ?? error.code,
      detail: error.message,
    );
  }

  @override
  String toString() => '${title ?? ''}${detail != null ? ', $detail' : ''}';
}
