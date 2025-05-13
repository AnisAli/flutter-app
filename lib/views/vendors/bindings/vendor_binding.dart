import '../../../exports/index.dart';

class VendorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorController());
  }
}
