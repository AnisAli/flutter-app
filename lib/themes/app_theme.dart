part of themes;

class AppTheme {
  const AppTheme._();

  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    /// if [500] is the default color, there are at LEAST five
    /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
    /// divisor of 5 would mean [50] is a lightness of 1.0 or
    /// a color of #ffffff. A value of six would be near white
    /// but not quite.
    const lowDivisor = 6;

    /// if [500] is the default color, there are at LEAST four
    /// steps above [500]. A divisor of 4 would mean [900] is
    /// a lightness of 0.0 or color of #000000
    const highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }

  static ThemeData build({
    required bool isDarkMode,
    required Brightness brightness,
    required MaterialColor swatchColors,
    required Color primaryColor,
  }) =>
      ThemeData.from(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: swatchColors).copyWith(
          onBackground:
              isDarkMode ? DarkTheme.onBackground : LightTheme.onBackground,
        ),
        textTheme: buildTextTheme(
          textColor: isDarkMode ? DarkTheme.textColor : LightTheme.textColor,
          buttonColor: isDarkMode
              ? DarkTheme.buttonTextColor
              : LightTheme.buttonTextColor,
        ),
        useMaterial3: true,
      ).copyWith(
        brightness: brightness,
        primaryColor: primaryColor,
        primaryColorLight: swatchColors.shade200,
        primaryColorDark: swatchColors.shade800,
        scaffoldBackgroundColor: isDarkMode
            ? DarkTheme.scaffoldBackgroundColor
            : LightTheme.scaffoldBackgroundColor,
        backgroundColor:
            isDarkMode ? DarkTheme.backgroundColor : LightTheme.backgroundColor,
        canvasColor:
            isDarkMode ? DarkTheme.canvasColor : LightTheme.canvasColor,
        cardColor: isDarkMode ? DarkTheme.cardColor : LightTheme.cardColor,
        dividerColor:
            isDarkMode ? DarkTheme.dividerColor : LightTheme.dividerColor,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: isDarkMode
              ? DarkTheme.progressIndicatorColor
              : LightTheme.progressIndicatorColor,
        ),
        errorColor: isDarkMode ? DarkTheme.errorColor : LightTheme.errorColor,
        inputDecorationTheme: inputDecorationTheme(
          primaryColor: primaryColor,
          errorColor: isDarkMode ? DarkTheme.errorColor : LightTheme.errorColor,
          fillColor: isDarkMode ? DarkTheme.fillColor : LightTheme.fillColor,
          hintColor: swatchColors.shade300,
        ),
        elevatedButtonTheme: elevatedButtonTheme(primaryColor: primaryColor),
        textButtonTheme: textButtonTheme(primaryColor: primaryColor),
        outlinedButtonTheme: outlinedButtonTheme(
          primaryColor: primaryColor,
          borderColor: swatchColors.shade700,
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? DarkTheme.iconColor : LightTheme.iconColor,
        ),
        scrollbarTheme: scrollbarTheme(primaryColor: primaryColor),
        dataTableTheme: dataTableTheme(
          primaryColor: primaryColor,
          textColor: swatchColors.shade400,
        ),
      );
}
