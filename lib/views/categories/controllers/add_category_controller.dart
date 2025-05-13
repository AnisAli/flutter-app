import 'package:otrack/exports/index.dart';

class AddCategoryController extends GetxController {
  late final arguments = Get.arguments;
  late final GlobalKey<FormState> categoryFormKey;

  late TextEditingController categoryNameController;
  late RxBool isShowOnWeb;
  late String pageType;
  late ParentCategoryModel argCategory;
  late SubCategories argSubCategory;
  late String appBarTitle;
  late RxBool isLoading;

  @override
  void onInit() {
    super.onInit();
    categoryFormKey = GlobalKey<FormState>();
    isLoading = false.obs;
    isShowOnWeb = false.obs;
    categoryNameController = TextEditingController();
    appBarTitle = 'Add Category';
    pageType = arguments['pageType'];
    if (pageType == 'editCategory') {
      argCategory = arguments['category'];
      editInitialization();
      appBarTitle = 'Edit Category';
    } else if (pageType == 'newSubCategory') {
      argCategory = arguments['category'];
      appBarTitle = 'Add Sub-Category';
    } else if (pageType == 'editSubCategory') {
      argSubCategory = arguments['subCategory'];
      editSubInitialization();
      appBarTitle = 'Edit Sub-Category';
    }
  }

  void editSubInitialization() {
    categoryNameController.text = argSubCategory.name ?? '';
    isShowOnWeb.value = argSubCategory.showOnWeb ?? false;
  }

  void editInitialization() {
    categoryNameController.text = argCategory.name ?? '';
    isShowOnWeb.value = argCategory.showOnWeb ?? false;
  }

  Future<void> onSaveCategoryForm() async {
    if (categoryFormKey.currentState!.validate()) {
      isLoading(true);
      if (arguments['pageType'] == 'newCategory') {
        await saveCategory();
      } else if (arguments['pageType'] == 'editCategory') {
        await editCategory();
      } else if (arguments['pageType'] == 'newSubCategory') {
        await saveSubCategory();
      } else if (arguments['pageType'] == 'editSubCategory') {
        await editSubCategory();
      }
      isLoading(false);
    }
  }

  Future<void> saveSubCategory() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
      "name": "${categoryNameController.text}",     
      "description": "${categoryNameController.text}",     
      "parentCategoryId": ${argCategory.rootCategoryId},
      "showOnWeb":"${isShowOnWeb.value}",     
   }''';

    return await BaseClient.safeApiCall(
      ApiConstants.POST_ADD_CATEGORIES,
      RequestType.post,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        Get.snackbar(
          'Success',
          'Sub-Category added successfully!',
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
          e.response?.data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> editSubCategory() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
      "name": "${categoryNameController.text}",     
      "description": "${categoryNameController.text}",     
      "parentCategoryId": ${argSubCategory.parentCategoryId},
      "categoryId" : ${argSubCategory.categoryId},
      "showOnWeb": ${isShowOnWeb.value},     
   }''';

    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_ADD_CATEGORIES}/${argSubCategory.categoryId}',
      RequestType.put,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        Get.snackbar(
          'Success',
          'Sub-Category edited successfully!',
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
          e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> saveCategory() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
      "name": "${categoryNameController.text}",     
      "description": "${categoryNameController.text}",     
      "parentCategoryId": -1,
      "showOnWeb":"${isShowOnWeb.value}",     
   }''';

    return await BaseClient.safeApiCall(
      ApiConstants.POST_ADD_CATEGORIES,
      RequestType.post,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        if (Get.arguments["fromProductPage"]) {
          Get.back(result: response.data);
        } else {
          Get.offAllNamed(AppRoutes.CATEGORIES);
        }
        Get.snackbar(
          'Success',
          'Category added successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> editCategory() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
      "name": "${categoryNameController.text}",     
      "description": "${categoryNameController.text}",     
      "parentCategoryId": -1,
      "categoryId" : ${argCategory.categoryId},
      "showOnWeb": ${isShowOnWeb.value},     
   }''';

    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_ADD_CATEGORIES}/${argCategory.categoryId}',
      RequestType.put,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        Get.snackbar(
          'Success',
          'Category edited successfully!',
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
          e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    categoryNameController.dispose();
  }
}
