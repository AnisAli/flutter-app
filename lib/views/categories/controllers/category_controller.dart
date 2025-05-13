import 'package:otrack/exports/index.dart';

class CategoryController extends GetxController {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  late RxBool isShimmerEffectLoading = true.obs;

  List<ParentCategoryModel> rootCategories = [];

  @override
  void onInit() async {
    super.onInit();
    scaffoldKey = GlobalKey<ScaffoldState>();
    await getRootCategories();
  }

  List<ParentCategoryModel> parseCategoriesList(dynamic json) {
    List<ParentCategoryModel> categoriesList = [];

    if (json != null && json is List) {
      categoriesList = json.map<ParentCategoryModel>((categoryJson) {
        return ParentCategoryModel.fromJson(categoryJson);
      }).toList();
    }

    return categoriesList;
  }

  Future getRootCategories() async {
    final headers = await BaseClient.generateHeaders();
    return await BaseClient.safeApiCall(
      ApiConstants.GET_ROOT_CATEGORIES,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        rootCategories = parseCategoriesList(response.data);
        isShimmerEffectLoading(false);
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

  //same call for category and subcategory
  Future<void> deleteCategory(String catId) async {
    return await BaseClient.safeApiCall(
      "${ApiConstants.DELETE_ROOT_SUB_CATEGORIES}$catId",
      RequestType.delete,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        Get.snackbar(
          'Success',
          'Category deleted successfully!',
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
