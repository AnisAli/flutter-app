
import '../../../exports/index.dart';

class SalesByCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesByCustomerController());
  }
}
