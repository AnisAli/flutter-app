import '../../../exports/index.dart';

class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddProductController());
  }
}
