import '../../../exports/index.dart';

class ItemReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemReportController());
  }
}
