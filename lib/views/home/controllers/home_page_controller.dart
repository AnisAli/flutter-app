import '../../../exports/index.dart';

class HomePageController extends GetxController {
  void onPressCustomerButton() => Get.offAllNamed(AppRoutes.CUSTOMERS);
  void onPressProductButton() => Get.offAllNamed(AppRoutes.PRODUCTS);
}
