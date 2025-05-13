import '../../../exports/index.dart';

class ThemeButton extends GetView<ThemeController> {
  const ThemeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(1000.0),
        onTap: () => showThemeDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.PADDING_4,
            vertical: Sizes.PADDING_4,
          ),
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(1000.0),
          ),
          child: const Icon(
            Icons.palette_sharp,
            size: Sizes.ICON_SIZE_30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FluidDialog(
        edgePadding: const EdgeInsets.only(
          top: Sizes.PADDING_70,
          right: Sizes.PADDING_16,
        ),
        alignmentCurve: Curves.easeInOutCubicEmphasized,
        sizeDuration: const Duration(milliseconds: 300),
        alignmentDuration: const Duration(milliseconds: 600),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 50),
        // Configuring how the dialog looks.
        defaultDecoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Sizes.RADIUS_12),
        ),
        // Setting the first dialog page.
        rootPage: FluidDialogPage(
          alignment: Alignment.topRight,
          builder: (context) => const ThemeDialog(),
        ),
      ),
    );
  }
}

class ThemeDialog extends GetView<ThemeController> {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.PADDING_16,
          vertical: Sizes.PADDING_12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Obx(
                  () => AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: Icon(
                      CupertinoIcons.moon_stars,
                      color: context.primaryColor,
                    ),
                    secondChild: Icon(
                      CupertinoIcons.sun_max_fill,
                      color: context.primaryColor,
                    ),
                    crossFadeState: controller.isDarkMode.value
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                ),
                const SpaceW12(),
                Text(
                  AppStrings.CHANGE_THEME,
                  style: context.titleMedium,
                ),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              visualDensity: const VisualDensity(vertical: -2),
              title: Text(
                AppStrings.DARK_MODE,
                style: context.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Obx(
                () => CupertinoSwitch(
                  activeColor: context.primaryColor,
                  value: controller.isDarkMode.value,
                  onChanged: controller.changeThemeMode,
                ),
              ),
            ),
            const Divider(),
            Text(
              AppStrings.ACCENTS,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SpaceH8(),
            Obx(
              () => Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: Sizes.PADDING_10,
                runSpacing: Sizes.PADDING_10,
                children: controller.getColors
                    .map(
                      (color) => _buildAccentButton(
                        context: context,
                        color: color,
                        isCurrent: controller.accentColor.value == color,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SpaceH8(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccentButton({
    required BuildContext context,
    required Color color,
    bool isCurrent = false,
  }) {
    return InkWell(
      onTap: () => controller.changeAccent(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isCurrent ? color : context.cardColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: isCurrent ? 30 : 17,
          width: isCurrent ? 30 : 17,
          decoration: BoxDecoration(
            color: isCurrent ? context.cardColor : color,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
