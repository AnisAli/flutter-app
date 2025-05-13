import '../../exports/index.dart';

class HomePage extends GetView<AuthManager> {
  static const String routeName = '/home';

  final HomePageController homePageController = Get.put(HomePageController());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      scaffoldKey: GlobalKey<ScaffoldState>(),
      overscroll: false,
      showThemeButton: false,
      customBottomNavigationBar: _buildBottomBar(context),
      children: [
        const SpaceH60().sliverToBoxAdapter,
        Text("Company's Info:",style: context.titleLarge,).sliverToBoxAdapter,
        const SpaceH24().sliverToBoxAdapter,
        _buildCustomerInfoDisplay(context).sliverToBoxAdapter,
        const SpaceH60().sliverToBoxAdapter,
        InkWell(
          onTap: () async {
            await CustomLoading().showLoadingOverLay(
              asyncFunction: () => AuthManager.instance.logout(),
            );
          },
          child: Text("Sign in as:",style: context.titleLarge,textAlign: TextAlign.start,),
        ).sliverToBoxAdapter,
        const SpaceH24().sliverToBoxAdapter,
        Obx(
              () => Text(
            controller.user.value?.email ?? '',
            style: context.titleMedium.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
          ),
        ).sliverToBoxAdapter,
        const SpaceH60().sliverToBoxAdapter,
        Text("User Name:",style: context.titleLarge,).sliverToBoxAdapter,
        const SpaceH24().sliverToBoxAdapter,
        _buildUserDisplay(context).sliverToBoxAdapter,
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildUserDisplay(BuildContext context) {
    return Text(
      AuthManager.instance.user.value?.displayName ?? '',
      style: context.titleMedium.copyWith(fontSize: 18,),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCustomerInfoDisplay(BuildContext context) {
    TextStyle customStyle = context.titleMedium.copyWith(fontSize: 18);
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller.user.value?.company?.name ?? '',
              style: customStyle,
            ),
            Text(
              controller.user.value?.company?.address ?? '',
              style: customStyle,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              controller.user.value?.email ?? '',
              style: customStyle,
            ),
            Text(
              controller.user.value?.company?.phoneNo ?? '',
              style: customStyle,
            ),
          ],
        ));
  }

  Widget _buildBottomBar(BuildContext context) {
    return Row(
      children: [
        PermissionWrapper(
          permissionName: 'inventory',
          child: Expanded(
            flex: 1,
            child: CustomButton(
              buttonType: ButtonType.textWithImage,
              color: context.primaryColor,
              textColor: context.buttonTextColor,
              text: 'Products',
              image: Icon(
                Icons.shopping_cart,
                color: context.buttonTextColor,
                size: Sizes.ICON_SIZE_24,
              ),
              onPressed: homePageController.onPressProductButton,
              hasInfiniteWidth: false,
              verticalMargin: 0,
            ),
          ),
        ),
        const SpaceW4(),
        PermissionWrapper(
          permissionName: 'sales_customer',
          child: Expanded(
            flex: 1,
            child: CustomButton(
              buttonType: ButtonType.textWithImage,
              color: context.primaryColor,
              textColor: context.buttonTextColor,
              text: 'Customers',
              image: Icon(
                Icons.people,
                color: context.buttonTextColor,
                size: Sizes.ICON_SIZE_24,
              ),
              onPressed: homePageController.onPressCustomerButton,
              hasInfiniteWidth: false,
              verticalMargin: 0,
            ),
          ),
        ),
      ],
    );
  }
}
