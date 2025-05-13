import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../exports/index.dart';

class AddProductController extends GetxController {
  bool? productAddCheck = false;
  //Passed Argument from product screen//
  late final ProductModel? argsProduct;
  bool? isClone;
  late final arguments = Get.arguments;
  String? tempImageUrl;
  late bool isDescriptionFilled;

  late ProductController productController;

  // Product Details Controllers
  late final GlobalKey<FormState> productFormKey;
  late TextEditingController barcodeController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController parentCategoryController;
  List<CategoryModel>? parentCategories;
  CategoryModel? selectedParentCategory;
  File? productImage;

  // Price Details Controllers
  late TextEditingController purchaseCostController;
  late TextEditingController unitPerCaseController;
  late TextEditingController salesPriceController;
  late TextEditingController marginController;
  late TextEditingController srpController;
  late TextEditingController srpPercentageController;

  // Toggles
  late RxBool isActive = true.obs,
      isTaxable = false.obs,
      isNewProduct = false.obs;

  RxBool isLoading = false.obs;
  RxBool isParentCategoriesLoading = false.obs;
  bool isAddAndClone = false;
  bool isAddAndNew = false;

  @override
  void onInit() async {
    productController = Get.put(ProductController());
    // Product Info Form
    productFormKey = GlobalKey<FormState>();
    barcodeController = TextEditingController();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    parentCategoryController = TextEditingController();
    isDescriptionFilled = false;
    // Price Form
    purchaseCostController = TextEditingController();
    unitPerCaseController = TextEditingController(text: '1');
    salesPriceController = TextEditingController();
    marginController = TextEditingController();
    srpController = TextEditingController();
    srpPercentageController = TextEditingController();

    //getting arguments//
    isClone = false;
    if (!arguments["backRoute"]) {
      isClone = arguments['isCloned'] as bool?;
      argsProduct = arguments['product'] as ProductModel?;

      isActive(argsProduct?.isActive);
      isTaxable(argsProduct?.isTaxable);
      tempImageUrl = argsProduct?.imageUrl;
      barcodeController = TextEditingController(text: argsProduct?.barcode);
      if (!isClone!) {
        nameController = TextEditingController(text: argsProduct?.productName);
      } else {
        nameController =
            TextEditingController(text: '${argsProduct?.productName} (1)');
      }
      descriptionController =
          TextEditingController(text: argsProduct?.description);
      parentCategoryController =
          TextEditingController(text: argsProduct?.rootCategoryName);

      if (descriptionController.text.isEmpty) {
        isDescriptionFilled = false;
      } else {
        isDescriptionFilled = true;
      }
      //pricinng //
      purchaseCostController =
          TextEditingController(text: argsProduct?.purchaseCost.toString());
      unitPerCaseController =
          TextEditingController(text: argsProduct?.unitPerCase.toString());
      salesPriceController =
          TextEditingController(text: argsProduct?.price.toString());
      srpController = TextEditingController(
          text: argsProduct?.suggestedRetailPrice.toString());
      calculateMarginFromSalesPrice(argsProduct?.price.toString() ?? '0.00');
      calculateSrpPercentage(
          argsProduct?.suggestedRetailPrice.toString() ?? '0.00');
    }
    await getParentCategories();
    super.onInit();
  }

  void onPressAddCategoryButton() async {
    var result = await Get.toNamed(AppRoutes.ADD_CATEGORY, arguments: {
      "pageType": 'newCategory',
      "category": null,
      "fromProductPage": true
    });
    if (result != null) {
      isParentCategoriesLoading(true);
      CategoryModel category = CategoryModel.fromJson(result);
      parentCategories?.add(category);
      selectedParentCategory = category;
      parentCategoryController.text = category.categoryId.toString() ?? '';
      isParentCategoriesLoading(false);
      update();
    }
  }

  void copyProductToForm(ProductModel? productModel) {
    isActive(productModel?.isActive);
    isTaxable(productModel?.isTaxable);
    nameController.text = '${productModel?.productName ?? ''} (1)';
    descriptionController.text = productModel?.description ?? '';
    purchaseCostController.text = productModel?.purchaseCost.toString() ?? '';
    salesPriceController.text = productModel?.price.toString() ?? "0.0";
    unitPerCaseController.text = productModel?.unitPerCase.toString() ?? '1';
    srpController.text = productModel?.suggestedRetailPrice.toString() ?? '0.0';
    calculateMarginFromSalesPrice(productModel?.price.toString() ?? '0.00');
    calculateSrpPercentage(
        productModel?.suggestedRetailPrice.toString() ?? '0.00');
    toggleTaxable(isActive.value);

    selectedParentCategory = parentCategories!.firstWhere((parentCategory) =>
        parentCategory.rootCategoryId == productModel?.rootCategoryId);
    parentCategoryController.text =
        productModel?.rootCategoryId.toString() ?? '';

    Get.back();
  }

  void toggleActive(bool value) => isActive.value = value;

  void toggleTaxable(bool value) => isTaxable.value = value;

  Future pickImage({ImageSource imageSource = ImageSource.gallery}) async {
    Get.back();
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: imageSource,
      );
      if (image == null) return;

      final imageTemp = File(image.path);
      productImage = imageTemp;
      update();
    } on PlatformException catch (e) {
      log.e("Failed to pick Image: $e");
    }
  }

  void removeProductImage() {
    productImage = null;
    tempImageUrl = null;
    update();
  }

  Future<void> saveProductForm() async {
    if (productFormKey.currentState!.validate()) {
      isLoading(true);
      if (arguments["backRoute"] || isClone == true) {
        await checkProductExistsAndSave();
      } else {
        await editProduct(argsProduct?.productId.toString() ?? '');
      }
      isLoading(false);
    }
  }

  Future<void> saveAndNewProductForm() async {
    Get.back();
    isAddAndNew = true;
    productAddCheck = true;
    await saveProductForm();
    isAddAndNew = false;
  }

  Future<void> saveAndCloneProductForm() async {
    Get.back();
    isAddAndClone = true;
    productAddCheck = true;
    await saveProductForm();
    isAddAndClone = false;
  }

  void resetForm() {
    isDescriptionFilled = false;
    productImage = null;
    tempImageUrl = null;
    isActive.value = true;
    isTaxable.value = false;
    isNewProduct.value = false;
    isAddAndNew = false;
    isAddAndClone = false;
    nameController.clear();
    descriptionController.clear();
    barcodeController.clear();
    parentCategoryController.clear();
    purchaseCostController.clear();
    salesPriceController.clear();
    unitPerCaseController.text = '1';
    srpPercentageController.clear();
    marginController.clear();
    srpController.clear();
    selectedParentCategory = null;
    update();
  }

  void searchByBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        log.i('Barcode : ${barcode.rawValue}');
        barcodeController.text = barcode.rawValue!;
        Get.back();
      }
      break;
    }
  }

  void addBarCodeWithName(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        log.i('Barcode : ${barcode.rawValue}');
        nameController.text += barcode.rawValue!;
        Get.back();
      }
      break;
    }
  }

  Future<bool> isProductWithBarcodeExists(String barCode) async {
    if (barCode.isNotEmpty) {
      return await BaseClient.safeApiCall(
        ApiConstants.GET_SUGGESTED_PRODUCT_LIST,
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        queryParameters: {
          '\$filter': "contains(tolower(barcode),'$barCode')",
        },
        onSuccess: (response) {
          return response.data['value'].isNotEmpty;
        },
        onError: (e) {
          Get.defaultDialog(
              title: 'Something went wrong',
              middleText: e.message,
              middleTextStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w700));
          return false;
        },
      );
    } else {
      return false;
    }
  }

  @override
  void onReady() async {
    super.onReady();
    if (!arguments["backRoute"]) {
      selectedParentCategory = parentCategories!.firstWhere((parentCategory) =>
          parentCategory.rootCategoryId == argsProduct?.rootCategoryId);

      parentCategoryController.text =
          argsProduct?.rootCategoryId.toString() ?? '';
    }
    update();
  }

  @override
  void dispose() {
    productController.dispose();
    // Product Info Form
    barcodeController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    parentCategoryController.dispose();

    // Price Form
    purchaseCostController.dispose();
    unitPerCaseController.dispose();
    salesPriceController.dispose();
    marginController.dispose();
    srpController.dispose();
    srpPercentageController.dispose();

    super.dispose();
  }

  void onProductNameChange(String value) {
    try {
      if (!isDescriptionFilled) {
        descriptionController.text = value;
      }
    } catch (e) {
      log.e(e);
    }
  }

  void onDescriptionChange(String value) {
    if (value.isEmpty) {
      isDescriptionFilled = false;
    } else {
      isDescriptionFilled = true;
    }
  }

  void onUnitPerCaseFocusLost(val) {
    if (!val) {
      if (unitPerCaseController.text.isEmpty) {
        unitPerCaseController.text = '1';
      }
    }
  }

  void onMarginPercentageFocusLost(val) {
    if (!val) {
      if (purchaseCostController.text.isNotEmpty) {
        calculateMarginFromPurchaseCost(purchaseCostController.text);
      } else if (salesPriceController.text.isNotEmpty) {
        calculateMarginFromSalesPrice(salesPriceController.text);
      }
    }
  }

  void onSrpPercentageFocusLost(val) {
    if (!val) {
      if (srpController.text.isNotEmpty) {
        calculateSrpPercentage(srpController.text);
      }
    }
  }

  void calculateMarginFromSalesPrice(String number) {
    try {
      double salesPrice = double.parse(number),
          purchaseCost = double.parse(purchaseCostController.text);
      double diff = (salesPrice - purchaseCost) / salesPrice;
      if (diff.isFinite) {
        marginController.text = (diff * 100).toPrice();
      } else {
        marginController.text = '0.00';
      }
    } catch (e) {
      log.e(e);
    }
  }

  void calculateMarginFromPurchaseCost(String number) {
    try {
      double salesPrice = double.parse(salesPriceController.text),
          purchaseCost = double.parse(number);
      double diff = (salesPrice - purchaseCost) / salesPrice;
      if (diff.isFinite) {
        marginController.text = (diff * 100).toPrice();
      } else {
        marginController.text = '0.00';
      }
    } catch (e) {
      log.e(e);
    }
  }

  void calculateSalesPrice(String number) {
    try {
      double margin = double.parse(number) / 100,
          purchaseCost = double.parse(purchaseCostController.text);

      salesPriceController.text =
          ((purchaseCost / (margin - 1)).abs()).toPrice();
    } catch (e) {
      log.e(e);
    }
  }

  void calculateSrpPercentage(String number) {
    try {
      double srp = double.parse(number);
      int unitPerCase = unitPerCaseController.text.isNotEmpty
          ? int.parse(unitPerCaseController.text)
          : 1;
      double salesPrice = double.parse(salesPriceController.text);
      double diff = (srp - (salesPrice / unitPerCase)) / srp;
      if (diff.isFinite) {
        srpPercentageController.text = (diff * 100).toPrice();
      } else {
        srpPercentageController.text = '0.00';
      }
    } catch (e) {
      log.e(e);
    }
  }

  void calculateSrp(String number) {
    try {
      double srpPercentage = double.parse(number) / 100,
          salesPrice = double.parse(salesPriceController.text);

      srpController.text = ((salesPrice / (srpPercentage - 1)).abs()).toPrice();
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> getParentCategories() async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_PRODUCT_CATEGORIES}-1',
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        List<CategoryModel> categoryList =
            CategoryModel.listFromJson(response.data);
        categoryList.sort((a, b) => a.name!.compareTo(b.name!));
        parentCategories = categoryList;
        update();
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  Future<void> editProduct(String productId) async {
    fixAllControllersIfStartEndWithDost();
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "productId": $productId,
    "name": "${nameController.text}",
    "description": "${descriptionController.text}",
    "parentCategoryId": "${selectedParentCategory?.rootCategoryId}",
    "categoryId": ${argsProduct?.categoryId},
    "isTaxable": ${isTaxable.value},
    "isActive": ${isActive.value},
    "basePrice": ${salesPriceController.text == '' ? '0.00' : salesPriceController.text},
    "purchaseCost": ${purchaseCostController.text == '' ? '0.00' : purchaseCostController.text},
    "suggestedRetailPrice": ${srpController.text == '' ? '0.00' : srpController.text},
    "margin": ${marginController.text == '' ? '0.00' : marginController.text},
    "unitPerCase": ${unitPerCaseController.text},
    "quantityInHand": ${argsProduct?.quantityInHand},
    "barcode": "${barcodeController.text}",
    "notes": "${argsProduct?.notes}",
  }''';

    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_ADD_PRODUCT}/$productId',
      RequestType.put,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        if (productImage != null) {
          await uploadImage(response.data["productId"].toString());
        }
        if (arguments['backRoutePath'] != null) {
          if (arguments['backRoutePath'] == 'onlyBack') {
            Get.back(result: response.data);
          }
        } else {
          Get.offAllNamed(AppRoutes.PRODUCTS);
        }
        Get.snackbar(
          'Success',
          'Product Edited successfully!',
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
          e.response?.data ?? e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void fixInputControllerIfStartsWithDot(TextEditingController controller) {
    String text = controller.text;
    if (text.startsWith('.')) {
      controller.text = '0$text';
    }
    if (text.endsWith('.')) {
      controller.text = '${text}0';
    }
  }

  void fixAllControllersIfStartEndWithDost() {
    fixInputControllerIfStartsWithDot(purchaseCostController);
    fixInputControllerIfStartsWithDot(salesPriceController);
    fixInputControllerIfStartsWithDot(srpController);
    fixInputControllerIfStartsWithDot(srpPercentageController);
    fixInputControllerIfStartsWithDot(marginController);
  }

  Future checkProductExistsAndSave() async {
    //checking for already exist product with given barcode
    bool isProductExists =
        await isProductWithBarcodeExists(barcodeController.text);
    if (isProductExists) {
      // _showAlertDialog(context, () async => await saveProduct());
      Get.defaultDialog(
        title: 'Barcode already exists!',
        titlePadding: const EdgeInsets.all(10),
        titleStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        backgroundColor: Colors.white,
        middleText: 'Do you want to continue?',
        middleTextStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        textConfirm: 'Yes',
        textCancel: 'No',
        contentPadding: const EdgeInsets.all(20),
        radius: 12,
        onConfirm: () async => await saveProduct(),
      );
    } else {
      await saveProduct();
    }
  }

  Future<void> saveProduct() async {
    fixAllControllersIfStartEndWithDost();
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "name": "${nameController.text}",
    "description": "${descriptionController.text}",
    "parentCategoryId": "${parentCategoryController.text}",
    "categoryId": null,
    "isTaxable": ${isTaxable.value},
    "isActive": ${isActive.value},
    "basePrice": ${salesPriceController.text == '' ? '0.00' : salesPriceController.text},
    "purchaseCost": ${purchaseCostController.text == '' ? '0.00' : purchaseCostController.text},
    "suggestedRetailPrice": ${srpController.text == '' ? '0.00' : srpController.text},
    "margin": ${marginController.text == '' ? '0.00' : marginController.text},
    "unitPerCase": ${unitPerCaseController.text},
    "quantityInHand": 0,
    "barcode": "${barcodeController.text}",
    "notes": null,
    "productUnit": null,
    "initialStockQty": 0,
    "initialStockCost": 0,
    "imageUrl": null,
    "initialStock": 0,
    "initialCost": 0
  }''';

    return await BaseClient.safeApiCall(
      ApiConstants.POST_ADD_PRODUCT,
      RequestType.post,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        if (isAddAndNew) {
          resetForm();
        } else if (isAddAndClone) {
          nameController.text = '${nameController.text} (1)';
          update();
        } else if (arguments["fromQuickInvoice"] != null) {
          Get.back(result: response.data);
        } else {
          Get.offAllNamed(AppRoutes.PRODUCTS);
        }

        if (productImage != null ||
            (tempImageUrl != null && isClone! == true)) {
          await uploadImage(response.data["productId"].toString());
        } else {
          Get.snackbar(
            'Success',
            'Product added successfully!',
            margin: const EdgeInsets.only(bottom: 25),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
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

  String generateUniqueFilename() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    final timestamp = formatter.format(now);
    final random = Random().nextInt(10000);
    return '$timestamp-$random.jpg'; // or any other extension you want to use
  }

  Future<void> uploadImage(String productId) async {
    final headers =
        await BaseClient.generateHeaders(contentType: 'multipart/form-data');
    String query = '/$productId/image';

    if (isClone! == true && productImage == null) {
      String fileName = generateUniqueFilename();
      final bytes = await downloadImage(tempImageUrl ?? '');
      FormData formData = FormData.fromMap(
          {"document": MultipartFile.fromBytes(bytes, filename: fileName)});
      return await BaseClient.safeApiCall(
        ApiConstants.POST_ADD_PRODUCT + query,
        RequestType.put,
        headers: headers,
        data: formData,
        onLoading: () {},
        onSuccess: (response) {
          // Handle success response
          Get.snackbar(
            'Success',
            'Product added successfully!',
            margin: const EdgeInsets.only(bottom: 25),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        },
        onError: (e) {
          Get.snackbar(
            'Image not uploaded!',
            e.message,
            margin: const EdgeInsets.only(bottom: 25),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          // Get.offAllNamed(AppRoutes.PRODUCTS);
          return true;
        },
      );
    } else {
      String fileName = productImage!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "document": await MultipartFile.fromFile(productImage!.path,
            filename: fileName),
      });
      return await BaseClient.safeApiCall(
        ApiConstants.POST_ADD_PRODUCT + query,
        RequestType.put,
        headers: headers,
        data: formData,
        onLoading: () {},
        onSuccess: (response) {
          // Handle success response
          Get.snackbar(
            'Success',
            'Product added successfully!',
            margin: const EdgeInsets.only(bottom: 25),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        },
        onError: (e) {
          Get.snackbar(
            'Image not uploaded!',
            e.message,
            margin: const EdgeInsets.only(bottom: 25),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return true;
        },
      );
    }
  }

  Future downloadImage(String url) async {
    try {
      final int dotIndex = url.lastIndexOf('.');
      final int sIndex = url.lastIndexOf('_s', dotIndex);
      if (sIndex != -1) {
        final String largeUrl = url.replaceRange(sIndex, sIndex + 2, '_l');
        log.i(largeUrl);
        final response = await http.get(Uri.parse(largeUrl));
        final bytes = response.bodyBytes;
        return bytes;
      } else {
        throw Exception('No _s found in URL');
      }
    } on Exception catch (e) {
      Get.snackbar(
        'Image Downloading failed!',
        margin: const EdgeInsets.only(bottom: 25),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  void onParentCategoryChange(CategoryModel? selected) {
    selectedParentCategory = selected;
    parentCategoryController.text = selected!.rootCategoryId.toString();
    update();
  }

  List<TextInputFormatter>? buildTextInputFormatters() {
    return [
      FilteringTextInputFormatter.allow(
        RegExp(r'^\d{0,10}(\.\d{0,4})?'),
      ),
    ];
  }
}
