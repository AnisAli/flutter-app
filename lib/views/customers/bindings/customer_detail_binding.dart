import '../../../exports/index.dart';

class CustomerDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerDetailController());
  }
}
