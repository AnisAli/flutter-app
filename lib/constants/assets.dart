// ignore_for_file: constant_identifier_names

part of constants;

class AppAssets {
  static const String APP_LOGO_SMALL = 'assets/icons/logo.png';
  static const String APP_LOGO_MEDIUM = 'assets/icons/logo_mid.png';
  static const String APP_LOGO_LARGE = 'assets/icons/logo_big.png';

  static const String ACCENT_LINE = 'assets/images/accent_line.png';
  static const String CONFUSED_FACE = 'assets/images/confused_face.png';
  static const String EMPTY_BOX = 'assets/images/empty_box.png';
  static const String FRUSTRATED_FACE = 'assets/images/frustrated_face.png';

  static String getSVGIcon(String iconName) => 'assets/icons/$iconName.svg';

  static String getPNGIcon(String iconName) => 'assets/icons/$iconName.png';

  static String getSVGImage(String imageName) => 'assets/images/$imageName.svg';

  static String getPNGImage(String imageName) => 'assets/images/$imageName.png';
}
