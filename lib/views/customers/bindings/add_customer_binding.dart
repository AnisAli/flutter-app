import '../../../exports/index.dart';

class AddCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddCustomerController());
  }
}
