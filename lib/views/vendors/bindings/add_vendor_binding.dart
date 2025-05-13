import '../../../exports/index.dart';

class AddVendorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddVendorController());
  }
}
