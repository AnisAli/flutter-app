part of themes;

class LightTheme {
  static const List<Color> accentColors = [
    Color(0xffff3b30),
    Color(0xffff9500),
    Color(0xffffcc00),
    Color(0xff34c759),
    Color(0xff00c7be),
    Color(0xff30b0c7),
    Color(0xff32ade6),
    Color(0xff007aff),
    Color(0xff5856d6),
    Color(0xffaf52de),
    Color(0xffff2d55),
    Color(0xffa2845e),
  ];

  static const List<Color> grayColors = [
    Color(0xff8e8e93),
    Color(0xffaeaeb2),
    Color(0xffc7c7cc),
    Color(0xffd1d1d6),
    Color(0xffe5e5ea),
    Color(0xfff2f2f7),
  ];

  static Color get grayColorShade0 => grayColors[0];
  static Color get grayColorShade1 => grayColors[1];
  static Color get grayColorShade2 => grayColors[2];
  static Color get grayColorShade3 => grayColors[3];
  static Color get grayColorShade4 => grayColors[4];
  static Color get grayColorShade5 => grayColors[5];

  static const List<Color> backgroundColors = [
    Color(0xffffffff),
    Color(0xfff6f6f6),
    Color(0xffeeeeee),
    Color(0xff676767),
  ];

  static Color get darkShade0 => backgroundColors[0];
  static Color get darkShade1 => backgroundColors[1];
  static Color get darkShade2 => backgroundColors[2];
  static Color get darkShade3 => backgroundColors[3];

  // SCAFFOLD
  static const Color scaffoldBackgroundColor = Color(0xFFFFFFFF);
  static Color backgroundColor = grayColorShade5;
  static Color onBackground = grayColorShade1;
  static Color backgroundColorLight = grayColorShade4;
  static Color canvasColor = grayColorShade4;
  static const Color cardColor = Color(0xFFF1F3F6);
  static const Color dividerColor = Color(0xff686868);

  // ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = Colors.black87;

  // BUTTON
  static const Color buttonTextColor = Colors.white;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  // TEXT
  static const Color textColor = Colors.black87;
  static const Color bodyTextColor = Colors.black;
  static const Color headlinesTextColor = Colors.black;
  static const Color captionTextColor = Colors.grey;
  static const Color hintTextColor = Color(0xff686868);

  static const Color fillColor = Color(0xfff7f7f7);

  // Shimmers
  static const Color shimmerBaseColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color shimmerHighlightColor = Color(0x44CCCCCC);

  // CHIP
  static const Color chipTextColor = Colors.white;

  // PROGRESS BAR INDICATOR
  static const Color progressIndicatorColor = Color(0xFF40A76A);

  static const Color errorColor = Color(0xFFD42D21);
}
