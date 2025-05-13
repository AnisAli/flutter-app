
import '../../../exports/index.dart';

class CustomerOpenBalanceReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerOpenBalanceReportController());
  }
}
