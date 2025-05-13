import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';

import '../../exports/index.dart';

class ThemeController extends GetxController {
  final box = GetStorage(AppStrings.THEME_BOX_KEY);

  late Rx<Color> accentColor;
  late Rx<bool> isDarkMode;
  bool get isDark => isDarkMode.value;

  @override
  void onInit() {
    isDarkMode = getSystemDefaultTheme().obs;
    box.writeIfNull(AppStrings.THEME_MODE_KEY, isDarkMode.value);

    accentColor = getColors[5].obs;
    box.writeIfNull(AppStrings.THEME_ACCENT_KEY, colorToInt(accentColor.value));

    accentColor.value = intToColor(box.read(AppStrings.THEME_ACCENT_KEY));
    isDarkMode.value = box.read(AppStrings.THEME_MODE_KEY);

    super.onInit();
  }

  List<Color> get getColors =>
      Get.isDarkMode ? LightTheme.accentColors : DarkTheme.accentColors;

  intToColor(int indexColor) => getColors.elementAt(indexColor);

  int colorToInt(Color color) => getColors.indexWhere((item) => item == color);

  void changeThemeMode(bool val) {
    isDarkMode.value = val;
    box.write(AppStrings.THEME_MODE_KEY, isDarkMode.value);

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.light : ThemeMode.dark);
  }

  void changeAccent(Color color) {
    accentColor.value = color;
    box.write(AppStrings.THEME_ACCENT_KEY, colorToInt(accentColor.value));
    Get.changeTheme(getTheme);
  }

  bool getSystemDefaultTheme() =>
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

  ThemeData get getTheme => AppTheme.build(
        isDarkMode: isDarkMode.value,
        brightness: Get.isDarkMode ? Brightness.dark : Brightness.light,
        swatchColors: MaterialColor(
          accentColor.value.value,
          AppTheme.getSwatch(accentColor.value),
        ),
        primaryColor: accentColor.value,
      );
}
