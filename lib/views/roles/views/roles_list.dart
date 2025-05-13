import 'package:otrack/views/roles/components/role_list_card.dart';
import '../../../exports/index.dart';

class RolesList extends GetView<RolesListController> {
  static const String routeName = '/rolesList';

  const RolesList({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      showMenuButton: false,
      showThemeButton: false,
      overscroll: false,
      scaffoldKey: controller.scaffoldKey,
      simpleAppBar: _buildSimpleAppBar(context),
      children: [
        Obx(() => controller.isShimmerEffectLoading.value
            ? const ProductShimmer().sliverToBoxAdapter
            : _buildRolesList(context).sliverToBoxAdapter)
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildRolesList(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.rolesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) =>
                      Get.toNamed(AppRoutes.ADD_ROLE, arguments: {
                    "pageType": 'edit',
                    "role": controller.rolesList[index],
                  }),
                  backgroundColor: Colors.yellow.shade800,
                  foregroundColor: Colors.white,
                  icon: Icons.edit_outlined,
                  padding: const EdgeInsets.all(5),
                ),
                if (controller.rolesList[index].isCoreRole != true)
                  SlidableAction(
                    onPressed: (BuildContext context) async {
                      controller.isShimmerEffectLoading(true);
                      await controller
                          .deleteRole(controller.rolesList[index].id);
                      controller.isShimmerEffectLoading(false);
                    },
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    padding: const EdgeInsets.all(5),
                  ),
              ],
            ),
            child: RoleListCard(
              roleListModel: controller.rolesList[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      actions: [_buildAddNewRoleButton(context)],
      primary: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.onBackground, //change your color here
      ),
      pinned: true,
      centerTitle: true,
      title: Text(
        AppStrings.ROLES,
        style: context.titleMedium,
      ),
    );
  }

  Widget _buildAddNewRoleButton(BuildContext context) {
    return CustomButton(
      buttonType: ButtonType.textWithImage,
      constraints: const BoxConstraints(minWidth: 100),
      color: context.primaryColor,
      image: const Icon(Iconsax.add, color: Colors.white),
      buttonPadding: const EdgeInsets.symmetric(
        vertical: Sizes.PADDING_8,
        horizontal: Sizes.PADDING_12,
      ),
      customTextStyle: context.titleMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      onPressed: () => Get.toNamed(AppRoutes.ADD_ROLE, arguments: {
        "pageType": 'new',
        "role": null,
      }),
      verticalMargin: 0,
      textColor: Colors.white,
      text: AppStrings.ROLE,
      hasInfiniteWidth: false,
    );
  }
}
