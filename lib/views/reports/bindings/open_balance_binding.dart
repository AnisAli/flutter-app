import '../../../exports/index.dart';

class OpenBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OpenBalanceController());
  }
}
