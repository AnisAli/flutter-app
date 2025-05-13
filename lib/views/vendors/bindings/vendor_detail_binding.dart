import '../../../exports/index.dart';

class VendorDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorDetailController());
  }
}
