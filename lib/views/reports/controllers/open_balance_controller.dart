import 'package:dio/dio.dart';
import 'package:otrack/views/customers/components/pdf_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../../../exports/index.dart';

class OpenBalanceController extends GetxController {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  final _deBouncer = Debouncer(milliseconds: 400);
  late final PagingController<int, CustomerModel> customersPaginationKey;
  late String customerSearchBarQuery;
  late String customerSearchQuery;
  late String newFilterQuery;
  late String customerSortQuery;
  late TextEditingController customerSearchTextController;
  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  List<Map<String, dynamic>> allCustomers = [];
  late TextEditingController customerFilterController;
  String? customerFilter;
  RxList<CustomerModel> selectedCustomers = <CustomerModel>[].obs;

  void updateCustomerFilterController() {
    final selectedNames = selectedCustomers
        .map((customer) => customer.customerName ?? customer.companyName!)
        .join(', ');
    customerFilterController.text = selectedNames;
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

  void onCustomerSelected(CustomerModel customer) {
    selectedCustomer.value = customer;
  }

  void onCustomerFilterChange(String? selected) {
    customerFilter = selected;
    customerFilterController.text = selected!;

    //getReport();
  }

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

  late RxBool isLoading = false.obs;

  Future<void> getOpenBalancePDF() async {
    isLoading.value = true;

    final headers = await BaseClient.generateHeaders();
    Dio dioWithHeaders = Dio(BaseOptions(
        receiveTimeout: 999999, sendTimeout: 999999, headers: headers));

    try {
      var dir = await getApplicationDocumentsDirectory();
      String path = "${dir.path}/TransactionSummary.pdf";

      List selectedCustomersIDs = [];
      selectedCustomers.forEach((customers) {
        selectedCustomersIDs.add(customers.customerId);
      });

      DateTime now = DateTime.now();
      String toDate = '${now.year}-${now.month}-${now.day}';

      final data = {
        "orderType": 0,
        "fromDate": "2000-01-01",
        "toDate": toDate,
        "customerFilterList": selectedCustomersIDs,
        "exportFormat": 1,
        "openBalance": true
      };
      String apiString =
          "${ApiConstants.POST_CUSTOMER_OPEN_BALANCE_REPORT}?export=pdf";

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


  @override
  void onInit() {
    scaffoldKey = GlobalKey<ScaffoldState>();

    customerFilterController = TextEditingController();
    customerFilterController.text = "";
    customerSearchTextController = TextEditingController();
    newFilterQuery = "isActive eq true";
    customerSearchBarQuery = "";
    customerSearchQuery = "";
    customerSortQuery = "customerName asc";
    customersPaginationKey = PagingController(firstPageKey: 0);
    customersPaginationKey.addPageRequestListener((pageKey) async {
      await getCustomerList(pageKey, customerSearchQuery, customerSortQuery);
    });

    super.onInit();
  }

  @override
  void dispose() {
    customersPaginationKey.dispose();
    customerSearchTextController.dispose();
    customerFilterController.dispose();

    super.dispose();
  }
}
