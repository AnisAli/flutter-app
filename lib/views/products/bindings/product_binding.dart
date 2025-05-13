import '../../../exports/index.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductController());
  }
}
