import '../../../exports/index.dart';

class ProfitLossOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfitLossOverviewController());
  }
}
