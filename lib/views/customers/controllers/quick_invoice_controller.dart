import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:zefyrka/zefyrka.dart';
import '../../../exports/index.dart';

class QuickInvoiceController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late RxBool isShowAllRootSearchProducts = false.obs;
  late final PagingController<int, ProductModel> productsPaginationKey;
  // to debounce search effect //
  final _deBouncer = Debouncer(milliseconds: 400);

  late String searchBarQuery = '';

  late List<CategoryProductModel> rootCategoryProducts;
  late List<RootCategory> rootCategories;

  //vendors//
  late VendorModel? vendor;
  late bool isVendorThere = false;

  late Rx<CustomerModel> argsCustomer;
  Map<String, dynamic> arguments = Get.arguments;
  late String pageType;
  RxBool isBottomBarExpanded = false.obs;
  late TransactionSummaryModel transactionSummaryModel;
  late bool viaCustomers;
  late int? editOrderId;
  late int? transactionType;
  late RxList<CustomerCategoryModel> customerCategoryModelList;
  late Key expansionPanelKey;
  late List suggestedProductList;
  late TabController tabController;
  late Map<String, List> tabLists;
  late List<Tab> myTabs = [];
  late RxInt tabIndex = 0.obs;
  late RxBool isLoading;
  late RxBool isShimmerEffectLoading = false.obs;

  late CategoryProductModel recentCategoryProduct = CategoryProductModel();

  List<String> discountTypes = ['None', 'Fixed', 'Percentage'];
  late RxString discountType;
  late TextEditingController discountTypeController;

  late TextEditingController fixedDiscountAmountController;
  late TextEditingController percentageDiscountAmountController;

  late TextEditingController searchTextController;
  late TextEditingController searchTextProductListController;
  late TextEditingController searchBarcodeTextController;
  late TextEditingController billNumberController;
  late ZefyrController notesController;

  late InvoiceCartModel invoiceCart;
  late RxDouble discountTempPercent;
  late double discountTempFixedAmount;
  late String discountTempType;

  //audio related//
  final assetsAudioPlayer = AssetsAudioPlayer();

  //scan related //
  late MobileScannerController scanController;
  late RxBool isScannerEnable = false.obs;
  late RxBool isBarCodeLoading = false.obs;
  late RxBool alwaysScanSwitch = false.obs;
  late RxBool changeSearchBehaviour = false.obs;

  //for scrolling to desire part//
  late final ScrollController scrollController = ScrollController();

  Future getRootProducts(int rootCategoryId) async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_ROOT_CATEGORIES_PRODUCTS}$rootCategoryId',
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        rootCategoryProducts = [];
        for (var i = 0; i < response.data["products"].length; i++) {
          rootCategoryProducts
              .add(CategoryProductModel.fromJson(response.data["products"][i]));
        }
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  @override
  void onInit() async {
    vendor = Get.arguments['vendor'];
    if (vendor != null) {
      isVendorThere = true;
    }
    rootCategories = [];
    rootCategoryProducts = [];
    isLoading = false.obs;
    pageType = arguments['pageType'];
    viaCustomers = arguments['viaCustomers'];
    discountTempPercent = 0.0.obs;
    discountTempFixedAmount = 0.0;
    discountTempType = discountTypes[0];
    discountType = discountTypes[0].obs;
    searchTextController = TextEditingController();
    searchTextProductListController = TextEditingController();
    searchBarcodeTextController = TextEditingController();
    billNumberController = TextEditingController();
    discountTypeController = TextEditingController();
    fixedDiscountAmountController = TextEditingController();
    percentageDiscountAmountController = TextEditingController();
    notesController = ZefyrController(NotusDocument());
    suggestedProductList = [];
    customerCategoryModelList = <CustomerCategoryModel>[].obs;
    tabLists = {
      AppStrings.SHOW_CATEGORY: [],
      AppStrings.FREQUENTLY_ORDERED: [],
      AppStrings.SCAN: [],
    };
    tabLists.forEach((key, value) {
      myTabs.add(Tab(
        text: key,
      ));
    });
    tabController = TabController(length: myTabs.length, vsync: this);
    tabController.animateTo(tabIndex.value);
    isShimmerEffectLoading(true);

    if (pageType == 'edit' || pageType == 'editCredit') {
      argsCustomer = Rx(CustomerModel());
      await initializationFromEdit();
    } else {
      argsCustomer = Rx(arguments['customer']);
      invoiceCart = InvoiceCartModel(
        customerId: argsCustomer.value.customerId,
      );
      await fetchApiDetail(ApiConstants.GET_ROOT_CATEGORIES, '', 5);
      if (!isVendorThere) {
        await fetchApiDetail(
            '${ApiConstants.GET_CATEGORY_PRODUCT_LIST}${argsCustomer.value.customerId}',
            '',
            1);
      }
      invoiceCart.isTaxable.value = argsCustomer.value.isTaxable ?? false;
    }
    isShimmerEffectLoading(false);
    expansionPanelKey = Key("${customerCategoryModelList.length}");
    productsPaginationKey = PagingController(firstPageKey: 0);
    productsPaginationKey.addPageRequestListener((pageKey) {
      getProductList(pageKey, searchBarQuery);
    });
    super.onInit();
  }

  void searchByBarcodeForSearchField(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      if (barcode.rawValue != null) {
        log.i('Barcode : ${barcode.rawValue}');
        searchTextProductListController.text = barcode.rawValue ?? '';
        searchProducts(barcode.rawValue ?? "");
        Get.back();
      }
      break;
    }
  }

  Future<void> getProductList(int pageKey, String filter) async {
    try {
      List<ProductModel> newItems = (await BaseClient.safeApiCall(
        "${ApiConstants.GET_CUSTOMER_BASED_PRODUCT_LIST}(CustomerId=${argsCustomer.value.customerId})",
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        queryParameters: {
          '\$count': true,
          '\$skip': pageKey,
          '\$top': ApiConstants.ITEM_COUNT,
          if (filter != '') '\$filter': filter,
          '\$orderby': 'productName asc',
        },
        onSuccess: (response) {
          if (isVendorThere) {
            return ProductResponseModel.fromVendorJson(response.data)
                    .products ??
                <ProductModel>[];
          } else {
            return ProductResponseModel.fromJson(response.data).products ??
                <ProductModel>[];
          }
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

  void getRootCategoryList(dynamic json) =>
      rootCategories = RootCategory().createRootCategoriesList(json);

  Future<void> convertToBill(String id) async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_BILL}$id/convertToBill',
      RequestType.post,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        Get.snackbar(
          'Success',
          'Bill Created Successfully!',
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

  Future<void> getVendorProductListFromSearch(String val) async {
    val = val.toLowerCase();
    await BaseClient.safeApiCall(
      ApiConstants.GET_PRODUCT_LIST,
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      queryParameters: {
        '\$filter':
            "isActive eq true and (contains(tolower(ProductName),'$val') or contains(tolower(Description),'$val') or contains(tolower(barcode),'$val'))",
        '\$orderby': 'ProductName',
      },
      onSuccess: (response) {
        suggestedProductList = [];
        for (var i = 0; i < response.data['value'].length; i++) {
          suggestedProductList.add(response.data['value'][i]['productName']);
        }
      },
      onError: (e) {},
    );
  }

  void onToggleAlwaysScanSwitch(bool val) => alwaysScanSwitch.value = val;

  void checkIfCartEmpty(BuildContext context) {
    //for customers//
    if (invoiceCart.items.isNotEmpty && !isVendorThere) {
      if (pageType == 'edit' || pageType == 'editCredit') {
        _showEditAlertDialog(context, () => onSavingInvoice());
      } else {
        _showAlertDialog(context, () {
          Get.back();
          Get.back();
        });
      }
      //for vendors//
    } else if (invoiceCart.items.isNotEmpty && isVendorThere) {
      if (pageType == 'edit' || pageType == 'editCredit') {
        _showEditAlertDialog(context, () => onSavingBill());
      } else {
        _showAlertDialog(context, () {
          Get.back();
          Get.back();
        });
      }
    }
    //when cart is empty//
    else {
      Get.back();
    }
  }

  static void _showAlertDialog(BuildContext context, VoidCallback onPress) {
    PanaraConfirmDialog.show(
      context,
      title: "Are you sure?",
      message: 'Cart is not Empty!',
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      color: context.primaryColor,
      onTapCancel: Get.back,
      onTapConfirm: onPress,
      panaraDialogType: PanaraDialogType.custom,
    );
  }

  void _showEditAlertDialog(BuildContext context, VoidCallback onPress) {
    String txt = "order";
    if (transactionType == 1) {
      txt = 'invoice';
    } else if (transactionType == 2) {
      txt = 'credit memo';
    } else if (transactionType == 5) {
      txt = 'bill';
    } else if (transactionType == 6) {
      txt = 'purchase order';
    }
    PanaraConfirmDialog.show(
      context,
      title: "Do you want to update $txt?",
      message: '',
      textColor: context.iconColor1,
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      color: context.primaryColor,
      onTapCancel: () {
        Get.back();
        Get.back();
      },
      onTapConfirm: onPress,
      panaraDialogType: PanaraDialogType.custom,
    );
  }

  void _scrollToPanel(int index) {
    if (tabIndex.value == 1) {
      final double offset = index * 56;
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.slowMiddle,
      );
    }
  }

  Future searchByBarcode(Barcode barcode, BuildContext context) async {
    if (barcode.rawValue != null && !isBarCodeLoading.value) {
      log.i('Barcode : ${barcode.rawValue}');
      if (!alwaysScanSwitch.value) {
        isBarCodeLoading.value = true;
        toggleScannerOnOff(false);
      }
      await getProductListFromScanner(barcode.rawValue ?? '', context);
    }
  }

  void searchByBarcodeInAddNewLine(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      if (barcode.rawValue != null) {
        log.i('Barcode : ${barcode.rawValue}');
        searchTextController.text = barcode.rawValue ?? '';
        Get.back();
      }
      break;
    }
  }

  void onPressTabToScan() {
    if (isBarCodeLoading.value) {
      isBarCodeLoading.value = false;
      scanController.start();
    }
  }

  void onTabChange(int index) async {
    tabIndex.value = index;
    if (index == 2) {
      isScannerEnable.value = true;
      toggleScannerOnOff(true);
    } else {
      toggleScannerOnOff(false);
      isScannerEnable.value = false;
    }
  }

  void toggleScannerOnOff(bool button) async {
    if (button) {
      scanController = MobileScannerController(
          torchEnabled: false,
          formats: [BarcodeFormat.all],
          facing: CameraFacing.back,
          returnImage: true,
          detectionSpeed: DetectionSpeed.noDuplicates);
    } else {
      if (isScannerEnable.value) {
        await scanController.stop();
      }
    }
  }

  void playSoundOnScanner({bool added = true}) {
    if (added) {
      assetsAudioPlayer.open(
        Audio("assets/audios/scan_sound.mp3"),
      );
    } else {
      assetsAudioPlayer.open(
        Audio("assets/audios/scan_error_sound.mp3"),
      );
    }
  }

  Future<void> getProductListFromScanner(
      String val, BuildContext context) async {
    await BaseClient.safeApiCall(
      "${ApiConstants.GET_CUSTOMER_BASED_PRODUCT_LIST}(CustomerId=${argsCustomer.value.customerId})",
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      queryParameters: {
        '\$filter':
            "contains(tolower(ProductName),'$val') or contains(tolower(Description),'$val') or contains(tolower(barcode),'$val')",
        '\$orderby': 'ProductName',
      },
      onSuccess: (response) {
        if (response.data['value'].length == 1) {
          playSoundOnScanner();
          CategoryProductModel prod = addSuggestedProduct(
              type: 'barCodeScanner', response.data['value'].first);
          onAddRemoveItem(
              1, prod, getIndexFromCategoryName(prod.rootCategoryName ?? ''),
              addUpQuantity: true, addNewLine: true);
        } else if (response.data['value'].length > 1) {
          showMultipleScannedProducts(response, context);
        } else {}
      },
      onError: (e) {
        if (e.statusCode == 404) {
          Get.snackbar(
            'Product Not Found!',
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.only(bottom: 25),
            'No product with such barcode exists. i-e $val',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          playSoundOnScanner(added: false);
        }
      },
    );
  }

  void showMultipleScannedProducts(response, BuildContext context) {
    Get.dialog(AlertDialog(
        titlePadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        title: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28.0),
              topRight: Radius.circular(28.0),
            ),
            color: context.primaryColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          width: double.maxFinite,
          child: Text(
            "Products with same barcode",
            textAlign: TextAlign.center,
            style: context.titleMedium,
          ),
        ),
        content: SizedBox(
          width: Get.width,
          height: 200,
          child: ListView.builder(
            itemCount: response.data['value'].length,
            itemBuilder: (context, index) {
              final prod = addSuggestedProduct(
                  type: 'barCodeScanner', response.data['value'][index]);
              return InkWell(
                onTap: () {
                  onAddRemoveItem(1, prod,
                      getIndexFromCategoryName(prod.rootCategoryName ?? ''),
                      addUpQuantity: true, addNewLine: true);
                  playSoundOnScanner();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    prod.productName ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              );
            },
          ),
        )));
  }

  void onPressChangeSearchBehaviour() =>
      changeSearchBehaviour(!changeSearchBehaviour.value);

  void onPressAddProductButton() async {
    tabController.index = 1;
    tabIndex.value = 1;
    var result = await Get.toNamed(
      AppRoutes.ADD_PRODUCT,
      arguments: {
        'backRoute': true,
        'fromQuickInvoice': true,
      },
    );
    if (result != null) {
      await onSuggestionSelection(result['name']);
    }
  }

  Future initializationFromEdit() async {
    transactionSummaryModel = arguments['transactionSummaryModel'];
    invoiceCart = InvoiceCartModel(
      customerId: transactionSummaryModel.customerId,
    );
    var data;
    await fetchApiDetail(ApiConstants.GET_ROOT_CATEGORIES, '', 5);
    if (!isVendorThere) {
      await fetchApiDetail(
          '${ApiConstants.GET_CATEGORY_PRODUCT_LIST}${transactionSummaryModel.customerId}',
          '',
          1);
      data = await getOrder(
          transactionSummaryModel.transaction ?? 'Sales Order',
          "${transactionSummaryModel.id}");
    } else {
      data = await getBill(
          transactionSummaryModel.transaction ?? 'Purchase Order',
          "${transactionSummaryModel.id}");
    }
    editOrderId = transactionSummaryModel.id;
    transactionType = transactionSummaryModel.transactionType;

    if (data != null) {
      invoiceCart = InvoiceCartModel(
        customerId: data['customerId'],
      );
      invoiceCart.isTaxable.value =
          data['isTaxable'] ?? (data['totalTax'] != 0) ? true : false;
      //setting up customer //
      CustomerModel customerModel = CustomerModel();
      customerModel.customerId = data['customerId'];
      customerModel.customerName = data['customerName'];
      customerModel.companyName = data['companyName'];
      customerModel.isQBCustomer = data['isQBCustomer'];
      customerModel.address1 = data['customerAddress'];
      customerModel.city = data['customerCity'];
      customerModel.openBalance = data['customerOpenBalance'];
      customerModel.state = data['customerState'];
      customerModel.postalCode = data['customerPostalCode'];
      customerModel.email = data['customerEmail'];
      customerModel.state = data['customerState'];
      customerModel.phoneNo = data['customerPhoneNo'];
      customerModel.taxPercent = data['taxPercent'];
      customerModel.openBalance = data['openBalance'];
      customerModel.isTaxable = invoiceCart.isTaxable.value;
      argsCustomer.value = customerModel;

      //for getting bill number//
      billNumberController.text = data["referenceNumber"] ?? "";
      //for getting memo //
      if (data["memo"] != null) {
        notesController.replaceText(0, 0, "${data["memo"]}");
      }

      //setting up discount for showing edit data //
      if (data['discountType'] == 'fixed') {
        discountTempType = discountTypes[1];
        discountTempFixedAmount = data['discountValue'];
      } else if (data['discountType'] == 'percent') {
        discountTempType = discountTypes[2];
        discountTempPercent.value = data['discountValue'];
      }
      //adding items to cart //
      for (var i = 0; i < data['items'].length; i++) {
        CategoryProductModel prod =
            addSuggestedProduct(data['items'][i], type: 'edit');

        onAddRemoveItem(
          prod.quantity,
          prod,
          getIndexFromCategoryName(
            prod.rootCategoryName ?? '',
          ),
        );
      }
      isBottomBarExpanded.value = true;
    }
  }

  Future getProduct(String prodId) async {
    final headers = await BaseClient.generateHeaders();

    return await BaseClient.safeApiCall(
      ApiConstants.GET_PRODUCT + prodId,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        return ProductModel.fromProductDetailsJson(response.data);
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

  void calculateAllAmounts() {
    if (isVendorThere) {
      invoiceCart.calculateVendorTaxedAmount();
      invoiceCart.calculateVendorTotal();
    } else {
      invoiceCart.calculateTaxedAmount();
      invoiceCart.calculateTotal();
    }
    if (discountTempType == discountTypes[1]) {
      invoiceCart.calculateDiscount('fixed', discountTempFixedAmount);
    } else if (discountTempType == discountTypes[2]) {
      invoiceCart.calculateDiscount('percent', discountTempPercent.value);
    }
  }

  void onApplyDiscount() {
    discountTempType = discountType.value;
    if (discountTempType == discountTypes[2] &&
        percentageDiscountAmountController.text.isNotEmpty) {
      discountTempPercent.value =
          percentageDiscountAmountController.text.toDouble();
    } else if (discountTempType == discountTypes[1] &&
        fixedDiscountAmountController.text.isNotEmpty) {
      discountTempFixedAmount = fixedDiscountAmountController.text.toDouble();
    } else {
      //clear discount value
      invoiceCart.discountedAmount.value = 0.0;
      discountTempFixedAmount = 0.0;
      discountTempPercent.value = 0.0;
      fixedDiscountAmountController.clear();
      percentageDiscountAmountController.clear();
    }
    calculateAllAmounts();
    Get.back();
  }

  bool isDiscountSelected() {
    return (discountTempPercent.value != 0.0 ||
        discountTempFixedAmount != 0.00);
  }

  void onDiscountTypeChange(String? selected) {
    if (selected != null) {
      discountType.value = selected;
      discountTypeController.text = selected;
    }
  }

  void countSelectedItems(int categoryIndex) {
    if (invoiceCart.items.isNotEmpty) {
      List cartItemSet = [];
      List productsSet = [];
      for (var i = 0; i < invoiceCart.items.length; i++) {
        cartItemSet.add(invoiceCart.items[i].productId);
      }

      for (var i = 0;
          i < customerCategoryModelList[categoryIndex].products.length;
          i++) {
        productsSet.add(
            customerCategoryModelList[categoryIndex].products[i].productId);
      }

      final commonItems = intersection([cartItemSet, productsSet]);

      customerCategoryModelList[categoryIndex].selectedItemCount.value =
          commonItems.length;
    }
  }

  List<T> intersection<T>(Iterable<Iterable<T>> iterables) {
    return iterables
        .map((e) => e.toSet())
        .reduce((a, b) => a.intersection(b))
        .toList();
  }

  int getIndexFromCategoryName(String name) {
    for (var categoryModel in customerCategoryModelList) {
      if (name == categoryModel.categoryName) {
        return customerCategoryModelList.indexOf(categoryModel);
      }
    }
    return -1;
  }

  void onPressDeleteInvoiceItem(int index) {
    invoiceCart.items.removeAt(index);
    calculateAllAmounts();
    invoiceCart.items.refresh();
  }

  bool isAnyCartItemExist(CustomerCategoryModel cat) {
    int count = 0;
    for (var prod in cat.products) {
      if (invoiceCart.items.any((item) => item.productId == prod.productId)) {
        count++;
      }
    }

    if (count > 0) {
      cat.selectedItemCount.value = count;
      return true;
    } else {
      return false;
    }
  }

  int getIndexIfCartItemExist(CategoryProductModel prod,
      {bool addNewLine = false}) {
    return !addNewLine
        ? invoiceCart.items.indexWhere((item) => item == prod)
        : invoiceCart.items
            .indexWhere((item) => item.productId == prod.productId);
  }

  void onAddRemoveItem(
      double val, CategoryProductModel productModel, int categoryIndex,
      {bool addUpQuantity = false, bool addNewLine = false}) {
    int index = getIndexIfCartItemExist(productModel, addNewLine: addNewLine);
    if (val != 0) {
      //if item doesn't exist, add to cart and change quantity
      if (index == -1) {
        invoiceCart.items.add(productModel);
        invoiceCart.items.last.quantity = val;
        //if item exists, only change quantity //
      } else {
        //type of change in quantity
        if (addUpQuantity) {
          invoiceCart.items[index].quantity += val;
        } else {
          invoiceCart.items[index].quantity = val;
        }
      }
    } else {
      //remove item if any when quantity is zero
      if (index != -1) {
        invoiceCart.items.removeAt(index);
      }
    }
    calculateAllAmounts();

    // countSelectedItems(categoryIndex);
    invoiceCart.items.refresh();
  }

  void getSuggestedProductList(dynamic json) {
    if (suggestedProductList.isEmpty) {
      suggestedProductList = json.data['value'];
    } else {
      suggestedProductList.clear();
      suggestedProductList = json.data['value'];
    }
  }

  void onOpenCategoryTile(int index, bool isExpanded) {
    for (var element in customerCategoryModelList) {
      element.isExpanded(false);
    }
    customerCategoryModelList[index].isExpanded(!isExpanded);
  }

  CategoryProductModel addSuggestedProduct(dynamic json,
      {String type = 'create', bool addNewLine = false}) {
    CategoryProductModel categoryProductModel;
    if (type == 'edit') {
      categoryProductModel = CategoryProductModel.fromEditOrderJson(json);
    } else if (type == 'barCodeScanner') {
      categoryProductModel = CategoryProductModel.fromMainProductJson(json);
    } else {
      categoryProductModel = CategoryProductModel.fromJson(json);
    }
    recentCategoryProduct = categoryProductModel;
    bool categoryFound = false;
    for (int index = 0; index < customerCategoryModelList.length; index++) {
      var category = customerCategoryModelList[index];
      //if the product's Category already exist //
      if (category.categoryName == categoryProductModel.rootCategoryName) {
        Set<int?> productIds =
            category.products.map((product) => product.productId).toSet();
        //if prod doesn't already exist //
        // Add the prod //
        if (!productIds.contains(categoryProductModel.productId)) {
          category.products.add(categoryProductModel);
          onOpenCategoryTile(index, false);
          _scrollToPanel(index);
        } else {
          //if product already exist in the list//
          if (addNewLine) {
            category.products.add(categoryProductModel);
          }

          onOpenCategoryTile(index, false);
          _scrollToPanel(index);
          if (pageType != 'edit' &&
              type != 'barCodeScanner' &&
              pageType != 'editCredit') {
            Get.snackbar(
              'Product already exists in the category list!',
              margin: const EdgeInsets.only(bottom: 25),
              '',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blueGrey,
              colorText: Colors.white,
            );
            return categoryProductModel;
          }
        }

        categoryFound = true;
        break;
      }
    }
    //if the product's Category doesn't exist //
    if (!categoryFound) {
      //Create new and add category//
      customerCategoryModelList.add(
        CustomerCategoryModel(
          categoryName: categoryProductModel.rootCategoryName ?? '',
          products: [categoryProductModel],
        ),
      );
      //changing key to avoid duplication in widget tree//
      expansionPanelKey = Key("${customerCategoryModelList.length}");
      if (type == 'create' || type == 'barCodeScanner') {
        onOpenCategoryTile(customerCategoryModelList.length - 1, false);
      }
      _scrollToPanel(customerCategoryModelList.length - 1);
    }
    return categoryProductModel;
  }

  Future onSuggestionSelection(suggestion) async {
    if (suggestion != '') {
      await fetchApiDetail(
          '${ApiConstants.GET_PRODUCT_DETAIL}${argsCustomer.value.customerId})',
          "ProductName eq '$suggestion'",
          3);
    }
  }

  Future<CategoryProductModel?> addNewLineSuggestion(suggestion) async {
    if (suggestion != '') {
      final completer = Completer<CategoryProductModel?>();

      await BaseClient.safeApiCall(
        '${ApiConstants.GET_PRODUCT_DETAIL}${argsCustomer.value.customerId})',
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        queryParameters: {
          '\$filter': "ProductName eq '$suggestion'",
        },
        onSuccess: (response) {
          final productModel =
              addSuggestedProduct(response.data['value'].first);
          completer.complete(productModel);
        },
        onError: (e) {
          Get.defaultDialog(
            title: 'Something went wrong',
            middleText: e.message,
            middleTextStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          );
          completer.complete(null);
        },
      );

      return completer.future;
    }

    return null;
  }

  Future onFetchingOrderHistoryProd(CategoryProductModel prod) async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_ORDER_HISTORY}${argsCustomer.value.customerId}/${prod.productId}',
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        final List<dynamic> lastOrdersList = response.data["lastOrders"];

        if (lastOrdersList.isNotEmpty) {
          final ordersToAdd = lastOrdersList
              .map((order) => OrderHistoryModel.fromJson(order))
              .toList();
          prod.lastOrders.addAll(ordersToAdd);
        } else {
          Get.snackbar(
            'Sales History not Found',
            margin: const EdgeInsets.only(bottom: 25),
            '',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blueAccent,
            colorText: Colors.white,
          );
        }
      },
      onError: (e) {
        Get.defaultDialog(
            title: 'Something went wrong',
            middleText: e.message,
            middleTextStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700));
      },
    );
  }

  Future<List> suggestionCallback(pattern) async {
    if (isVendorThere) {
      await getVendorProductListFromSearch(pattern.toString());
    } else {
      await fetchApiDetail(
          ApiConstants.GET_SUGGESTED_PRODUCT_LIST,
          "(contains(tolower(ProductName),'${pattern.toString().toLowerCase()}') or contains(tolower(barcode),'${pattern.toString().toLowerCase()}') or contains(tolower(Description),'${pattern.toString().toLowerCase()}'))",
          2);
    }
    return suggestedProductList;
  }

  // Get already generated ORDERS, INVOICES details (edit,view)//
  Future getOrder(String type, String transactionId) async {
    final headers = await BaseClient.generateHeaders();
    String apiString = '';
    if (type == 'Sales Order') {
      apiString = ApiConstants.GET_EDIT_SALES_ORDER + transactionId;
    } else {
      apiString = ApiConstants.GET_EDIT_INVOICE + transactionId;
    }
    return await BaseClient.safeApiCall(
      apiString,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        return response.data;
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

  // Get already generated Purchase ORDERS, Bills details (edit,view)//
  Future getBill(String type, String transactionId) async {
    final headers = await BaseClient.generateHeaders();
    String apiString = '';
    if (type == 'Purchase Order') {
      apiString = '${ApiConstants.POST_NEW_PURCHASE_ORDER}/$transactionId';
    } else {
      apiString = ApiConstants.GET_BILL + transactionId;
    }
    return await BaseClient.safeApiCall(
      apiString,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        return response.data;
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

  //Create Invoice or New Sales Order//
  Future<void> saveOrder(String type) async {
    isLoading(true);
    String? disType;
    double? disValue;
    bool salesOrderId = false;

    if (discountTempType != discountTypes[0]) {
      disType = discountTempType;
      if (discountTempType == discountTypes[1]) {
        disValue = discountTempFixedAmount;
      } else {
        disValue = discountTempPercent.value;
      }
    }

    final headers = await BaseClient.generateHeaders();
    String apiString = '';
    String transactionString = '';
    int transactionType = 0;
    int transactionId = 0;
    String transactionDate = '2023-03-09';
    RequestType requestType = RequestType.post;
    if (type == 'salesOrder') {
      if (pageType == 'create') {
        apiString = ApiConstants.POST_NEW_SALES_ORDER;
      } else if (pageType == 'edit') {
        apiString = ApiConstants.POST_EDIT_SALES_ORDER;
        salesOrderId = true;
      }
      transactionString = 'Sales Order';
      transactionType = 4;
    } else if (type == 'invoiceOrder') {
      transactionString = 'Invoice';
      transactionType = 1;
      if (pageType == 'create') {
        apiString = ApiConstants.POST_PUT_NEW_ORDER_INVOICE;
      } else if (pageType == 'edit') {
        requestType = RequestType.put;
        apiString = ApiConstants.POST_PUT_NEW_ORDER_INVOICE;
      } else if (pageType == 'credit' || pageType == 'editCredit') {
        apiString = '${ApiConstants.POST_PUT_NEW_ORDER_INVOICE}/creditmemo';
        transactionString = 'Credit Memo';
        transactionType = 2;
      }
    }
    return await BaseClient.safeApiCall(
      apiString,
      requestType,
      headers: headers,
      data: {
        "customerId": invoiceCart.customerId,
        "isTaxable": invoiceCart.isTaxable.value,
        "isTaxableInvoice": invoiceCart.isTaxable.value,
        if (notesController.plainTextEditingValue.text.length > 1)
          "memo": notesController.plainTextEditingValue.text,
        "discountType": disType,
        "discountValue": disValue,
        "items": [
          for (var i = 0; i < invoiceCart.items.length; i++)
            {
              "productId": invoiceCart.items[i].productId,
              "quantity": invoiceCart.items[i].quantity,
              "price": invoiceCart.items[i].price,
              "isDamaged": invoiceCart.items[i].isDamaged ?? false,
              "isTaxable": invoiceCart.items[i].isTaxable,
              "suggestedRetailPrice":
                  invoiceCart.items[i].suggestedRetailPrice ?? 0.0
            }
        ],
        if (pageType == 'edit' || pageType == 'editCredit')
          "orderId": editOrderId,
        if (salesOrderId) "salesOrderId": editOrderId,
      },
      onSuccess: (response) async {
        if (response.data['orderId'] != null) {
          transactionId = response.data['orderId'];
          transactionDate = response.data['invoiceDate'];
        } else {
          transactionId = response.data['salesOrderId'];
        }
        TransactionSummaryModel transactionSummaryModel =
            TransactionSummaryModel(
                customerId: invoiceCart.customerId ?? 0,
                customerName: argsCustomer.value.customerName ?? '',
                transaction: transactionString,
                id: transactionId,
                date: transactionDate,
                transactionType: transactionType);
        Get.snackbar(
          'Success',
          type == 'salesOrder' ? 'Sales Order Saved!' : 'Invoice Order Saved!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading(false);

        if (viaCustomers) {
          Get.toNamed(AppRoutes.INVOICE_VIEW, arguments: {
            'customer': argsCustomer.value,
            "transactionSummaryModel": transactionSummaryModel,
          });
        } else {
          Get.toNamed(AppRoutes.INVOICE_VIEW, arguments: {
            "transactionSummaryModel": transactionSummaryModel,
          });
        }

        // moveBackToInitialPage();
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
        isLoading(false);
      },
    );
  }

  //Create Bill or New Purchase Order//
  Future<void> saveVendorOrder(String type) async {
    isLoading(true);
    String? disType;
    double? disValue;

    String transactionString = '';
    int transactionType = 0;
    int transactionId = 0;
    String transactionDate = '2023-03-09';

    if (discountTempType != discountTypes[0]) {
      disType = discountTempType;
      if (discountTempType == discountTypes[1]) {
        disValue = discountTempFixedAmount;
      } else {
        disValue = discountTempPercent.value;
      }
    }

    final headers = await BaseClient.generateHeaders();
    String apiString = '';
    String msgShow = '';
    RequestType requestType = RequestType.post;
    if (type == 'purchaseOrder') {
      transactionType = 6;
      transactionString = 'Purchase Order';
      msgShow = 'Purchase Order Saved!';
      if (pageType == 'create' || pageType == 'edit') {
        apiString = ApiConstants.POST_NEW_PURCHASE_ORDER;
      }
    } else if (type == 'bill') {
      transactionType = 5;
      transactionString = 'Purchase Bill';
      msgShow = 'Bill Saved!';
      if (pageType == 'create' || pageType == 'edit') {
        apiString = ApiConstants.POST_NEW_BILL;
      } else if (pageType == 'credit' || pageType == 'editCredit') {
        apiString = ApiConstants.POST_NEW_PURCHASE_CREDIT_MEMO;
        transactionString = 'Purchase Credit Memo';
        transactionType = 7;
      }
    }
    return await BaseClient.safeApiCall(
      apiString,
      requestType,
      headers: headers,
      data: {
        "customerId": invoiceCart.customerId,
        "isTaxable": invoiceCart.isTaxable.value,
        if (notesController.plainTextEditingValue.text.length > 1)
          "memo": notesController.plainTextEditingValue.text,
        "discountType": disType,
        "discountValue": disValue,
        "items": [
          for (var i = 0; i < invoiceCart.items.length; i++)
            {
              "productId": invoiceCart.items[i].productId,
              "quantity": invoiceCart.items[i].quantity,
              "price": invoiceCart.items[i].price,
              "cost": invoiceCart.items[i].cost,
              "isTaxable": invoiceCart.items[i].isTaxable,
              "suggestedRetailPrice":
                  invoiceCart.items[i].suggestedRetailPrice ?? 0.0
            }
        ],
        if (pageType == 'edit' || pageType == 'editCredit')
          "orderId": editOrderId,
        if (pageType == 'edit' || pageType == 'editCredit')
          "salesOrderId": editOrderId,
        if (type == 'bill') "referenceNumber": billNumberController.text,
      },
      onSuccess: (response) async {
        Get.snackbar(
          'Success',
          msgShow,
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        transactionId = response.data['orderId'];
        transactionDate = response.data['invoiceDate'];

        TransactionSummaryModel transactionSummaryModel =
            TransactionSummaryModel(
                customerId: invoiceCart.customerId ?? 0,
                customerName: argsCustomer.value.customerName ?? '',
                transaction: transactionString,
                id: transactionId,
                date: transactionDate,
                transactionType: transactionType);

        if (viaCustomers) {
          Get.toNamed(AppRoutes.INVOICE_VIEW, arguments: {
            'customer': argsCustomer.value,
            "transactionSummaryModel": transactionSummaryModel,
            'vendor': true
          });
        } else {
          Get.toNamed(AppRoutes.INVOICE_VIEW, arguments: {
            "transactionSummaryModel": transactionSummaryModel,
            'vendor': true
          });
        }

        isLoading(false);
        // moveBackToInitialPage();
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
        isLoading(false);
      },
    );
  }

  Future<void> convertToInvoice(String salesOrderId) async {
    isLoading(true);
    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_CONVERT_TO_INVOICE}$salesOrderId/convertToInvoice',
      RequestType.post,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        isLoading(false);
        Get.snackbar(
          'Success',
          'Invoice Created Successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        moveBackToInitialPage();
      },
      onError: (e) {
        isLoading(false);
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

  void moveBackToInitialPage() {
    if (pageType == 'create' || pageType == 'credit') {
      if (viaCustomers) {
        Get.offNamedUntil(AppRoutes.CUSTOMER_DETAIL,
            (route) => route.settings.name == AppRoutes.CUSTOMERS,
            arguments: {
              'viaCustomers': true,
              'customer': argsCustomer.value,
            });
      } else {
        Get.offAllNamed(AppRoutes.CUSTOMER_DETAIL, arguments: {
          'viaCustomers': false,
          'orderType': transactionType,
        });
      }
    } else {
      if (viaCustomers) {
        Get.offNamedUntil(AppRoutes.CUSTOMER_DETAIL,
            (route) => route.settings.name == AppRoutes.CUSTOMERS,
            arguments: {
              'viaCustomers': true,
              'customer': arguments['customer'],
            });
      } else {
        Get.offAllNamed(AppRoutes.CUSTOMER_DETAIL, arguments: {
          'viaCustomers': false,
          'orderType': transactionType,
        });
      }
    }
  }

  //Customer Preferred Category List //
  Future fetchApiDetail(String string, String filter, int api) async {
    return await BaseClient.safeApiCall(
      string,
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      queryParameters: {
        '\$filter': filter,
      },
      onSuccess: (response) {
        switch (api) {
          case 1:
            {
              return getCustomerCategoryList(response);
            }
          case 2:
            {
              return getSuggestedProductList(response);
            }
          case 3:
            {
              addSuggestedProduct(response.data['value'].first);
              onAddRemoveItem(
                  1,
                  recentCategoryProduct,
                  getIndexFromCategoryName(
                      recentCategoryProduct.rootCategoryName ?? ''),
                  addUpQuantity: true,
                  addNewLine: true);
              return;
            }
          case 5:
            {
              return getRootCategoryList(response.data);
            }
          default:
            {}
            break;
        }
      },
      onError: (e) {
        Get.defaultDialog(
            title: 'Something went wrong',
            middleText: e.message,
            middleTextStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700));
      },
    );
  }

  void getCustomerCategoryList(dynamic json) {
    customerCategoryModelList.clear();
    if (customerCategoryModelList.isEmpty) {
      json.data.forEach((v) {
        customerCategoryModelList.add(CustomerCategoryModel.fromJson(v));
      });
      for (var element in customerCategoryModelList) {
        element.products.sort(
            (a, b) => (a.productName ?? '').compareTo(b.productName ?? ''));
      }
    }
  }

  void onSubmitSearchBarcode(String? barcodeText, BuildContext context) async =>
      await getProductListFromScanner(barcodeText ?? '', context);

  void onSavingInvoice() async {
    bool isUpdateInvoice = false;
    bool isShowSubmitMemo = false;

    if (pageType == 'edit') {
      if (transactionType == 1) {
        isUpdateInvoice = true;
      }
    }
    if (pageType == 'credit' || pageType == 'editCredit') {
      isShowSubmitMemo = true;
      isUpdateInvoice = true;
    }

    if (!isUpdateInvoice) {
      invoiceCart.items.isNotEmpty ? await saveOrder('salesOrder') : null;
    } else {
      invoiceCart.items.isNotEmpty ? await saveOrder('invoiceOrder') : null;
    }
  }

  void onSavingBill() async {
    bool isUpdateBilll = false;
    bool isShowSubmitMemo = false;

    if (pageType == 'edit') {
      if (transactionType == 5) {
        isUpdateBilll = true;
      }
    }
    if (pageType == 'credit' || pageType == 'editCredit') {
      isShowSubmitMemo = true;
      isUpdateBilll = true;
    }

    if (!isUpdateBilll) {
      invoiceCart.items.isNotEmpty
          ? await saveVendorOrder('purchaseOrder')
          : null;
    } else {
      invoiceCart.items.isNotEmpty ? await saveVendorOrder('bill') : null;
    }
  }

  void searchProducts(String val) {
    _deBouncer.run(() {
      searchBarQuery = "(contains(tolower(ProductName),tolower('$val')) or "
          "contains(tolower(description) , tolower('$val'))  or  "
          "contains(tolower(barcode) , tolower('$val')))";

      productsPaginationKey.refresh();
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    searchTextProductListController.dispose();
    searchBarcodeTextController.dispose();
    billNumberController.dispose();
    discountTypeController.dispose();
    fixedDiscountAmountController.dispose();
    tabController.dispose();
    percentageDiscountAmountController.dispose();
    notesController.dispose();
    scanController.dispose();
    scrollController.dispose();
    productsPaginationKey.dispose();
    super.dispose();
  }
}
