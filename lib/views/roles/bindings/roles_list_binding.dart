import '../../../exports/index.dart';

class RolesListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RolesListController());
  }
}
