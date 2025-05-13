import '../../../exports/index.dart';

class ItemReportController extends GetxController {
  ProductModel argProduct = Get.arguments['product'];
  String pageType = Get.arguments['pageType'];

  late List<ItemReportModel> itemReports = [];

  late RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading(true);
    var data = await getItemDetailReport(argProduct.productId);
    if (data != null) {
      itemReports = ItemReportModel.itemListFromJson(data, pageType);
    }
    isLoading(false);
  }

  Future getItemDetailReport(num? productId) async {
    String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final headers = await BaseClient.generateHeaders();
    String apiString = '';
    int orderType = 0;

    if (pageType == 'sale') {
      apiString = '${ApiConstants.POST_ITEM_SALE_REPORT}$productId';
      orderType = 0;
    } else if (pageType == 'purchase') {
      apiString = '${ApiConstants.POST_ITEM_PURCHASE_REPORT}$productId';
      orderType = 5;
    }
    return await BaseClient.safeApiCall(
      apiString,
      RequestType.post,
      headers: headers,
      data: {
        "activeType": 0,
        "fromDate": "2000-01-01",
        "toDate": toDate,
        "orderType": orderType,
        "pageNumber": 1,
        "pageSize": 10000,
      },
      onSuccess: (response) async {
        if (pageType == 'sale') {
          return response.data;
        } else if (pageType == 'purchase') {
          return response.data["data"];
        }
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
}
