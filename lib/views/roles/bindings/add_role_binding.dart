import '../../../exports/index.dart';

class AddRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddRoleController());
  }
}
