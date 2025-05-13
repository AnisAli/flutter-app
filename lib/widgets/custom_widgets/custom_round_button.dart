import '../../exports/index.dart';

class CustomRoundButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool contrast;
  final bool isLoading;
  final bool isLoadingButton;
  final Color? fillColor;
  final VoidCallback? onLongPressed;

  const CustomRoundButton(
      {Key? key,
      this.onPressed,
      this.onLongPressed,
      required this.text,
      required this.contrast,
        this.fillColor,
      this.isLoading = false,
      this.isLoadingButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: !isLoading ? onPressed : null,
        onLongPress: !isLoading ? onLongPressed : null,
        child: Container(
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: context.primary,
              ),
              color: fillColor ?? (contrast ? context.scaffoldBackgroundColor : context.primary),
              borderRadius: BorderRadius.circular(25),
            ),
            child: _buildLoadingButton(context)));
  }

  Widget _buildSimpleButton(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: context.titleMedium
          .copyWith(color: contrast ? context.primary : Colors.white),
    );
  }

  Widget _buildLoadingButton(BuildContext context) {
    return !isLoading
        ? Text(
            text,
            textAlign: TextAlign.center,
            style: context.titleMedium
                .copyWith(color: contrast ? context.primary : Colors.white),
          )
        : SizedBox(
            height: Sizes.HEIGHT_30,
            width: Sizes.WIDTH_30,
            child: CircularProgressIndicator(
              color: contrast ? context.primary : context.buttonTextColor,
              strokeWidth: 3,
            ),
          );
  }
}
