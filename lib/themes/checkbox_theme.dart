part of themes;

CheckboxThemeData checkboxTheme({
  required Color primaryColor,
  required Color borderColor,
}) =>
    CheckboxThemeData(
      fillColor: MaterialStateProperty.all(primaryColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.RADIUS_10),
        ),
      ),
      side: BorderSide(color: borderColor),
    );
