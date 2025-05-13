
import '../../../exports/index.dart';

class SalesByItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesByItemController());
  }
}
