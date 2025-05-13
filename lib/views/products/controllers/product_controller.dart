import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../exports/index.dart';
import '../components/text_file_viewier.dart';

class ProductController extends GetxController {
  // to debounce search effect //
  final _deBouncer = Debouncer(milliseconds: 400);

  //get storage (shared preferences)
  final productContainer = GetStorage(AppStrings.PRODUCT_CONTAINER);

  //Setting Sheet bools //

  RxBool isShowName = true.obs;
  RxBool isShowDescription = true.obs;
  RxBool isShowActive = true.obs;
  RxBool isShowParentCategory = true.obs;
  RxBool isShowIndicators = true.obs;
  RxBool isShowSalePrice = true.obs;
  RxBool isShowImage = false.obs;
  RxBool isLoading = false.obs;

  // Temporary Display Settings //
  late RxBool isShowActiveTemp = true.obs;
  late RxBool isShowParentCategoryTemp = true.obs;
  late RxBool isShowIndicatorsTemp = true.obs;
  late RxBool isShowSalePriceTemp = true.obs;
  late RxBool isShowImageTemp = false.obs;

  //------------------//

  // Sort Sheet //

  RxBool isSortName = true.obs;
  RxBool isSortDescription = false.obs;
  RxBool isSortParentCategory = false.obs;
  RxBool isSortPrice = false.obs;
  RxBool isSortActive = false.obs;
  RxBool isSortInStock = false.obs;
  RxBool isSortTaxable = false.obs;
  RxBool isSortAscending = true.obs;

  //------------------//

  late String searchQuery;
  late String searchBarQuery;
  late String newFilterQuery;
  late String sortQuery;
  late final GlobalKey<ScaffoldState> scaffoldKey;
  late TextEditingController searchTextController;
  late final PagingController<int, ProductModel> productsPaginationKey;

  // Filter Sheet //

  late TextEditingController parentFilterCategoryController;
  late TextEditingController taxFilterController;
  late TextEditingController activeFilterController;
  late TextEditingController stockFilterController;
  late TextEditingController combinedPdiDatePickerController;

  late RxString fromPdiDateText = ''.obs;
  // DateFormat('yyyy-MM-dd')
  //     .format(DateTime.now().subtract(const Duration(days: 365)));

  List<CategoryModel>? parentCategories;
  List<CategoryModel>? selectedParentCategories;

  List<String> activeFilters = ['All', 'Active', 'Inactive'];
  String? activeFilter;

  List<String> taxTypeFilters = ['All', 'Taxable', 'Non-Taxable'];
  String? taxFilter;

  List<String> stockFilters = ['All', 'In Stock', 'Out of Stock'];
  String? stockFilter;

  // Extract Combined PDI Download File //

  Future downloadCombinedPdiFile() async {
    final headers = await BaseClient.generateHeaders();
    Dio dioWithHeaders = Dio(BaseOptions(
        receiveTimeout: 999999, sendTimeout: 999999, headers: headers));
    String apiString = ApiConstants.COMBINED_PDI_DOWNLOAD +
        combinedPdiDatePickerController.text;

    var dir = await getApplicationDocumentsDirectory();

    String path = "${dir.path}/Combined_PDI.txt";
    await dioWithHeaders.download(
      apiString,
      (Headers headers) {
        headers.map.values;
        return path;
      },
    );

    return path;
  }

  void downloadAndDisplayPDIFile(BuildContext context) async {
    isLoading(true);
    String? filePath = await downloadCombinedPdiFile();

    // Once the file is downloaded, use context to navigate
    if (filePath != null && context.mounted) {
      Get.to(() => TextFileViewer(filePath: filePath));
    }
    isLoading(false);
  }

  //-------ACTIVE/INACTIVE (TOGGLE API)-----------//

  Future<void> productToggleStatus(String productId, bool isActive) async {
    return await BaseClient.safeApiCall(
      "${ApiConstants.POST_PRODUCT_TOGGLE}/$productId/toggle",
      RequestType.post,
      data: {"isActive": !isActive},
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        changeProductStatus(productId, !isActive);
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  void changeProductStatus(String prodId, bool value) {
    productsPaginationKey.itemList?.forEach((product) {
      if (product.productId.toString() == prodId) {
        product.isActive = value;
      }
    });
    productsPaginationKey.refresh();
  }

  //Bar code ///

  void searchByBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      if (barcode.rawValue != null) {
        log.i('Barcode : ${barcode.rawValue}');
        searchTextController.text = barcode.rawValue ?? '';
        searchProducts(barcode.rawValue ?? "");
        Get.back();
      }
      break;
    }
  }

  // Display Sheet Setting Functions/////

  void onApplyDisplaySetting() {
    isShowActive.value = isShowActiveTemp.value;
    isShowParentCategory.value = isShowParentCategoryTemp.value;
    isShowIndicators.value = isShowIndicatorsTemp.value;
    isShowSalePrice.value = isShowSalePriceTemp.value;
    isShowImage.value = isShowImageTemp.value;

    storeDisplaySetting();
    Get.back();
  }

  void storeDisplaySetting() {
    Map<String, dynamic> displaySettings = {
      'isShowActive': isShowActive.value,
      'isShowParentCategory': isShowParentCategory.value,
      'isShowIndicators': isShowIndicators.value,
      'isShowSalePrice': isShowSalePrice.value,
      'isShowImage': isShowImage.value,
    };
    productContainer.write('displaySettings', displaySettings);
  }

  void retrieveDisplaySetting() {
    if (productContainer.hasData('displaySettings')) {
      Map<String, bool> displaySettings =
          Map<String, bool>.from(productContainer.read('displaySettings'));
      isShowActive.value = displaySettings['isShowActive'] ?? false;
      isShowParentCategory.value =
          displaySettings['isShowParentCategory'] ?? false;
      isShowIndicators.value = displaySettings['isShowIndicators'] ?? false;
      isShowSalePrice.value = displaySettings['isShowSalePrice'] ?? false;
      isShowImage.value = displaySettings['isShowImage'] ?? false;
    }
  }

  // Sorting Sheet Functions //

  void onChangeSort(String fieldName) {
    isSortName.value = false;
    isSortDescription.value = false;
    isSortParentCategory.value = false;
    isSortPrice.value = false;
    isSortTaxable.value = false;
    isSortInStock.value = false;
    isSortActive.value = false;

    switch (fieldName) {
      case 'name':
        isSortName.value = true;
        break;
      case 'description':
        isSortDescription.value = true;
        break;
      case 'parentCategory':
        isSortParentCategory.value = true;
        break;
      case 'price':
        isSortPrice.value = true;
        break;
      case 'taxable':
        isSortTaxable.value = true;
        break;
      case 'inStock':
        isSortInStock.value = true;
        break;
      case 'active':
        isSortActive.value = true;
        break;
    }
  }

  String applySortQuery() {
    String newSortQuery = "";

    if (isSortName.value) {
      newSortQuery = 'productName ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortDescription.value) {
      newSortQuery = 'description ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortPrice.value) {
      newSortQuery = 'price ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortParentCategory.value) {
      newSortQuery =
          'rootCategoryName ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortActive.value) {
      newSortQuery = 'isActive ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortInStock.value) {
      newSortQuery = 'quantityInHand ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortTaxable.value) {
      newSortQuery = 'isTaxable ${isSortAscending.value ? "asc" : "desc"}';
    }

    return newSortQuery;
  }

  void applySortFilters() {
    String newSortQuery = applySortQuery();
    if (newSortQuery == sortQuery) {
      // Do nothing if the new sort query is the same as the current one
      Get.back();
      return;
    }

    // Store the values of the boolean variables in GetStorage
    storeSortValues();

    sortQuery = newSortQuery;
    productsPaginationKey.refresh();
    Get.back();
  }

  void storeSortValues() {
    Map<String, dynamic> sortValues = {
      'sortField': isSortName.value
          ? 'name'
          : isSortDescription.value
              ? 'description'
              : isSortParentCategory.value
                  ? 'parentCategory'
                  : isSortActive.value
                      ? 'active'
                      : isSortInStock.value
                          ? 'inStock'
                          : isSortTaxable.value
                              ? 'taxable'
                              : isSortPrice.value
                                  ? 'price'
                                  : '',
      'isAscending': isSortAscending.value,
    };
    productContainer.write('sortValues', sortValues);
  }

  void retrieveSortValues() {
    if (productContainer.hasData('sortValues')) {
      Map<String, dynamic> sortValues = productContainer.read('sortValues');
      String sortField = sortValues['sortField'] ?? '';
      isSortAscending.value = sortValues['isAscending'] ?? false;
      if (sortField.isNotEmpty) {
        onChangeSort(sortField);
      }
    }
  }

  // Filters Sheet Functions //

  void onParentCategoryChange(List<CategoryModel>? selected) {
    selectedParentCategories = selected;
    update();
  }

  void onTaxFilterChange(String? selected) {
    taxFilter = selected;
    taxFilterController.text = selected!;
    update();
  }

  void onActiveFilterChange(String? selected) {
    activeFilter = selected;
    activeFilterController.text = selected!;
    update();
  }

  void onStockFilterChange(String? selected) {
    stockFilter = selected;
    stockFilterController.text = selected!;
    update();
  }

  void clearFilters() {
    if (newFilterQuery == "") {
      Get.back();
      return;
    }
    newFilterQuery = "";
    parentFilterCategoryController.clear();
    selectedParentCategories?.clear();
    activeFilterController.clear();
    activeFilter = null;
    taxFilterController.clear();
    taxFilter = null;
    stockFilterController.clear();
    stockFilter = null;
    makeOneQueryFromTwo();
    productsPaginationKey.refresh();
    update();
    Get.back();
  }

  void applySelectedFilters() {
    newFilterQuery = "";
    List<String> filters = [];

    if (selectedParentCategories?.isNotEmpty == true) {
      List<String> selectedCategories = [];
      selectedParentCategories?.forEach((category) {
        selectedCategories.add("rootCategoryId eq ${category.rootCategoryId}");
      });
      filters.add("(${selectedCategories.join(" or ")})");
    }

    if (activeFilterController.text.isNotEmpty) {
      if (activeFilterController.text == 'Active') {
        filters.add("isActive eq true");
      } else if (activeFilterController.text == 'Inactive') {
        filters.add("isActive eq false");
      }
    }

    if (taxFilterController.text.isNotEmpty) {
      if (taxFilterController.text == 'Taxable') {
        filters.add("isTaxable eq true");
      } else if (taxFilterController.text == 'Non-Taxable') {
        filters.add("isTaxable eq false");
      }
    }

    if (stockFilterController.text.isNotEmpty) {
      if (stockFilterController.text == 'In Stock') {
        filters.add("quantityInHand ge 1");
      } else if (stockFilterController.text == 'Out of Stock') {
        filters.add("quantityInHand le 0");
      }
    }
    newFilterQuery = filters.join(" and ");
    if (newFilterQuery == searchQuery) {
      // Do nothing if the new filter query is the same as the current one
      Get.back();
      return;
    }

    makeOneQueryFromTwo();
    productsPaginationKey.refresh();
    Get.back();
  }

  /////////////--Serach bar---///////

  void searchProducts(String val) {
    _deBouncer.run(() {
      if (val.isEmpty) {
        searchBarQuery = "";
        searchQuery = newFilterQuery;
      } else {
        searchBarQuery = "(contains(tolower(ProductName),tolower('$val')) or "
            "contains(tolower(description) , tolower('$val'))  or  "
            "contains(tolower(barcode) , tolower('$val')))";
        makeOneQueryFromTwo();
      }
      productsPaginationKey.refresh();
    });
  }

  void makeOneQueryFromTwo() {
    String finalQuery = "";
    if (searchBarQuery.isNotEmpty) {
      finalQuery = searchBarQuery;
    }
    if (newFilterQuery.isNotEmpty) {
      if (finalQuery.isNotEmpty) {
        finalQuery += " and ";
      }
      finalQuery += newFilterQuery;
    }
    searchQuery = finalQuery;
  }

  Future<void> getProductList(int pageKey, String filter, String sort) async {
    try {
      List<ProductModel> newItems = (await BaseClient.safeApiCall(
        ApiConstants.GET_PRODUCT_LIST,
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        queryParameters: {
          '\$count': true,
          '\$skip': pageKey,
          '\$top': ApiConstants.ITEM_COUNT,
          if (filter != '') '\$filter': filter,
          '\$orderby': sort,
        },
        onSuccess: (response) {
          return ProductResponseModel.fromJson(response.data).products ??
              <ProductModel>[];
        },
        onError: (e) {},
      ));

      final isLastPage = newItems.length < ApiConstants.ITEM_COUNT;
      if (isLastPage) {
        productsPaginationKey.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        productsPaginationKey.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      productsPaginationKey.error = error;
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

  @override
  void onInit() {
    retrieveSortValues();
    retrieveDisplaySetting();
    isShowActiveTemp = isShowActive;
    isShowParentCategoryTemp = isShowParentCategory;
    isShowIndicatorsTemp = isShowIndicators;
    isShowSalePriceTemp = isShowSalePrice;
    isShowImageTemp = isShowImage;
    newFilterQuery = "isActive eq true";
    searchBarQuery = "";
    searchQuery = "";
    sortQuery = applySortQuery();
    scaffoldKey = GlobalKey<ScaffoldState>();
    searchTextController = TextEditingController();
    taxFilterController = TextEditingController();
    taxFilter = taxTypeFilters[0];
    parentFilterCategoryController = TextEditingController();
    activeFilterController = TextEditingController();
    activeFilter = activeFilters[1];
    stockFilterController = TextEditingController();
    stockFilter = stockFilters[0];
    combinedPdiDatePickerController = TextEditingController();
    productsPaginationKey = PagingController(firstPageKey: 0);
    makeOneQueryFromTwo();
    productsPaginationKey.addPageRequestListener((pageKey) {
      getProductList(pageKey, searchQuery, sortQuery);
    });

    super.onInit();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    productsPaginationKey.dispose();
    parentFilterCategoryController.dispose();
    taxFilterController.dispose();
    activeFilterController.dispose();
    stockFilterController.dispose();
    combinedPdiDatePickerController.dispose();
    super.dispose();
  }
}
