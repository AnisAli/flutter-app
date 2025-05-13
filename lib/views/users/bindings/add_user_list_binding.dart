import '../../../exports/index.dart';

class AddUserListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddUserListController());
  }
}
