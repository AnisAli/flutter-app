part of 'constants.dart';

class Decorations {
  static customBoxDecoration({
    double blurRadius = 5,
    Color color = const Color(0xFFD6D7FB),
  }) {
    return BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: blurRadius, color: color)]);
  }

  static buttonBoxDecoration({
    required Color color,
  }) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Get.find<ThemeController>().isDarkMode.value
              ? color.withOpacity(0.3)
              : color.withOpacity(0.53),
          blurRadius: 20.0,
          offset: const Offset(0.0, 5.0),
          spreadRadius: -5,
        ),
      ],
    );
  }
}
