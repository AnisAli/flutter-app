import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../exports/index.dart';
import '../../customers/components/pdf_screen.dart';

class SalesByIndividualItemController extends GetxController with StateMixin {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  final _deBouncer = Debouncer(milliseconds: 400);

  late final PagingController<int, CustomerModel> customersPaginationKey;
  late final PagingController<int, ProductModel> productsPaginationKey;
  late String customerSearchQuery;
  late String productSearchQuery;
  late String customerSearchBarQuery;
  late String newFilterQuery;
  late String productSearchBarQuery;
  late String customerSortQuery;
  late String productSortQuery;
  late TextEditingController customerSearchTextController;
  late TextEditingController productSearchTextController;

  Future<void> getCustomerList(pageKey, String filter, String sort) async {
    try {
      List<CustomerModel> newItems = (await BaseClient.safeApiCall(
        ApiConstants.GET_CUSTOMER_LIST,
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        queryParameters: {
          '\$count': true,
          '\$skip': pageKey,
          '\$top': ApiConstants.ITEM_COUNT,
          if (filter != '') '\$filter': filter,
          if (sort != '') '\$orderby': sort,
        },
        onSuccess: (json) {
          List<CustomerModel>? customers;
          if (json.data['value'] != null) {
            customers = [];
            json.data['value'].forEach((v) {
              customers?.add(CustomerModel.fromJson(v));
            });
          }
          return customers;
        },
        onError: (e) {},
      ));
      for (CustomerModel customer in newItems) {
        if (customer.companyName != null) {
          allCustomers
              .add({'name': customer.customerName, 'id': customer.customerId});
          //customerFilters.add(customer.customerName!);
        }
      }
      update(['customers']);

      final isLastPage = newItems.length < ApiConstants.ITEM_COUNT;
      if (isLastPage) {
        customersPaginationKey.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        customersPaginationKey.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      customersPaginationKey.error = error;
    }
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
          if (sort != '') '\$orderby': sort,
        },
        onSuccess: (json) {
          List<ProductModel>? products;
          if (json.data['value'] != null) {
            products = [];
            json.data['value'].forEach((v) {
              products?.add(ProductModel.fromJson(v));
            });
          }
          return products;
        },
        onError: (e) {},
      ));
      for (ProductModel product in newItems) {
        if (product.productName != null) {
          allProducts
              .add({'name': product.productName, 'id': product.productId});
          //productFilters.add(product.productName!);
        }
      }
      update(['products']);

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

  void onClearProductSearchBar() {
    if (productSearchTextController.text != "") {
      productSearchTextController.clear();
      searchProducts("");
    }
  }

  void makeOneProductQueryFromTwo() {
    String finalQuery = "";
    if (newFilterQuery.isNotEmpty) {
      finalQuery = newFilterQuery;
    }
    if (productSearchBarQuery.isNotEmpty) {
      if (finalQuery.isNotEmpty) {
        finalQuery += " and ";
      }
      finalQuery += productSearchBarQuery;
    }
    productSearchQuery = finalQuery;
  }

  void searchProducts(String val) {
    _deBouncer.run(() {
      if (val.isEmpty) {
        productSearchBarQuery = "";
        productSearchQuery = newFilterQuery;
      } else {
        productSearchBarQuery = "("
            "contains(tolower(productName) , tolower('$val'))  or"
            "contains(tolower(description) , tolower('$val'))  or"
            "contains(tolower(barcode) , tolower('$val'))  or"
            "contains(tolower(notes) , tolower('$val'))"
            ")";
        makeOneProductQueryFromTwo();
      }
      productsPaginationKey.refresh();
    });
  }

  void onClearCustomerSearchBar() {
    if (customerSearchTextController.text != "") {
      customerSearchTextController.clear();
      searchCustomers("");
    }
  }

  void makeOneCustomerQueryFromTwo() {
    String finalQuery = "";
    if (newFilterQuery.isNotEmpty) {
      finalQuery = newFilterQuery;
    }
    if (customerSearchBarQuery.isNotEmpty) {
      if (finalQuery.isNotEmpty) {
        finalQuery += " and ";
      }
      finalQuery += customerSearchBarQuery;
    }
    customerSearchQuery = finalQuery;
  }

  void searchCustomers(String val) {
    _deBouncer.run(() {
      if (val.isEmpty) {
        customerSearchBarQuery = "";
        customerSearchQuery = newFilterQuery;
      } else {
        customerSearchBarQuery = "( "
            "contains(tolower(customerName) , tolower('$val')) or "
            "contains(tolower(companyName) , tolower('$val')) or "
            "contains(tolower(phoneNo) , tolower('$val')) or "
            "contains(tolower(address1) , tolower('$val'))"
            ")";
        makeOneCustomerQueryFromTwo();
      }
      customersPaginationKey.refresh();
    });
  }

  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);

  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> allCustomers = [];

  //Options
  RxBool isAverageCost = true.obs;
  RxBool isPurchaseCost = false.obs;

  //Date
  late TextEditingController dateController;

  //Date Range
  late TextEditingController fromDatePickerController;
  late TextEditingController toDatePickerController;

  //Filters
  late TextEditingController productFilterController;
  late TextEditingController customerFilterController;

  RxList<ReportModel> reportData = <ReportModel>[].obs;

  String? customerFilter;
  String? productFilter;

  void onCustomerFilterChange(String? selected) {
    customerFilter = selected;
    customerFilterController.text = selected!;

    getReport();
  }

  void onProductFilterChange(String? selected) {
    productFilter = selected;
    productFilterController.text = selected!;

    getReport();
  }

  String? date;

  onDateChange(String? selected) {
    if (selected == null) return 'Invalid option';
    date = selected;
    dateController.text = selected;
    fromDatePickerController.clear();
    toDatePickerController.clear();
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;
    int index = AppStrings.DATES.indexOf(selected);
    switch (index) {
      case 0: // 'Today'
        startDate = now;
        endDate = now;
        break;
      case 1: // 'Yesterday'
        startDate = now.subtract(const Duration(days: 1));
        endDate = startDate;
        break;
      case 2: // 'This Week'
        startDate = DateTime(now.year, now.month, now.day - now.weekday + 1);
        endDate = DateTime(now.year, now.month, now.day + (7 - now.weekday));
        break;
      case 3: // 'This Month'
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 4: // 'This Quarter'
        startDate = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
        endDate = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 4, 1)
            .subtract(const Duration(days: 1));
        break;
      case 5: // 'This Year'
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      case 6: // 'Last Three Days'
        startDate = now.subtract(const Duration(days: 3));
        endDate = now;
        break;
      case 7: // 'Last Week'
        startDate = now.subtract(Duration(days: now.weekday + 6));
        endDate = now.subtract(Duration(days: now.weekday));
        break;
      case 8: // 'Last Month'
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0);
        break;
      case 9: // 'Last Year'
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31);
        break;
      case 10: // 'Last 100 Days'
        startDate = now.subtract(const Duration(days: 100));
        endDate = now;
        break;
      case 11: // 'Last 365 Days'
        startDate = now.subtract(const Duration(days: 365));
        endDate = now;
        break;
      default:
        return 'Invalid option';
    }

    fromDatePickerController.text = DateFormat('yyyy-MM-dd').format(startDate);
    toDatePickerController.text = DateFormat('yyyy-MM-dd').format(endDate);

    getReport();
  }

  applyDateRange() {
    getReport();
  }

  onAverageCostClick() {
    isAverageCost.value = !isAverageCost.value;
    isPurchaseCost.value = !isPurchaseCost.value;

    getReport();
  }

  onPurchaseCostClick() {
    isAverageCost.value = !isAverageCost.value;
    isPurchaseCost.value = !isPurchaseCost.value;

    getReport();
  }

  Future<void> getReport() async {
    change(null, status: RxStatus.loading());

    String? customerID;
    String? productID;
    if (customerFilter != 'All') {
      customerID = allCustomers
              .firstWhere((map) => map['name'] == customerFilter,
                  orElse: () => {})
              .containsKey('id')
          ? allCustomers
              .firstWhere((map) => map['name'] == customerFilter,
                  orElse: () => {})['id']
              .toString()
          : null;
    }
    if (productFilter != 'All') {
      productID = allProducts
              .firstWhere((map) => map['name'] == productFilter,
                  orElse: () => {})
              .containsKey('id')
          ? allProducts
              .firstWhere((map) => map['name'] == productFilter,
                  orElse: () => {})['id']
              .toString()
          : null;
    }

    try {
      reportData = await BaseClient.safeApiCall(
        ApiConstants.ORDER_ITEM_DETAIL,
        RequestType.post,
        headers: await BaseClient.generateHeaders(),
        data: {
          'fromDate': fromDatePickerController.text,
          'toDate': toDatePickerController.text,
          'cogsByCost': isPurchaseCost.value,
          'customerFilterList': customerID == null ? null : [customerID],
          'productFilterList': productID == null ? null : [productID],
        },
        onSuccess: (json) {
          RxList<ReportModel>? data = <ReportModel>[].obs;
          if (json.data != null) {
            data = <ReportModel>[].obs;
            json.data.forEach((v) {
              data?.add(ReportModel.fromSalesByIndividualItem(v));
            });
          }
          return data;
        },
        onError: (e) {},
      );

      change(null, status: RxStatus.success());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong, Please try again later',
        margin: const EdgeInsets.only(bottom: 25),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getPDF() async {
    isLoading.value = true;

    final headers = await BaseClient.generateHeaders();
    Dio dioWithHeaders = Dio(BaseOptions(
        receiveTimeout: 999999, sendTimeout: 999999, headers: headers));

    try {
      var dir = await getApplicationDocumentsDirectory();
      String path = "${dir.path}/SalesByIndividualItemReport.pdf";

      String? customerID;
      String? productID;
      if (customerFilter != 'All') {
        customerID = allCustomers
                .firstWhere((map) => map['name'] == customerFilter,
                    orElse: () => {})
                .containsKey('id')
            ? allCustomers
                .firstWhere((map) => map['name'] == customerFilter,
                    orElse: () => {})['id']
                .toString()
            : null;
      }
      if (productFilter != 'All') {
        productID = allProducts
                .firstWhere((map) => map['name'] == productFilter,
                    orElse: () => {})
                .containsKey('id')
            ? allProducts
                .firstWhere((map) => map['name'] == productFilter,
                    orElse: () => {})['id']
                .toString()
            : null;
      }

      final data = {
        'fromDate': fromDatePickerController.text,
        'toDate': toDatePickerController.text,
        'cogsByCost': isPurchaseCost.value,
        'customerFilterList': customerID == null ? null : [customerID],
        'productFilterList': productID == null ? null : [productID],
      };
      String apiString = "${ApiConstants.ORDER_ITEM_DETAIL}?export=pdf";

      await dioWithHeaders.download(
        apiString,
        (Headers headers) {
          headers.map.values;
          return path;
        },
        data: data,
        options: Options(method: 'POST'),
      );
      if (path.isNotEmpty) {
        Get.to(() => PDFScreen(path: path));
      }
    } catch (e) {
      //print("Error downloading PDF: $e");
      Get.snackbar(
        'Error',
        'Something went wrong, Please try again later',
        margin: const EdgeInsets.only(bottom: 25),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  late RxBool isLoading = false.obs;

  @override
  void onInit() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    dateController = TextEditingController();
    date = AppStrings.DATES[0];

    customerFilterController = TextEditingController();
    customerFilterController.text = 'All';
    productFilterController = TextEditingController();
    productFilterController.text = 'All';

    fromDatePickerController = TextEditingController();
    toDatePickerController = TextEditingController();
    fromDatePickerController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    toDatePickerController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    customerFilterController = TextEditingController();
    customerFilterController.text = "All";
    productFilterController = TextEditingController();
    productFilterController.text = "All";
    customerSearchTextController = TextEditingController();
    productSearchTextController = TextEditingController();
    newFilterQuery = "isActive eq true";
    customerSearchBarQuery = "";
    productSearchBarQuery = "";
    productSearchQuery = "";
    customerSearchQuery = "";
    customerSortQuery = "customerName asc";
    productSortQuery = "productName asc";
    customersPaginationKey = PagingController(firstPageKey: 0);

    customersPaginationKey.addPageRequestListener((pageKey) {
      List<CustomerModel> newItems = [
        CustomerModel(companyName: "All", customerName: "All")
      ];
      final isLastPage = newItems.length < ApiConstants.ITEM_COUNT;
      if (isLastPage) {
        customersPaginationKey.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        customersPaginationKey.appendPage(newItems, nextPageKey);
      }
      getCustomerList(pageKey, customerSearchQuery, customerSortQuery);
    });

    productsPaginationKey = PagingController(firstPageKey: 0);
    productsPaginationKey.addPageRequestListener((pageKey) {
      List<ProductModel> newItems = [ProductModel(productName: "All")];
      final isLastPage = newItems.length < ApiConstants.ITEM_COUNT;
      if (isLastPage) {
        productsPaginationKey.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        productsPaginationKey.appendPage(newItems, nextPageKey);
      }
      getProductList(pageKey, productSearchQuery, productSortQuery);
    });

    getReport();
    super.onInit();
  }

  @override
  void dispose() {
    toDatePickerController.dispose();
    fromDatePickerController.dispose();
    dateController.dispose();
    productFilterController.dispose();
    customerFilterController.dispose();
    super.dispose();
  }
}
