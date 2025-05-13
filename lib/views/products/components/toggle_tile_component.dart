import '../../../exports/index.dart';

class ToggleTileComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final Function(bool)? onChanged;
  const ToggleTileComponent(
      {Key? key,
      required this.value,
      required this.title,
      required this.icon,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.PADDING_6),
      child: Material(
        color: context.fillColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.RADIUS_12),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            size: Sizes.ICON_SIZE_22,
            color: context.primaryColor,
          ),
          title: Text(
            title,
            style: context.bodyLarge.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: CupertinoSwitch(
            activeColor: context.primaryColor,
            value: value,
            onChanged: onChanged,
          ),
          horizontalTitleGap: Sizes.PADDING_14,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: Sizes.PADDING_12),
          minVerticalPadding: 0,
          minLeadingWidth: 0,
          visualDensity: const VisualDensity(vertical: -Sizes.PADDING_2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.RADIUS_12),
          ),
        ),
      ),
    );
  }
}
