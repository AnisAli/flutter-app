import '../../../exports/index.dart';

class MenuButton extends GetView<MyDrawerController> {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    const IconData icon = Iconsax.menu_1;
    const String text = "Menu";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(1000.0),
        onTap: controller.openDrawer,
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
              const Padding(
                padding: EdgeInsets.only(right: Sizes.PADDING_10),
                child: Icon(
                  icon,
                  size: Sizes.ICON_SIZE_18,
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
