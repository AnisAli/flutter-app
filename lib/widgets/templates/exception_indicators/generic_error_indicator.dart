import '../../../exports/index.dart';

/// Indicates that an unknown error occurred.
class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({
    Key? key,
    this.onTryAgain,
  }) : super(key: key);

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: AppStrings.SOMETHING_WENT_WRONG,
        message: AppStrings.TRY_AGAIN_LATER,
        assetName: AppAssets.CONFUSED_FACE,
        onTryAgain: onTryAgain,
      );
}
