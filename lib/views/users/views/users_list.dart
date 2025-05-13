import '../../../exports/index.dart';
import '../components/user_list_card.dart';

class UsersList extends GetView<UsersListController> {
  static const String routeName = '/usersList';

  const UsersList({super.key});

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
            : _buildUsersList(context).sliverToBoxAdapter)
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildUsersList(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.usersList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () async {},
              child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.2,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) =>
                          Get.toNamed(AppRoutes.ADD_USER_LIST, arguments: {
                        "pageType": 'edit',
                        "userList": controller.usersList[index],
                      }),
                      backgroundColor: Colors.yellow.shade800,
                      foregroundColor: Colors.white,
                      icon: Icons.edit_outlined,
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                ),
                child: UserListCard(
                  userListModel: controller.usersList[index],
                ),
              ));
        },
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      actions: [_buildAddNewUserButton(context)],
      primary: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.onBackground, //change your color here
      ),
      pinned: true,
      centerTitle: true,
      title: Text(
        'Users',
        style: context.titleMedium,
      ),
    );
  }

  Widget _buildAddNewUserButton(BuildContext context) {
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
      onPressed: () => Get.toNamed(AppRoutes.ADD_USER_LIST, arguments: {
        "pageType": 'new',
        "userList": null,
      }),
      verticalMargin: 0,
      textColor: Colors.white,
      text: AppStrings.USER,
      hasInfiniteWidth: false,
    );
  }
}
