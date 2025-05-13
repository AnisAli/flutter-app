import '../../../exports/index.dart';

class AppBackButton extends StatelessWidget {
  // true if the page is a cupertino full screen dialog (mrt page)
  // so the chevron points downwards, and text is "done" instead of "back"
  final bool fullScreen;
  final bool x;
  const AppBackButton({
    super.key,
    this.fullScreen = false,
    this.x = false,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon = x
        ? Icons.close_rounded
        : (fullScreen
            ? Icons.keyboard_arrow_down_rounded
            : Icons.arrow_back_ios_rounded);
    final String text = x ? "" : (fullScreen ? "Done" : "Back");

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(1000.0),
        onTap: Get.back,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.PADDING_16,
            vertical: Sizes.PADDING_10,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2 - 0.05),
            borderRadius: BorderRadius.circular(1000.0),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Padding(
                // if has the x, not padding
                padding: x
                    ? const EdgeInsets.all(0.0)
                    : const EdgeInsets.only(right: Sizes.PADDING_10),
                child: Icon(
                  icon,
                  size: Sizes.ICON_SIZE_16,
                ),
              ),
              Text(
                text,
                style: context.bodySmall.copyWith(
                  fontSize: Sizes.TEXT_SIZE_16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
