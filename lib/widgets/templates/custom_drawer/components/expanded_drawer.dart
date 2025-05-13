import '../../../../exports/index.dart';
import '../drawer_model.dart';
import 'collapsed_drawer.dart';

class ExpandedDrawer extends GetView<MyDrawerController> {
  final double expandedWidth = 300;
  final Color unSelectedColorLight = LightTheme.darkShade3;
  final Color unSelectedColorDark = DarkTheme.textColor;

  ExpandedDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return blackIconTiles(context);
  }

  Widget blackIconTiles(BuildContext context) {
    return Container(
      width: expandedWidth,
      color: context.scaffoldBackgroundColor,
      child: Column(
        children: [
          _controlTile(context),
          Expanded(child: _buildExpansionPanel(context)),
          _accountTile(context).addRepaintBoundary,
        ],
      ),
    );
  }

  Widget _buildExpansionPanel(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<ThemeController>(
        builder: (themeController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_10),
            child: Obx(
              () => EnhanceExpansionPanelList(
                elevation: Sizes.ELEVATION_0,
                expandedHeaderPadding: EdgeInsets.zero,
                materialGap: Sizes.PADDING_4,
                animationDuration: const Duration(milliseconds: 300),
                expansionCallback: controller.onExpansionCallback,
                children: List.generate(
                  controller.drawerItemsList.length,
                  (index) {
                    DrawerModel drawerItem = controller.drawerItemsList[index];
                    bool selected = controller.selectedIndex.value == index;

                    return EnhanceExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: index == controller.selectedIndex.value &&
                          drawerItem.submenus.isNotEmpty,
                      arrowPadding: EdgeInsets.zero,
                      arrowPosition: EnhanceExpansionPanelArrowPosition.none,
                      backgroundColor: context.scaffoldBackgroundColor,
                      headerBuilder: (context, isExpanded) {
                        return _buildHeader(
                          context,
                          index,
                          drawerItem,
                          isExpanded || selected,
                        ).addRepaintBoundary;
                      },
                      body: Padding(
                        padding: const EdgeInsets.only(left: Sizes.PADDING_8),
                        child: Column(
                          children: _buildSubMenuButtons(
                            context,
                            drawerItem,
                            themeController,
                          ),
                        ),
                      ).addRepaintBoundary,
                    );
                  },
                ),
              ),
            ).addRepaintBoundary,
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int index,
    DrawerModel drawerItem,
    bool isExpanded,
  ) {
    // TODO : Add IgnorePointer when submenu is empty to make tile selected colored
    return drawerItem.title.isNotEmpty
        ? GestureDetector(
            onTap: () => controller.onSelectionChange(index, drawerItem),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                left: Sizes.PADDING_12,
              ),
              minVerticalPadding: Sizes.PADDING_0,
              minLeadingWidth: Sizes.WIDTH_30,
              visualDensity: const VisualDensity(
                horizontal: -4,
                // vertical:  -4 ,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
              ),
              selected: isExpanded,
              selectedTileColor: context.backgroundColor,
              leading: _getLeadingIcon(context, drawerItem, isExpanded),
              title: _buildTitleText(
                context: context,
                title: drawerItem.title,
                selected: isExpanded,
              ),
              trailing: _getTrailingIcon(context, drawerItem, isExpanded),
            ),
          )
        : buildDivider();
  }

  Divider buildDivider() {
    return const Divider(
      thickness: 1.0,
      endIndent: Sizes.PADDING_32,
      indent: Sizes.PADDING_32,
    );
  }

  List<Widget> _buildSubMenuButtons(
    BuildContext context,
    DrawerModel drawerItem,
    ThemeController themeController,
  ) {
    return drawerItem.submenus.asMap().entries.map((subMenu) {
      return CollapsedDrawer().sMenuButton(
        context: context,
        subMenu: subMenu.value,
        subMenuIndex: subMenu.key,
        button: subMenu.value.title == AppStrings.DARK_MODE
            ? CupertinoSwitch(
                activeColor: context.primaryColor,
                value: themeController.isDarkMode.value,
                onChanged: themeController.changeThemeMode,
              )
            : const SizedBox.shrink(),
      );
    }).toList();
  }

  Text _buildTitleText({
    required BuildContext context,
    String? title,
    bool selected = false,
  }) {
    return Text(
      title ?? "",
      style: context.bodyLarge.copyWith(
        color: selected
            ? context.bodyLarge.color
            : context.isDark
                ? unSelectedColorDark
                : unSelectedColorLight,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _getLeadingIcon(
    BuildContext context,
    DrawerModel item,
    bool isSelected,
  ) {
    return item.iconPath != null
        ? SvgPicture.asset(
            item.iconPath!,
            color: isSelected
                ? context.primaryColor
                : context.isDark
                    ? unSelectedColorDark
                    : item.iconColor ?? unSelectedColorLight,
          )
        : Icon(
            item.icon,
            color: isSelected
                ? context.primaryColor
                : context.isDark
                    ? unSelectedColorDark
                    : item.iconColor ?? unSelectedColorLight,
          );
  }

  Widget _getTrailingIcon(
    BuildContext context,
    DrawerModel item,
    bool isSelected,
  ) {
    return item.submenus.isEmpty
        ? const SizedBox.shrink()
        : Icon(
            isSelected ? Iconsax.arrow_up_15 : Iconsax.arrow_down5,
            size: Sizes.ICON_SIZE_20,
            color: isSelected
                ? context.primaryColor
                : context.isDark
                    ? unSelectedColorDark
                    : unSelectedColorLight,
          );
  }

  Widget _controlTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Sizes.PADDING_50,
        bottom: Sizes.PADDING_20,
      ),
      child: ListTile(
        leading: Container(
          height: Sizes.HEIGHT_46,
          width: Sizes.HEIGHT_46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(Sizes.RADIUS_6),
          ),
          child: const AppLogo(size: Sizes.SIZE_36),
        ),
        title: Text(
          AppStrings.APP_NAME,
          style: context.headline5.copyWith(
            fontFamily: AppStrings.MONTSERRAT,
          ),
        ),
        subtitle: Text(
          AuthManager.instance.user.value?.company?.name ?? "",
          style: context.titleMedium.copyWith(
            color: context.primaryColor,
            fontFamily: AppStrings.MONTSERRAT,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        onTap: controller.expandOrShrinkDrawer,
      ),
    );
  }

  Widget _accountTile(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: Sizes.ELEVATION_0,
      color: context.canvasColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        child: Row(
          children: [
            Expanded(
              child: CollapsedDrawer().accountButton(
                context,
                usePadding: false,
              ),
            ),
            const SpaceW8(),
            Expanded(
                flex: 3,
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthManager.instance.user.value?.displayName ?? '',
                        style: context.titleMedium.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        AuthManager.instance.user.value?.email ?? '',
                        style: context.bodyLarge.copyWith(
                          color: context.bodyLarge.color,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                )),
            Icon(
              Iconsax.user,
              color: context.primaryColor,
            ),
            const SpaceW8(),
          ],
        ),
      ),
    );
  }
}
