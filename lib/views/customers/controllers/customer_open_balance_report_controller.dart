import '../../../exports/index.dart';

class CustomerOpenBalanceReportController extends GetxController {
  CustomerModel argCustomer = Get.arguments['customer'];
  late List<CustomerOpenBalanceReportModel> customerOpenBalanceReports = [];

  late RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading(true);
    var data = await getCustomerOpenBalanceReport(argCustomer.customerId);
    if (data != null) {
      customerOpenBalanceReports =
          CustomerOpenBalanceReportModel.listFromJson(data);
    }
    isLoading(false);
  }

  Future getCustomerOpenBalanceReport(int? customerId) async {
    String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final headers = await BaseClient.generateHeaders();
    String apiString = ApiConstants.POST_CUSTOMER_OPEN_BALANCE_REPORT;
    return await BaseClient.safeApiCall(
      apiString,
      RequestType.post,
      headers: headers,
      data: {
        "activeType": 0,
        "customerFilterList": [customerId],
        "fromDate": "2000-01-01",
        "toDate": toDate,
        "orderType": 0,
        "pageNumber": 1,
        "openBalance": true,
        "pageSize": 10000,
        "searchText": "",
      },
      onSuccess: (response) async {
        return response.data;
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

  double getTotalDueBalance() {
    return customerOpenBalanceReports.fold(0.0,
        (double total, element) => total + (element.invoiceBalance ?? 0.0));
  }
}
