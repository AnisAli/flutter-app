import '../../exports/index.dart';

enum ButtonType {
  outline,
  outlineWithImage,
  text,
  textWithImage,
  image,
  loading,
  multiText,
}

class CustomButton extends StatelessWidget {
  final Color color;
  final bool hasInfiniteWidth;
  final Color textColor;
  final String text;
  final Widget? image;
  final VoidCallback? onPressed;
  final Widget? loadingWidget;
  final ButtonType buttonType;
  final double buttonRadius;
  final double verticalMargin;
  final String? secondaryText;
  final TextStyle? secondaryTextStyle;
  final BoxConstraints? constraints;
  final TextStyle? customTextStyle;
  final FontWeight? fontWeight;
  final double borderWidth;
  final EdgeInsets buttonPadding;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    this.onPressed,
    required this.hasInfiniteWidth,
    this.image,
    this.loadingWidget,
    this.buttonType = ButtonType.text,
    this.buttonRadius = Sizes.RADIUS_12,
    this.verticalMargin = Sizes.PADDING_8,
    this.secondaryText,
    this.secondaryTextStyle,
    this.constraints = const BoxConstraints(
      minWidth: 43,
      minHeight: 40,
      maxWidth: 43,
      maxHeight: 60,
    ),
    this.customTextStyle,
    this.fontWeight,
    this.borderWidth = 1.5,
    this.buttonPadding = const EdgeInsets.all(Sizes.PADDING_14),
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalMargin),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: hasInfiniteWidth ? double.infinity : 0,
        ),
        child: getButtonWidget(context),
      ),
    );
  }

  Widget getButtonWidget(BuildContext context) {
    TextStyle textStyle = context.subtitle1.copyWith(
      color: textColor,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: 1.0,
      fontSize: context.titleLarge.fontSize,
      fontFamily: 'Montserrat',
    );
    switch (buttonType) {
      case ButtonType.outline:
        return buildOutlinedButton(
          textStyle: customTextStyle ?? textStyle,
          child: Text(
            text,
            style: customTextStyle ?? textStyle,
            textAlign: TextAlign.center,
          ),
        );
      case ButtonType.outlineWithImage:
        return buildOutlinedButton(
          textStyle: textStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: Sizes.PADDING_12),
                child: image,
              ),
              Text(
                text,
                style: customTextStyle ?? textStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case ButtonType.text:
        return buildTextButton(
          textStyle: textStyle,
          child: Text(
            text,
            style: customTextStyle ?? textStyle,
            textAlign: TextAlign.center,
          ),
        );
      case ButtonType.textWithImage:
        return buildTextButton(
          textStyle: textStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: Sizes.PADDING_12),
                child: image,
              ),
              Text(
                text,
                style: customTextStyle ?? textStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      case ButtonType.image:
        return buildTextButton(
          textStyle: textStyle,
          child: image!,
        );
      case ButtonType.loading:
        return buildTextButton(
          textStyle: textStyle,
          child: isLoading
              ? loadingWidget == null
                  ? SizedBox(
                      height: Sizes.HEIGHT_30,
                      width: Sizes.WIDTH_30,
                      child: CircularProgressIndicator(
                        color: context.buttonTextColor,
                        strokeWidth: 3,
                      ),
                    )
                  : loadingWidget!
              : Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
        );
      case ButtonType.multiText:
        return buildTextButton(
          textStyle: textStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: Sizes.PADDING_4),
                child: Text(
                  secondaryText!,
                  style: secondaryTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      default:
        return buildTextButton(
          textStyle: textStyle,
          child: loadingWidget == null
              ? Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                )
              : loadingWidget!,
        );
    }
  }

  TextButton buildTextButton({
    required TextStyle textStyle,
    required Widget child,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        minimumSize: Size(
          constraints?.minWidth ?? 0.0,
          constraints?.minHeight ?? 0.0,
        ),
        maximumSize: Size(
          constraints?.maxWidth ?? 0.0,
          constraints?.maxHeight ?? 0.0,
        ),
      ),
      onPressed: !isLoading ? onPressed : null,
      child: child,
    );
  }

  OutlinedButton buildOutlinedButton({
    required TextStyle textStyle,
    required Widget child,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: borderWidth, color: color),
        padding: buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          side: BorderSide(color: color),
        ),
        minimumSize: Size(
          constraints?.minWidth ?? 0.0,
          constraints?.minHeight ?? 0.0,
        ),
        maximumSize: Size(
          constraints?.maxWidth ?? 0.0,
          constraints?.maxHeight ?? 0.0,
        ),
      ),
      onPressed: !isLoading ? onPressed : null,
      child: child,
    );
  }
}
