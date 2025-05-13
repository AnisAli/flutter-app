import '../../../exports/index.dart';

class CheckTileComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final Function()? onTap;

  const CheckTileComponent(
      {Key? key,
      required this.icon,
      required this.title,
      required this.value,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.PADDING_12, vertical: Sizes.PADDING_12),
        margin: const EdgeInsets.symmetric(vertical: Sizes.PADDING_6),
        decoration: BoxDecoration(
          color: context.fillColor,
          borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: Sizes.ICON_SIZE_22,
                  color: context.primaryColor,
                ),
                const SpaceW12(),
                Text(title,
                    style: context.bodyLarge.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: Sizes.TEXT_SIZE_16)),
              ],
            ),
            if (value)
              Icon(
                CupertinoIcons.checkmark,
                size: Sizes.ICON_SIZE_22,
                color: context.primaryColor,
              )
          ],
        ),
      ),
    );
  }
}
