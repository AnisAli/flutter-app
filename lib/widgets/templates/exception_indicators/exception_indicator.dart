import '../../../exports/index.dart';

/// Basic layout for indicating that an exception occurred.
class ExceptionIndicator extends StatelessWidget {
  const ExceptionIndicator({
    required this.title,
    required this.assetName,
    this.message,
    this.onTryAgain,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? message;
  final String assetName;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => Container(
        color: context.scaffoldBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(assetName),
                const SpaceH32(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.headline5,
                ),
                if (message != null) ...[
                  const SpaceH16(),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: context.bodyText1,
                  ),
                ],
                if (onTryAgain != null) ...[
                  const SpaceH16(),
                  SizedBox(
                    height: Sizes.HEIGHT_50,
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: onTryAgain,
                      icon: const Icon(Iconsax.refresh),
                      label: const Text(
                        AppStrings.TRY_AGAIN,
                        style: TextStyle(fontSize: Sizes.HEIGHT_16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}
