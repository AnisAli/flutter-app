import 'package:otrack/exports/index.dart';

class CategoryDetailController extends GetxController {
  late final arguments = Get.arguments;
  late final GlobalKey<ScaffoldState> scaffoldKey;
  late ParentCategoryModel category;

  @override
  void onInit() {
    super.onInit();
    scaffoldKey = GlobalKey<ScaffoldState>();
    category = arguments['category'];
  }

  Future<void> deleteSubCategory(String subId) async {
    return await BaseClient.safeApiCall(
      "${ApiConstants.DELETE_ROOT_SUB_CATEGORIES}$subId",
      RequestType.delete,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        Get.snackbar(
          'Success',
          'Sub Category deleted successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.CATEGORIES);
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data ?? e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

}