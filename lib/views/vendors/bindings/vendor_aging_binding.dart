import '../../../exports/index.dart';

class VendorAgingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorAgingController());
  }
}
