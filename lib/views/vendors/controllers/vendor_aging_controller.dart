import '../../../exports/index.dart';

class VendorAgingController extends GetxController {
  VendorModel argVendor = Get.arguments['vendor'];

  late List<VendorAgingModel> vendorAgingTransactions = [];
  late RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading(true);
    var data = await getVendorAgingDetail(argVendor.vendorId.toString());
    if (data != null) {
      vendorAgingTransactions = VendorAgingModel.listFromJson(data);
    }
    isLoading(false);
  }

  Future getVendorAgingDetail(String vendorId) async {
    final headers = await BaseClient.generateHeaders();
    String apiString = ApiConstants.POST_VENDOR_AGING + vendorId;
    return await BaseClient.safeApiCall(
      apiString,
      RequestType.post,
      headers: headers,
      data: {
        "activeType": null,
        "customerFilterList": null,
        "orderType": 0,
        "pageNumber": 1,
        "pageSize": 10000,
        "productFilterList": null,
        "qbCustomerType": null,
        "searchText": null,
        "sortColumn": null,
        "sortDirection": null,
        "vendorFilterList": null
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
    return vendorAgingTransactions.fold(
        0.0, (double total, element) => total + (element.amountDue ?? 0.0));
  }
}
