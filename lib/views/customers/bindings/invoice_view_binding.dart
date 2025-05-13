import '../../../exports/index.dart';

class InvoiceViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InvoiceViewController());
  }
}
