import '../../exports/pub_widgets.dart';
import '../../exports/utils_exports.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.actions,
    this.backFunction,
    this.showBack = true,
    this.leading,
    this.textStyle,
    this.backgroundColor,
    this.iconColor,
    Key? key,
  }) : super(key: key);
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final VoidCallback? backFunction;
  final Widget? leading;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: textStyle ??
            context.headlineSmall.copyWith(
              fontSize: 22,
              color: iconColor ?? context.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
      actions: actions,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? InkWell(
              onTap: backFunction ?? Get.back,
              child: leading ??
                  Icon(
                    CupertinoIcons.back,
                    color: iconColor ?? context.primaryColorDark,
                    size: 25,
                  ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
