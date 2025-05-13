import '../../exports/index.dart';

class CustomTextFormField extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;

  final FocusNode? focusNode;
  final bool? autofocus;

  final String? labelText;
  final String? hintText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final Color? labelColor;

  final bool? readOnly;
  final bool isRequired;
  final bool? obscureText;
  final String obscuringCharacter;
  final String isRequiredCharacter;

  final BoxConstraints? prefixIconConstraints;
  final Widget? prefixWidget;
  final IconData? prefixIconData;
  final Color? prefixIconColor;
  final IconData? suffixIconData;
  final Color? suffixIconColor;
  final bool showClearButton;

  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onTap;
  final void Function(String?)? onSave;
  final void Function(String)? onFieldSubmit;

  final int? maxLines;
  final int? maxLength;
  final int maxValidLength;

  final TextAlign textAlign;

  final String? Function(String?)? validator;
  final String? validatorMessage;
  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Color? fillColor;
  final Color? primaryColor;

  final TextCapitalization? textCapitalization;
  final double verticalPadding;
  final EdgeInsets scrollPadding;
  final double? width;
  final double? height;
  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final bool? enabled;

  const CustomTextFormField({
    Key? key,
    this.validatorMessage,
    this.scrollPadding = const EdgeInsets.all(8),
    this.textAlign = TextAlign.start,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.labelColor,
    this.prefixIconData,
    this.prefixIconColor,
    this.suffixIconData,
    this.suffixIconColor,
    this.showClearButton = false,
    this.obscureText,
    this.onChanged,
    this.onSuffixTap,
    this.keyboardType,
    this.validator,
    this.onSave,
    this.inputFormatters,
    this.textInputAction,
    this.onEditingComplete,
    this.controller,
    this.onFieldSubmit,
    this.readOnly,
    this.isRequired = false,
    this.focusNode,
    this.maxLines,
    this.maxLength,
    this.fillColor,
    this.autofocus,
    this.textCapitalization,
    this.primaryColor,
    this.verticalPadding = Sizes.PADDING_6,
    this.width,
    this.height,
    this.enableBorderColor,
    this.focusBorderColor,
    this.maxValidLength = 70,
    this.prefixIconConstraints,
    this.prefixWidget,
    this.obscuringCharacter = '*',
    this.isRequiredCharacter = '*',
    this.onTap,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: TextFormField(
          enabled: enabled ?? true,
          controller: controller,
          textAlign: textAlign,
          cursorColor: primaryColor ?? context.primaryColor,
          cursorRadius: const Radius.circular(Sizes.RADIUS_10),
          cursorWidth: Sizes.WIDTH_1,
          decoration: buildInputDecoration(context),
          maxLengthEnforcement: MaxLengthEnforcement.enforced,

          autofocus: autofocus ?? true,
          focusNode: focusNode,

          readOnly: readOnly ?? false,
          initialValue: initialValue,
          // maxLengthEnforcement: MaxLengthEnforcement.enforced,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmit,
          // readOnly: readOnly,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,

          scrollPadding: scrollPadding,
          textCapitalization: textCapitalization ?? TextCapitalization.words,
          toolbarOptions: const ToolbarOptions(
            cut: true,
            copy: true,
            selectAll: true,
            paste: true,
          ),

          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.disabled,
          enableSuggestions: true,
          onSaved: onSave,
          validator: (value) {
            if (!isRequired) {
              return null;
            } else if (validator != null) {
              return validator!(value);
            } else if (value!.isEmpty) {
              return 'Enter ${(validatorMessage ?? labelText)}';
            } else if (value.length > maxValidLength) {
              return '$labelText should be $maxValidLength characters only.';
            }
            return null;
          },
          keyboardType: keyboardType ?? TextInputType.text,
          onChanged: onChanged,
          obscureText: obscureText ?? false,
          style: context.titleMedium.copyWith(
            color: primaryColor ?? context.titleSmall.color,
            fontWeight: FontWeight.w500,
          ),
          obscuringCharacter: obscuringCharacter,
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(Sizes.PADDING_8),
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      hintText: hintText,
      floatingLabelStyle: TextStyle(
        color: primaryColor ?? context.primaryColor,
        fontSize: Sizes.TEXT_SIZE_22,
        fontWeight: FontWeight.w500,
      ),
      label: RichText(
        text: TextSpan(
          style: context.bodyLarge.copyWith(
            color: labelColor ?? primaryColor ?? context.primaryColor,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(text: labelText),
            if (isRequired) ...[
              const WidgetSpan(child: SpaceW4()),
              TextSpan(
                text: isRequiredCharacter,
                style: context.bodyLarge.copyWith(
                  color: context.errorColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
      labelStyle: context.bodyLarge.copyWith(
        color: primaryColor ?? context.primaryColor,
        fontWeight: FontWeight.w400,
      ),

      prefixIconConstraints: prefixIconConstraints,
      prefixIcon: prefixWidget ??
          (prefixIconData != null
              ? Icon(
                  prefixIconData,
                  size: Sizes.ICON_SIZE_22,
                  color: prefixIconColor ?? context.primaryColor,
                )
              : null),
      suffixIcon: showClearButton
          ? GestureDetector(
              onTap: onSuffixTap,
              child: Icon(
                Iconsax.close_circle5,
                size: Sizes.ICON_SIZE_20,
                color: LightTheme.grayColorShade0,
              ),
            )
          : suffixIconData != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    suffixIconData,
                    size: Sizes.ICON_SIZE_20,
                    color: suffixIconColor ?? context.primaryColor,
                  ),
                )
              : null,

      enabledBorder: context.enabledBorder,
      focusedBorder: context.focusedBorder,

      fillColor: fillColor ?? context.fillColor,

      filled: true,
      alignLabelWithHint: false,
      focusColor: focusBorderColor ?? context.primary,

      focusedErrorBorder: context.focusedErrorBorder,
      errorBorder: context.errorBorder,
      errorStyle: context.bodySmall.copyWith(color: context.errorColor),

      // contentPadding: maxLines == null
      //     ? const EdgeInsets.all(8)
      //     : const EdgeInsets.symmetric(vertical: 15),
    );
  }
}
