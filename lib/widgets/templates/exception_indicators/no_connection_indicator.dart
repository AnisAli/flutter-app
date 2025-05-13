import '../../../exports/index.dart';

/// Indicates that a connection error occurred.
class NoConnectionIndicator extends StatelessWidget {
  const NoConnectionIndicator({
    Key? key,
    this.onTryAgain,
  }) : super(key: key);

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: AppStrings.NO_INTERNET_CONNECTION,
        message: AppStrings.CONNECTION_TRY_AGAIN,
        assetName: AppAssets.FRUSTRATED_FACE,
        onTryAgain: onTryAgain,
      );
}
