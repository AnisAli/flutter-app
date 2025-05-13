import '../../../exports/index.dart';

class PaymentReceivedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentReceivedController());
  }
}
