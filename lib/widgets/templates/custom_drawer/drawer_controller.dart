import '../../../exports/index.dart';
import 'drawer_model.dart';

class MyDrawerController extends GetxController {
  RxInt selectedIndex = (-1).obs; // don't set it to 0
  RxInt subMenuSelectedIndex = (-1).obs; // don't set it to 0

  late GlobalKey<ScaffoldState> _scaffoldKey;

  set setKey(GlobalKey<ScaffoldState> key) => _scaffoldKey = key;

  ScaffoldState get scaffoldKey => _scaffoldKey.currentState!;

  RxBool isExpanded = true.obs;

  void onPressAppName() {
    Get.offNamed(AppRoutes.HOME);
    selectedIndex.value = -1;
    subMenuSelectedIndex.value = -1;
  }

  void openDrawer() {
    if (!scaffoldKey.isDrawerOpen) {
      isExpanded.value = true;
      scaffoldKey.openDrawer();
    }
  }

  void closeDrawer() {
    if (scaffoldKey.isDrawerOpen) {
      scaffoldKey.closeDrawer();
    }
  }

  void expandOrShrinkDrawer() {
    // isExpanded.value = !isExpanded.value;
  }

  void onExpansionCallback(int index, bool isExpanded) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
      subMenuSelectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
      subMenuSelectedIndex.value = -1;
    }
    // onTap: drawerItem.submenus.isEmpty ? drawerItem.onPressed : null,
  }

  void onSelectionChange(int index, DrawerModel item) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
      subMenuSelectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
      subMenuSelectedIndex.value = -1;
      if (item.onPressed != null) {
        item.onPressed!();
      }
    }
  }

  void onSubMenuSelectionChange(int index, DrawerModel item) {
    if (subMenuSelectedIndex.value == index) {
      subMenuSelectedIndex.value = -1;
    } else {
      if (item.onPressed != null) {
        item.onPressed!();
      }
      subMenuSelectedIndex.value = index;
    }
  }

  // TODO : Indexing for Access Permissions
  // int getTileIndex(String screenName) {
  //   switch(screenName){
  //     case ""
  //   }
  //   return 0;
  // }

  List<DrawerModel> get drawerItemsList => _drawerItemsList;

  late final List<DrawerModel> _drawerItemsList = [
    DrawerModel(
      icon: Icons.home_filled,
      title: "Dashboard",
      onPressed: () => Get.offNamed(AppRoutes.HOME),
    ),
    DrawerModel(
      icon: Iconsax.shopping_cart,
      title: "Sales",
      submenus: [
        DrawerModel(
          title: 'Sale Order',
          onPressed: () =>
              Get.offAllNamed(AppRoutes.CUSTOMER_DETAIL, arguments: {
            'viaCustomers': false,
            'orderType': 4,
          }),
        ),
        DrawerModel(
          title: 'Invoice',
          onPressed: () =>
              Get.offAllNamed(AppRoutes.CUSTOMER_DETAIL, arguments: {
            'viaCustomers': false,
            'orderType': 1,
          }),
        ),
        DrawerModel(
          title: 'Credit Memo',
          onPressed: () =>
              Get.offAllNamed(AppRoutes.CUSTOMER_DETAIL, arguments: {
            'viaCustomers': false,
            'orderType': 2,
          }),
        ),
        // DrawerModel(
        //   title: 'Payment Received',
        //   onPressed: () =>Get.offAllNamed(AppRoutes.PAYMENT_RECEIVED),
        // ),
      ],
      // onPressed: () => Get.offNamed(Routes.tradingBot),
    ),
    if (Get.find<AuthManager>().hasAccessTo('sales_customer'))
      DrawerModel(icon: Iconsax.people, title: "Customers", submenus: [
        DrawerModel(
          title: 'Customer List',
          onPressed: () => Get.offAllNamed(AppRoutes.CUSTOMERS),
        ),
      ]),
    if (Get.find<AuthManager>().hasAccessTo('inventory'))
      DrawerModel(
        icon: Iconsax.dcube,
        // iconColor: Colors.black.withOpacity(0.6),
        title: "Inventory",
        submenus: [
          DrawerModel(
            title: 'Products',
            onPressed: () => Get.offAllNamed(AppRoutes.PRODUCTS),
          ),
          DrawerModel(
            title: 'Categories',
            onPressed: () => Get.offAllNamed(AppRoutes.CATEGORIES),
          ),
        ],
        // onPressed: () => Get.offNamed(Routes.news),
      ),
    if (Get.find<AuthManager>().hasAccessTo('purchases_vendor'))
      DrawerModel(icon: Icons.people_outline, title: "Vendors", submenus: [
        DrawerModel(
          title: 'Vendor List',
          onPressed: () => Get.offAllNamed(AppRoutes.VENDORS),
        ),
      ]),
    if (Get.find<AuthManager>().hasAccessTo('reports'))
      DrawerModel(icon: Icons.query_stats, title: "Reports", submenus: [
        DrawerModel(
          title: 'Profit & Loss Overview',
          onPressed: () => Get.offAllNamed(AppRoutes.PROFIT_LOSS_OVERVIEW),
        ),
        DrawerModel(
          title: 'Open Balance',
          onPressed: () => Get.offAllNamed(AppRoutes.OPEN_BALANCE),
        ),
        DrawerModel(
          title: 'Sales By Item',
          onPressed: () => Get.offAllNamed(AppRoutes.SALES_BY_ITEM),
        ),
        DrawerModel(
          title: 'Sales By Customer',
          onPressed: () => Get.offAllNamed(AppRoutes.SALES_BY_CUSTOMER),
        ),
        DrawerModel(
          title: 'Sale By Individual Item',
          onPressed: () => Get.offAllNamed(AppRoutes.SALES_BY_INDIVIDUAL_ITEM),
        ),
      ]),
    DrawerModel(
      icon: Iconsax.setting,
      title: "Settings",
      submenus: [
        DrawerModel(title: AppStrings.DARK_MODE),
        if (Get.find<AuthManager>().hasAccessTo('user_management')) ...[
          DrawerModel(
              title: 'Users',
              onPressed: () => Get.offAllNamed(AppRoutes.USERS_LIST)),
          DrawerModel(
              title: AppStrings.ROLES,
              onPressed: () => Get.offAllNamed(AppRoutes.ROLES_LIST)),
        ],
        DrawerModel(
            title: 'Company Setting',
            onPressed: () => Get.offAllNamed(AppRoutes.COMPANY_PROFILE)),
      ],
    ),
    DrawerModel(
      icon: Iconsax.logout_1,
      title: "Logout",
      onPressed: () => showAlertDialog(Get.context!),
    ),
  ];

  static void showAlertDialog(BuildContext context) {
    // Icon(Icons.logout_rounded, color: context.iconColor1, size: 20),
    PanaraConfirmDialog.show(
      context,
      title: "Logout Confirmation",
      message: "Are you sure you to want to Logout ?",
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      color: context.primaryColor,
      onTapCancel: Get.back,
      onTapConfirm: () async {
        await CustomLoading().showLoadingOverLay(
          asyncFunction: () => AuthManager.instance.logout(),
        );
      },
      panaraDialogType: PanaraDialogType.custom,
    );
  }

  void resetIndex() {
    selectedIndex.value = 0;
    subMenuSelectedIndex.value = -1;
  }
}
