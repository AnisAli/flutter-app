import 'package:zefyrka/zefyrka.dart';
import '../../../exports/index.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // to debounce search effect //
  final _deBouncer = Debouncer(milliseconds: 400);

  late final GlobalKey<ScaffoldState> scaffoldKey;

  //get storage (shared preferences)
  final customerDetailContainer =
      GetStorage(AppStrings.CUSTOMER_DETAIL_CONTAINER);

  late final arguments = Get.arguments;
  late final bool viaCustomers;
  late Rx<CustomerModel> argsCustomer;
  late TextEditingController searchTextController;
  late TabController tabController;
  late TextEditingController paymentTypeFilterController;
  late final PagingController<int, TransactionSummaryModel>
      transactionsPaginationKey;

  late int tabIndex;
  String toDateText = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fromDateText = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 366)));

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

  //----//

  RxBool isLoading = false.obs;
  double openInvoices = 0.0;
  late List<Tab> myTabs = [];
  late Map<String, List<TransactionSummaryModel>?> tabLists;

  late List<String> paymentTypeFilters;
  String? paymentTypeFilter;
  // FOR APPLY PAYMENT //
  late RxString applyPaymentType;
  late TextEditingController applyPaymentTypeController;
  late TextEditingController cashAmountController;
  late TextEditingController chequeNoController;
  late TextEditingController chequeDatePickerController;
  late ZefyrController notesController;

  CustomerController customerController = Get.put(CustomerController());

  late RxBool isFilterApplied = false.obs;

  @override
  void onInit() async {
    retrieveFilterValues();
    isFilterApplied.value = checkFiltersApplied();
    viaCustomers = arguments['viaCustomers'];
    if (viaCustomers) {
      argsCustomer = Rx(arguments['customer']);
      tabIndex = 0;
      tabLists = {
        AppStrings.ALL: [],
        AppStrings.ORDER: [],
        AppStrings.INVOICE: [],
        AppStrings.CREDIT: [],
        AppStrings.PAYMENT: [],
      };
      tabLists.forEach((key, value) {
        myTabs.add(Tab(
          text: key,
        ));
      });
      tabController = TabController(length: myTabs.length, vsync: this);
    } else {
      tabIndex = arguments['orderType'];
    }
    paymentTypeFilters = AppStrings.PAYMENT_METHODS;
    applyPaymentType = paymentTypeFilters[0].obs;
    transactionsPaginationKey = PagingController(firstPageKey: 1);
    transactionsPaginationKey.addPageRequestListener((pageKey) {
      getTransactionSummaryList(pageKey);
    });

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

    //All await calls must be in the end of init //
    if (viaCustomers) {
      isLoading(true);
      await getOpenInvoices();
      isLoading(false);
    }
    super.onInit();
  }

  bool checkFiltersApplied() =>
      (toDateText.isNotEmpty && fromDateText.isNotEmpty) ? true : false;

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
    customerDetailContainer.write('filterValues', filterValues);
  }

  void retrieveFilterValues() {
    if (customerDetailContainer.hasData('filterValues')) {
      Map<String, dynamic> filterValues =
          customerDetailContainer.read('filterValues');
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

  void onCustomerSelection(CustomerModel customer) {
    if(tabIndex == 2){
      Get.toNamed(
        AppRoutes.QUICK_INVOICE,
        arguments: {
          'customer': customer,
          "pageType": 'credit',
          'viaCustomers': false,
        },
      );
    }else{
      Get.toNamed(
        AppRoutes.QUICK_INVOICE,
        arguments: {
          'customer': customer,
          "pageType": 'create',
          'viaCustomers': false,
        },
      );
    }
  }

  void onChangeApplyPaymentMethod(String? selected) {
    if (selected != null) {
      applyPaymentType.value = selected;
      applyPaymentTypeController.text = selected;
    }
  }

  Future onApplyPayment(int? orderId, int customerId) async {
    if (cashAmountController.text.isNotEmpty) {
      isLoading(true);
      await applyPayment(
          orderId, cashAmountController.text.toDouble(), customerId);
      if (viaCustomers) {
        await getOpenInvoices();
        await getCustomerDetail();
      }
      transactionsPaginationKey.refresh();
      isLoading(false);
    }
  }

  void onSelectedPopupMenuItem(int menuItem) {
    if (menuItem == 1) {
      Get.toNamed(
        AppRoutes.QUICK_INVOICE,
        arguments: {
          'customer': argsCustomer.value,
          "pageType": 'create',
          'viaCustomers': true,
        },
      );
    } else if (menuItem == 2) {
      Get.toNamed(
        AppRoutes.QUICK_INVOICE,
        arguments: {
          'customer': argsCustomer.value,
          "pageType": 'credit',
          'viaCustomers': true,
        },
      );
    }
  }

  void openLauncher(String type) async {
    if (type == 'tel') {
      final Uri phoneNumber = Uri.parse("tel:+1-${argsCustomer.value.phoneNo}");
      if (await canLaunchUrl(phoneNumber)) {
        await launchUrl(phoneNumber);
      }
    } else if (type == 'sms') {
      final Uri sms = Uri.parse("sms:+1-${argsCustomer.value.phoneNo}");
      if (await canLaunchUrl(sms)) {
        await launchUrl(sms);
      }
    }
  }

  void onPressEditButton() =>
      Get.toNamed(AppRoutes.ADD_CUSTOMER, arguments: argsCustomer.value);

  Future<void> onTabChange(int index) async {
    if (index == 0) {
      tabIndex = index;
    } else if (index == 1) {
      tabIndex = 4;
    } else {
      tabIndex = index - 1;
    }
    transactionsPaginationKey.refresh();
  }

  bool isTabListEmpty(int orderType) {
    if (tabLists.values.elementAt(orderType)?.isEmpty ?? true) {
      return true;
    } else {
      return false;
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
          "openBalance": true,
          "isDescending": sortQuery.contains('desc') ? true : false,
          "orderBys": [sortQuery],
          "fromDate": fromDateText,
          if (viaCustomers)
            "customerFilterList": [argsCustomer.value.customerId],
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

  Future<void> getOpenInvoices() async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_CUSTOMER_SUMMARY}${argsCustomer.value.customerId}',
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        openInvoices = response.data["totalOpenInvoices"];
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  Future<void> getCustomerDetail() async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_SINGLE_CUSTOMER}${argsCustomer.value.customerId}',
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        argsCustomer.value.openBalance = response.data["openBalance"] ?? '0.00';
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  Future applyPayment(int? orderId, double amount, int customerId) async {
    return await BaseClient.safeApiCall(
      ApiConstants.POST_APPLY_PAYMENT,
      RequestType.post,
      headers: await BaseClient.generateHeaders(),
      data: {
        'customerId': customerId,
        'description': chequeNoController.text,
        'memo': notesController.plainTextEditingValue.text,
        'paidInvoices': [
          {'orderId': orderId, 'appliedAmount': amount}
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
          e.response?.data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      },
    );
  }

  Future<void> convertToInvoice(String salesOrderId) async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.POST_CONVERT_TO_INVOICE}$salesOrderId/convertToInvoice',
      RequestType.post,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        Get.snackbar(
          'Success',
          'Invoice Created Successfully!',
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

  Future<void> deletePayment(String paymentId) async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_PAYMENT_INVOICE}$paymentId',
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

  void onClearSearchBar() {
    if (searchTextController.text != "") {
      searchTextController.clear();
      searchByTransactionNumber("");
    }
  }

  void searchByTransactionNumber(String val) async {
    _deBouncer.run(() async {
      searchQuery = val;
      isLoading(true);
      transactionsPaginationKey.refresh();
      isLoading(false);
    });
  }

  //Filters & Sorts //
  void applySelectedFilters() {
    if (startDatePickerController.text.isNotEmpty &&
        endDatePickerController.text.isNotEmpty) {
      fromDateText = startDatePickerController.text;
      toDateText = endDatePickerController.text;
      storeFilterSetting();
      transactionsPaginationKey.refresh();
      isFilterApplied(true);
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
      storeFilterSetting();
      transactionsPaginationKey.refresh();
      isFilterApplied(false);
    }
    Get.back();
  }

  void onPaymentTypeFilterChange(String? selected) {
    paymentTypeFilter = selected ?? '';
    paymentTypeFilterController.text = selected ?? '';
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
    storeFilterSetting();
    Get.back();
    isLoading(true);
    transactionsPaginationKey.refresh();
    isLoading(false);
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
