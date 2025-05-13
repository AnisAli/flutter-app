import '../exports/pub_widgets.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  static bool isMobile() => Get.width < 650;

  static bool isTablet() => Get.width < 1400 && Get.width >= 650;

  static bool isDesktop() => Get.width >= 1400;

  static T getResponsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop()) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet()) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  static void getResponsiveCallBack({
    required VoidCallback mobile,
    VoidCallback? tablet,
    VoidCallback? desktop,
  }) {
    if (isDesktop()) {
      (desktop ?? tablet ?? mobile)();
    } else if (isTablet()) {
      (tablet ?? mobile)();
    } else {
      mobile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // print("Get.height : ${Get.height}");
        // print("Get.width : ${Get.width}");
        // print("Get.context!.height : ${Get.context!.height}");
        // print("Get.context!.width :*/ ${Get.context!.width}");
        // print("constraints.minWidth : ${constraints.minWidth}");
        // print("constraints.maxWidth : ${constraints.maxWidth}");

        if (Get.width >= 1400) {
          return desktop ?? tablet ?? mobile;
        } else if (Get.width >= 650) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
