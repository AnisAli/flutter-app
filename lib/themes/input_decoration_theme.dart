part of themes;

InputDecorationTheme inputDecorationTheme({
  required Color primaryColor,
  required Color errorColor,
  required Color fillColor,
  required Color hintColor,
}) =>
    InputDecorationTheme(
      fillColor: fillColor,
      filled: true,
      hintStyle: TextStyle(color: hintColor),
      border: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusedBorder: focusedOutlineInputBorder(primaryColor: primaryColor),
      errorBorder: errorOutlineInputBorder(errorColor: errorColor),
      focusedErrorBorder: focusErrorOutlineInputBorder(errorColor: errorColor),
    );

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(Sizes.RADIUS_12)),
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
);

OutlineInputBorder focusedOutlineInputBorder({
  required Color primaryColor,
}) =>
    OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.RADIUS_12)),
      borderSide: BorderSide(color: primaryColor),
    );

OutlineInputBorder errorOutlineInputBorder({
  required Color errorColor,
}) =>
    OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.RADIUS_12)),
      borderSide: BorderSide(color: errorColor),
    );

OutlineInputBorder focusErrorOutlineInputBorder({
  required Color errorColor,
}) =>
    OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.RADIUS_12)),
      borderSide: BorderSide(color: errorColor, width: 1.5),
    );

OutlineInputBorder secondaryOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(Sizes.RADIUS_12)),
    borderSide: BorderSide(
      color: context.bodyText1.color!.withOpacity(0.15),
    ),
  );
}
