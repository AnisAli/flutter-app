import '../../../exports/index.dart';

class SalesByIndividualItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesByIndividualItemController());
  }
}
