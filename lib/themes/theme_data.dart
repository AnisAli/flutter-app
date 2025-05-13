part of themes;

AppBarTheme appBarTheme({
  required Color primaryColor,
  required Color appBarColor,
}) =>
    AppBarTheme(
      backgroundColor: appBarColor,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(
        fontSize: Sizes.TEXT_SIZE_16,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );

ScrollbarThemeData scrollbarTheme({
  required Color primaryColor,
}) =>
    ScrollbarThemeData(
      trackColor: MaterialStateProperty.all(primaryColor),
    );

DataTableThemeData dataTableTheme({
  required Color primaryColor,
  required Color textColor,
}) =>
    DataTableThemeData(
      columnSpacing: 24,
      headingRowColor: MaterialStateProperty.all(primaryColor),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.RADIUS_20)),
        border: Border.all(color: primaryColor),
      ),
      dataTextStyle: TextStyle(
        fontSize: Sizes.TEXT_SIZE_12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
