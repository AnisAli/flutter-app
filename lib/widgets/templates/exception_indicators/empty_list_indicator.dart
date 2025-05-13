import '../../../exports/index.dart';

/// Indicates that no items were found.
class EmptyListIndicator extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onTryAgain;

  const EmptyListIndicator(
      {super.key, this.onTryAgain, this.title, this.message});

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: title ?? AppStrings.TOO_MUCH_FILTERING,
        message: message ?? AppStrings.NO_MATCH_FOUND,
        assetName: AppAssets.EMPTY_BOX,
        onTryAgain: onTryAgain,
      );
}
