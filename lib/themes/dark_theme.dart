part of themes;

class DarkTheme {
  static const List<Color> accentColors = [
    Color(0xffff453a),
    Color(0xffff9f0a),
    Color(0xffffd60a),
    Color(0xff30d158),
    Color(0xff66d4cf),
    Color(0xff40c8e0),
    Color(0xff64d2ff),
    Color(0xff0a84ff),
    Color(0xff5e5ce6),
    Color(0xffbf5af2),
    Color(0xffff375f),
    Color(0xffac8e68),
  ];

  static const List<Color> grayColors = [
    Color(0xff8e8e93),
    Color(0xff636366),
    Color(0xff48484a),
    Color(0xff3a3a3c),
    Color(0xff2c2c2e),
    Color(0xff1c1c1e),
  ];

  static Color get grayColorShade0 => grayColors[0];
  static Color get grayColorShade1 => grayColors[1];
  static Color get grayColorShade2 => grayColors[2];
  static Color get grayColorShade3 => grayColors[3];
  static Color get grayColorShade4 => grayColors[4];
  static Color get grayColorShade5 => grayColors[5];

  static const List<Color> backgroundColors = [
    Color(0xff1f1f1f),
    Color(0xff434343),
    Color(0xffe5e5e5),
    Color(0xff8c8c8c),
  ];

  static Color get darkShade0 => backgroundColors[0];
  static Color get darkShade1 => backgroundColors[1];
  static Color get darkShade2 => backgroundColors[2];
  static Color get darkShade3 => backgroundColors[3];

  // static const primaryDark = Color(0xFF18172B);
  // static const primaryLight = Color(0xFF1F1F30);
  // static const Color scaffoldBackgroundColor = Color(0xFF171822);
  // static const Color scaffoldBackgroundColor = Color(0xFF212332);

  // SCAFFOLD
  // static const Color scaffoldBackgroundColor = Color(0xFF16161e);
  static Color scaffoldBackgroundColor = darkShade0;
  static Color backgroundColor = darkShade1;
  static Color onBackground = grayColorShade1;
  static Color backgroundColorDark = const Color(0xFF1F1F30);
  static const Color canvasColor = Color(0xFF232529);
  static Color cardColor = grayColorShade4;
  // static const Color cardColor = Color(0xFF1F1F30);

  static const Color dividerColor = Color(0xff686868);

  // ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = Colors.white70;

  // BUTTON
  static Color buttonTextColor = grayColorShade4;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  // TEXT
  static const Color textColor = Colors.white70;
  static const Color bodyTextColor = Colors.white70;
  static const Color headlinesTextColor = Colors.white38;
  static const Color captionTextColor = Colors.grey;
  static const Color hintTextColor = Color(0xff686868);

  static Color fillColor = grayColorShade4;

  // Shimmers
  static const Color shimmerBaseColor = Color(0xFF1D1D1D);
  static const Color shimmerHighlightColor = Color(0XFF3C4042);

  // CHIP
  static const Color chipTextColor = Colors.black87;

  // PROGRESS BAR INDICATOR
  static const Color progressIndicatorColor = Color(0xFF40A76A);

  static const Color errorColor = Color(0xFFF1291A);
}
