import '../../../exports/index.dart';

class UsersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersListController());
  }
}
