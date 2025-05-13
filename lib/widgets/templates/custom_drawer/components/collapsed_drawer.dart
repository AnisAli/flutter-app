import '../../../../exports/index.dart';
import '../drawer_model.dart';
import 'expanded_drawer.dart';

class CollapsedDrawer extends GetView<MyDrawerController> {
  final double subMenuWidth = 250;
  final Color unSelectedColorLight = LightTheme.darkShade3;
  final Color unSelectedColorDark = DarkTheme.textColor;

  CollapsedDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return blackIconMenu(context);
  }

  Widget blackIconMenu(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
      width: 100,
      color: context.scaffoldBackgroundColor,
      child: Column(
        children: [
          _controlButton(context).addRepaintBoundary,
          Expanded(
            child: ListView.builder(
              itemCount: controller.drawerItemsList.length,
              itemBuilder: (context, index) {
                DrawerModel drawerItem = controller.drawerItemsList[index];

                if (drawerItem.title.isNotEmpty) {
                  return Obx(() => _buildMenuButton(
                        context,
                        index,
                        drawerItem,
                        controller.selectedIndex.value == index,
                      ));
                } else {
                  return ExpandedDrawer().buildDivider();
                }
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              color: context.canvasColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: accountButton(context),
              ),
            ),
          ),
        ],
      ).addRepaintBoundary,
    );
  }

  InkWell _buildMenuButton(
    BuildContext context,
    int index,
    DrawerModel drawerItem,
    bool selected,
  ) {
    return InkWell(
      onTap: () => controller.onSelectionChange(index, drawerItem),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? context.backgroundColor : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: drawerItem.iconPath != null
              ? SvgPicture.asset(
                  drawerItem.iconPath!,
                  color: selected
                      ? context.primaryColor
                      : context.isDark
                          ? unSelectedColorDark
                          : drawerItem.iconColor ?? unSelectedColorLight,
                  height: 45,
                )
              : Icon(
                  drawerItem.icon,
                  color: selected
                      ? context.primaryColor
                      : context.isDark
                          ? unSelectedColorDark
                          : drawerItem.iconColor ?? unSelectedColorLight,
                ),
        ),
      ),
    );
  }

  Widget invisibleSubMenus(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      width: controller.isExpanded.value ? 0 : subMenuWidth,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: controller.closeDrawer,
        child: Column(
          children: [
            Container(height: 90 + controller.selectedIndex.toDouble() * 5),
            Expanded(
              child: ListView.builder(
                itemCount: controller.drawerItemsList.length,
                itemBuilder: (context, index) {
                  DrawerModel drawerItem = controller.drawerItemsList[index];
                  // if(index == 0) return Container(height:95);
                  // control button has 45 h + 20 top + 30 bottom = 95

                  bool selected = controller.selectedIndex.value == index;
                  bool isValidSubMenu =
                      selected && drawerItem.submenus.isNotEmpty;
                  return _subMenuWidget(
                    context,
                    drawerItem,
                    [...drawerItem.submenus],
                    isValidSubMenu,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subMenuWidget(
    BuildContext context,
    DrawerModel parentMenu,
    List<DrawerModel> submenus,
    bool isValidSubMenu,
  ) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      height: isValidSubMenu ? submenus.length.toDouble() * 55 : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isValidSubMenu
            ? context.scaffoldBackgroundColor
            : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: isValidSubMenu ? submenus.length : 0,
        itemBuilder: (context, index) {
          DrawerModel subMenu = submenus[index];
          return Obx(
            () => sMenuButton(
              context: context,
              subMenu: subMenu,
              subMenuIndex: index,
              button: subMenu.title == AppStrings.DARK_MODE
                  ? GetBuilder<ThemeController>(
                      init: ThemeController(),
                      builder: (themeController) => CupertinoSwitch(
                        activeColor: context.primaryColor,
                        value: themeController.isDarkMode.value,
                        onChanged: themeController.changeThemeMode,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }

  Widget sMenuButton({
    required BuildContext context,
    required DrawerModel subMenu,
    required int subMenuIndex,
    Widget? button,
  }) {
    return GestureDetector(
      onTap: () => controller.onSubMenuSelectionChange(subMenuIndex, subMenu),
      child: Padding(
        padding: const EdgeInsets.only(
          top: Sizes.PADDING_4,
          bottom: Sizes.PADDING_4,
          left: Sizes.PADDING_8,
        ),
        child: _buildSubMenuListTile(
          context: context,
          subMenuItem: subMenu,
          isSelected: subMenuIndex == controller.subMenuSelectedIndex.value,
          trailing: button,
        ),
      ),
    );
  }

  Widget _buildSubMenuListTile({
    required BuildContext context,
    required DrawerModel subMenuItem,
    bool isSelected = false,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: Sizes.PADDING_16),
      minVerticalPadding: Sizes.PADDING_0,
      minLeadingWidth: Sizes.WIDTH_16,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
      ),
      selected: isSelected,
      selectedTileColor: context.backgroundColor,
      leading: _getLeadingIcon(context, subMenuItem, isSelected),
      title: _buildTitleText(
        context: context,
        drawerItem: subMenuItem,
        selected: isSelected,
      ),
      trailing: trailing != null
          ? Padding(
              padding: const EdgeInsets.only(right: Sizes.PADDING_8),
              child: trailing,
            )
          : const SizedBox.shrink(),
    );
  }

  Text _buildTitleText({
    required BuildContext context,
    required DrawerModel drawerItem,
    bool showTitle = false,
    bool selected = false,
  }) {
    return Text(
      drawerItem.title,
      style: context.bodyMedium.copyWith(
        fontSize: showTitle ? Sizes.TEXT_SIZE_16 : Sizes.TEXT_SIZE_14,
        color: showTitle
            ? context.primaryColor
            : selected
                ? context.bodyLarge.color
                : context.isDark
                    ? unSelectedColorDark
                    : unSelectedColorLight,
        fontWeight: showTitle ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _getLeadingIcon(
    BuildContext context,
    DrawerModel item,
    bool isSelected,
  ) {
    return CircleAvatar(
      radius: 3.5,
      backgroundColor: isSelected
          ? context.primaryColor
          : context.isDark
              ? unSelectedColorDark
              : unSelectedColorLight,
    );
  }

  Widget _controlButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Sizes.PADDING_40,
        bottom: Sizes.PADDING_20,
      ),
      child: InkWell(
        onTap: controller.expandOrShrinkDrawer,
        child: Container(
          height: Sizes.HEIGHT_46,
          width: Sizes.HEIGHT_46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(Sizes.RADIUS_6),
          ),
          child: const AppLogo(size: Sizes.SIZE_36),
        ),
      ),
    );
  }

  Widget accountButton(BuildContext context, {bool usePadding = true}) {
    return Padding(
      padding: EdgeInsets.all(usePadding ? Sizes.PADDING_8 : Sizes.PADDING_0),
      child: SizedBox(
        width: double.infinity,
        child: AdvancedAvatar(
          name: AuthManager.instance.user.value?.displayName,
          size: Sizes.ICON_SIZE_50,
          style: context.titleLarge.copyWith(
            letterSpacing: Sizes.PADDING_2,
            color: context.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          decoration: BoxDecoration(
            color: context.isDark
                ? DarkTheme.backgroundColorDark
                : LightTheme.backgroundColorLight,
            border: Border.all(color: context.primaryColor, width: 2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
