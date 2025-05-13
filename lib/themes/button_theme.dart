part of themes;

ElevatedButtonThemeData elevatedButtonTheme({
  required Color primaryColor,
}) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(Sizes.PADDING_20),
        foregroundColor: primaryColor,
        minimumSize: const Size(double.infinity, Sizes.HEIGHT_32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Sizes.RADIUS_12)),
        ),
      ),
    );

TextButtonThemeData textButtonTheme({
  required Color primaryColor,
}) =>
    TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryColor),
    );

OutlinedButtonThemeData outlinedButtonTheme({
  required Color primaryColor,
  required Color borderColor,
}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(Sizes.PADDING_20),
      foregroundColor: primaryColor,
      minimumSize: const Size(double.infinity, Sizes.HEIGHT_32),
      side: BorderSide(width: 1.5, color: borderColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.RADIUS_12),
        ),
      ),
    ),
  );
}
