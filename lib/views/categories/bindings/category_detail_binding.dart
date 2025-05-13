
import 'package:get/get.dart';
import 'package:otrack/views/categories/controllers/category_detail_controller.dart';


class CategoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryDetailController());
  }
}
