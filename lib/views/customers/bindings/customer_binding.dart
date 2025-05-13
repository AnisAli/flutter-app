import '../../../exports/index.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerController());
  }
}
