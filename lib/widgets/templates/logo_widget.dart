import '../../exports/index.dart';

class AppLogo extends StatelessWidget {
  final Color? color;
  final double size;

  const AppLogo({
    Key? key,
    this.color,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.APP_LOGO_MEDIUM,
      color: color,
      width: size,
      height: size,
    );
  }
}
