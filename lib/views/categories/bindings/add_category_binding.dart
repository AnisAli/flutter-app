
import 'package:get/get.dart';
import 'package:otrack/views/categories/controllers/add_category_controller.dart';


class AddCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddCategoryController());
  }
}
