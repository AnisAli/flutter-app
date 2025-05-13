import '../../../exports/index.dart';

class QuickInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuickInvoiceController());
  }
}
