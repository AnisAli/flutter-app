import 'package:zefyrka/zefyrka.dart';

import '../../../exports/index.dart';

class VendorDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  //get storage (shared preferences)
  final vendorDetailContainer = GetStorage(AppStrings.VENDOR_DETAIL_CONTAINER);

  // to debounce search effect //
  final _deBouncer = Debouncer(milliseconds: 400);

  late final bool viaVendors;
  late final arguments = Get.arguments;
  late Rx<VendorModel> argsVendor;

  RxBool isLoading = false.obs;
  int? openBills = 0;

  late List<String> paymentTypeFilters;
  String? paymentTypeFilter;

  //controllers//
  late TextEditingController searchTextController;

  String toDateText = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fromDateText = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 365)));

  String sortQuery = "date desc";
  String searchQuery = "";

  RxBool isSortDate = true.obs;
  RxBool isSortModifiedDate = false.obs;
  RxBool isSortTransactionType = false.obs;
  RxBool isSortTransactionNum = false.obs;
  RxBool isSortAmount = false.obs;
  RxBool isSortAmountDue = false.obs;
  RxBool isSortAscending = false.obs;

  //Filter //
  late TextEditingController startDatePickerController;
  late TextEditingController endDatePickerController;
  late TextEditingController minAmountController;
  late TextEditingController maxAmountController;
  late TextEditingController paymentTypeFilterController;

  //----//
  // FOR APPLY PAYMENT //
  late RxString applyPaymentType;
  late TextEditingController applyPaymentTypeController;
  late TextEditingController cashAmountController;
  late TextEditingController chequeNoController;
  late TextEditingController chequeDatePickerController;
  late ZefyrController notesController;

  //tabs //
  late int tabIndex;
  late Map<String, List<TransactionSummaryModel>?> tabLists;
  late List<Tab> myTabs = [];
  late TabController tabController;

  late final PagingController<int, TransactionSummaryModel>
      transactionsPaginationKey;

  @override
  void onInit() async {
    //retrieveFilterValues();
    viaVendors = arguments['viaCustomers'] ?? true;
    if (viaVendors) {
      argsVendor = Rx(arguments['vendor']);
      tabIndex = 5; // by default Bill
      tabLists = {
        AppStrings.ORDER: [],
        AppStrings.BILL: [],
        AppStrings.CREDIT: [],
        AppStrings.PAYMENT: [],
      };
      tabLists.forEach((key, value) {
        myTabs.add(Tab(
          text: key,
        ));
      });
      tabController =
          TabController(length: myTabs.length, vsync: this, initialIndex: 1);
    }

    paymentTypeFilters = AppStrings.PAYMENT_METHODS;
    applyPaymentType = paymentTypeFilters[0].obs;

    scaffoldKey = GlobalKey<ScaffoldState>();

    startDatePickerController = TextEditingController(text: fromDateText);
    endDatePickerController = TextEditingController(text: toDateText);
    minAmountController = TextEditingController();
    maxAmountController = TextEditingController();
    chequeDatePickerController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    searchTextController = TextEditingController();
    paymentTypeFilterController = TextEditingController();
    applyPaymentTypeController = TextEditingController();
    cashAmountController = TextEditingController();
    chequeNoController = TextEditingController();
    notesController = ZefyrController();

    transactionsPaginationKey = PagingController(firstPageKey: 1);
    transactionsPaginationKey.addPageRequestListener((pageKey) {
      getTransactionSummaryList(pageKey);
    });

    if (viaVendors) {
      isLoading(true);
      await getOpenBills();
      isLoading(false);
    }

    super.onInit();
  }

  void storeFilterSetting() {
    Map<String, dynamic> filterValues = {
      'fromDate': fromDateText,
      'toDate': toDateText,
      'sortField': isSortDate.value
          ? 'date'
          : isSortModifiedDate.value
              ? 'modifiedDate'
              : isSortTransactionNum.value
                  ? 'transactionNumber'
                  : isSortTransactionType.value
                      ? 'transactionType'
                      : isSortAmount.value
                          ? 'amount'
                          : isSortAmountDue.value
                              ? 'balance'
                              : '',
      'isAscending': isSortAscending.value,
    };
    vendorDetailContainer.write('filterValues', filterValues);
  }

  void retrieveFilterValues() {
    if (vendorDetailContainer.hasData('filterValues')) {
      Map<String, dynamic> filterValues =
          vendorDetailContainer.read('filterValues');
      //taking sorting values //
      String sortField = filterValues['sortField'] ?? '';
      isSortAscending.value = filterValues['isAscending'] ?? false;
      if (sortField.isNotEmpty) {
        onChangeSort(sortField);
        sortQuery = applySortQuery();
      }

      //taking filter values //
      toDateText = filterValues['toDate'] ??
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      fromDateText = filterValues['fromDate'] ??
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(const Duration(days: 365)));
    }
  }

  Future<void> getTransactionSummaryList(int pageKey) async {
    try {
      List<TransactionSummaryModel> newItems = await BaseClient.safeApiCall(
        ApiConstants.POST_CUSTOMER_TRANSACTION_SUMMARY,
        RequestType.post,
        headers: await BaseClient.generateHeaders(),
        data: {
          "pageNumber": pageKey,
          "pageSize": ApiConstants.ITEM_COUNT,
          "searchText": searchQuery,
          "activeType": 0,
          "orderType": tabIndex,
          "isDescending": sortQuery.contains('desc') ? true : false,
          "orderBys": [sortQuery],
          "fromDate": fromDateText,
          if (viaVendors) "vendorFilterList": [argsVendor.value.vendorId],
          "toDate": toDateText
        },
        onSuccess: (json) {
          List<TransactionSummaryModel> transactionsList = [];
          if (json.data["data"] != null) {
            json.data["data"].forEach((v) {
              transactionsList.add(TransactionSummaryModel.fromJson(v));
            });
          }
          return transactionsList;
        },
        onError: (e) {},
      );
      final isLastPage = newItems.length < ApiConstants.ITEM_COUNT;
      if (isLastPage) {
        transactionsPaginationKey.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        transactionsPaginationKey.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      transactionsPaginationKey.error = error;
    }
  }

  Future onApplyPayment(int? billId, int vendorId) async {
    if (cashAmountController.text.isNotEmpty) {
      isLoading(true);
      await applyPayment(
          billId, cashAmountController.text.toDouble(), vendorId);
      if (viaVendors) {
        // await getOpenInvoices();
        // await getCustomerDetail();
      }
      transactionsPaginationKey.refresh();
      isLoading(false);
    }
  }

  Future<void> deletePayment(String paymentId) async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_APPLY_BILL}/$paymentId',
      RequestType.delete,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        Get.snackbar(
          'Success',
          'Payment deleted successfully!',
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

  Future applyPayment(int? billId, double amount, int vendorId) async {
    return await BaseClient.safeApiCall(
      ApiConstants.POST_APPLY_BILL,
      RequestType.post,
      headers: await BaseClient.generateHeaders(),
      data: {
        'vendorId': vendorId,
        'description': chequeNoController.text,
        'memo': notesController.plainTextEditingValue.text,
        'paidInvoices': [
          {'billId': billId, 'appliedAmount': amount}
        ],
        'paymentAmount': amount,
        'paymentDate': chequeDatePickerController.text,
        'paymentMethod': applyPaymentType.value,
      },
      onSuccess: (response) {
        Get.back();
        Get.snackbar(
          'Success',
          'Payment Applied Successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
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
        return;
      },
    );
  }

  Future<void> getVendorDetail() async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_PUT_ADD_VENDOR}${argsVendor.value.vendorId}',
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        argsVendor.value.openBalance = response.data["balance"] ?? '0.00';
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  Future<void> getOpenBills() async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_PUT_ADD_VENDOR}${argsVendor.value.vendorId}/summary',
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        openBills = response.data['data']['totalOpenBills'];
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  void onChangeApplyPaymentMethod(String? selected) {
    if (selected != null) {
      applyPaymentType.value = selected;
      applyPaymentTypeController.text = selected;
    }
  }

  Future<void> onTabChange(int index) async {
    if (index == 0) {
      tabIndex = 6;
    } else if (index == 1) {
      tabIndex = 5;
    } else {
      tabIndex = index + 5;
    }
    transactionsPaginationKey.refresh();
  }

  void onChangeSort(String fieldName) {
    isSortDate.value = false;
    isSortModifiedDate.value = false;
    isSortTransactionNum.value = false;
    isSortTransactionType.value = false;
    isSortAmount.value = false;
    isSortAmountDue.value = false;

    switch (fieldName) {
      case 'date':
        isSortDate.value = true;
        break;
      case 'modifiedDate':
        isSortModifiedDate.value = true;
        break;
      case 'transactionType':
        isSortTransactionType.value = true;
        break;
      case 'transactionNumber':
        isSortTransactionNum.value = true;
        break;
      case 'amount':
        isSortAmount.value = true;
        break;
      case 'balance':
        isSortAmountDue.value = true;
        break;
    }
  }

  String applySortQuery() {
    String newSortQuery = "";

    if (isSortDate.value) {
      newSortQuery = 'date ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortModifiedDate.value) {
      newSortQuery = 'modifiedDate ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortTransactionType.value) {
      newSortQuery =
          'transactionType ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortTransactionNum.value) {
      newSortQuery =
          'transactionNumber ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortAmount.value) {
      newSortQuery = 'amount ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortAmountDue.value) {
      newSortQuery = 'balance ${isSortAscending.value ? "asc" : "desc"}';
    }
    return newSortQuery;
  }

  void applySortFilters() async {
    String newSortQuery = applySortQuery();
    if (newSortQuery == sortQuery) {
      // Do nothing if the new sort query is the same as the current one
      Get.back();
      return;
    }
    sortQuery = newSortQuery;
    //storeFilterSetting();
    Get.back();
    isLoading(true);
    transactionsPaginationKey.refresh();
    isLoading(false);
  }

  void applySelectedFilters() {
    if (startDatePickerController.text.isNotEmpty &&
        endDatePickerController.text.isNotEmpty) {
      fromDateText = startDatePickerController.text;
      toDateText = endDatePickerController.text;
      //storeFilterSetting();
      transactionsPaginationKey.refresh();
    }
    Get.back();
  }

  void clearFilters() {
    if (startDatePickerController.text.isNotEmpty &&
        endDatePickerController.text.isNotEmpty) {
      startDatePickerController.clear();
      endDatePickerController.clear();
      toDateText = DateFormat('yyyy-MM-dd').format(DateTime.now());
      fromDateText = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 365)));
      //storeFilterSetting();
      transactionsPaginationKey.refresh();
    }
    Get.back();
  }

  void onPaymentTypeFilterChange(String? selected) {
    paymentTypeFilter = selected ?? '';
    paymentTypeFilterController.text = selected ?? '';
  }

  void searchByTransactionNumber(String val) async {
    _deBouncer.run(() async {
      searchQuery = val;
      isLoading(true);
      transactionsPaginationKey.refresh();
      isLoading(false);
    });
  }

  void onClearSearchBar() {
    if (searchTextController.text != "") {
      searchTextController.clear();
      searchByTransactionNumber("");
    }
  }

  CustomerModel getCustomerModelFromVendor(VendorModel vendorModel) {
    return CustomerModel(
      customerId: vendorModel.vendorId,
      customerName: vendorModel.vendorName,
      companyName: vendorModel.companyName,
      isTaxable: vendorModel.isTaxable,
      isActive: vendorModel.isActive,
      email: vendorModel.email,
      phoneNo: vendorModel.phoneNo,
      address1: vendorModel.address1,
      state: vendorModel.state,
      city: vendorModel.city,
      postalCode: vendorModel.postalCode,
      openBalance: vendorModel.openBalance,
      isQBCustomer: vendorModel.isQbVendor,
    );
  }

  void onSelectedPopupMenuItem(int menuItem) {
    CustomerModel customerModel = getCustomerModelFromVendor(argsVendor.value);

    if (menuItem == 1) {
      Get.toNamed(
        AppRoutes.QUICK_INVOICE,
        arguments: {
          'customer': customerModel,
          "pageType": 'create',
          'viaCustomers': true,
          'vendor': argsVendor.value
        },
      );
    } else if (menuItem == 2) {
      Get.toNamed(
        AppRoutes.QUICK_INVOICE,
        arguments: {
          'customer': customerModel,
          "pageType": 'credit',
          'viaCustomers': true,
          'vendor': argsVendor.value
        },
      );
    }
  }

  void openLauncher(String type) async {
    if (type == 'tel') {
      final Uri phoneNumber = Uri.parse("tel:+1-${argsVendor.value.phoneNo}");
      if (await canLaunchUrl(phoneNumber)) {
        await launchUrl(phoneNumber);
      }
    } else if (type == 'sms') {
      final Uri sms = Uri.parse("sms:+1-${argsVendor.value.phoneNo}");
      if (await canLaunchUrl(sms)) {
        await launchUrl(sms);
      }
    }
  }

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

  @override
  void dispose() {
    searchTextController.dispose();
    paymentTypeFilterController.dispose();
    applyPaymentTypeController.dispose();
    cashAmountController.dispose();
    chequeNoController.dispose();
    chequeDatePickerController.dispose();
    notesController.dispose();
    startDatePickerController.dispose();
    endDatePickerController.dispose();
    minAmountController.dispose();
    maxAmountController.dispose();
    tabController.dispose();
    transactionsPaginationKey.dispose();
    super.dispose();
  }
}
