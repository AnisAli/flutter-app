import '../../../exports/index.dart';

class PaymentReceivedController extends GetxController {
  final _deBouncer = Debouncer(milliseconds: 400);
  late final GlobalKey<ScaffoldState> scaffoldKey;

  late GlobalKey<FormState> formKey;

  late TextEditingController paymentAmountController;

  String? paymentAmountValidator(String? value) {
    if (value!.isEmpty) {
      return 'Invalid Amount';
    }
    return null;
  }

  late TextEditingController paymentMethodController;

  String? paymentMethod;

  void onPaymentMethodChange(String? selected) {
    paymentMethod = selected;
    paymentMethodController.text = selected!;

    if (paymentMethod == 'Cheque' || paymentMethod == 'MoneyOrder') {
      isEnabled.value = true;
    } else {
      datePickerController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      isEnabled.value = false;
    }
  }

  late TextEditingController fromAccountController;
  List<String> fromAccounts = [
    'Checking Account',
    'Cash On Hand',
    'UnDeposited Funds',
  ];
  String? fromAccount;

  void onFromAccountChange(String? selected) {
    fromAccount = selected;
    fromAccountController.text = selected!;
  }

  void onCustomerFilterChange(String? selected) async {
    customerFilter = selected;
    customerFilterController.text = selected!;
    update(['text']);

    CustomLoading().showLoadingOverLay(asyncFunction: getCustomerUnpaidInvoice);
  }

  late final PagingController<int, CustomerModel> customersPaginationKey;
  late String customerSearchQuery;
  late String customerSearchBarQuery;
  late String newFilterQuery;
  late String customerSortQuery;
  late TextEditingController customerSearchTextController;
  late TextEditingController customerFilterController;
  String? customerFilter;
  List<Map<String, dynamic>> allCustomers = [];

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

  void onCustomerSelected(CustomerModel customer) {
    selectedCustomer.value = customer;
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

  RxDouble amountToApply = 0.0.obs;
  RxDouble creditToApply = 0.0.obs;
  RxBool isEnabled = false.obs;
  late TextEditingController datePickerController;

  late TextEditingController referenceNumberController;

  String? referenceNumberValidator(String? value) {
    if (value!.isEmpty) {
      return 'Invalid Amount';
    }
    return null;
  }

  late TextEditingController commentController;

  /*void onApplyCreditClick() {
    print(customers.map((e) => e.customerName).toList());
    print(customerFilters);
    print(customerFilter);

    if (formKey.currentState!.validate()) {
      */ /*CustomerModel customer = customers.firstWhere(
          (customer) => customer.companyName == customerFilterController.text);

      Get.toNamed(
        AppRoutes.PAYMENT_RECEIVED_2,
        arguments: {
          'customer': customer,
        },
      );*/ /*

      // Use firstWhere with a safe check for an existing element
      CustomerModel? customer = customers.firstWhereOrNull(
        (customer) => customer.companyName == customerFilter,
      );

      */ /*if (customer != null) {
        Get.toNamed(
          AppRoutes.PAYMENT_RECEIVED_2,
          arguments: {
            'customer': customer,
          },
        );
      } else {
        // Handle the case when no matching customer is found
        print("No customer found with the specified companyName.");
      }*/ /*
    }
  }*/

  //RxDouble balanceDue = 0.00.obs;
  //late List<Map<String, dynamic>> unpaidInvoices = [];
  List<TextEditingController> textControllerList = [];
  UnpaidInvoicesModel unpaidInvoices = UnpaidInvoicesModel();

  Future<void> getCustomerUnpaidInvoice() async {
    String? customerID;
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

    unpaidInvoices = await BaseClient.safeApiCall(
      ApiConstants.GET_UNPAID_INVOICE + customerID!,
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      data: {},
      onSuccess: (json) {
        paymentAmountController.clear();
        amountToApply.value = 0.0;
        creditToApply.value = 0.0;
        UnpaidInvoicesModel data = UnpaidInvoicesModel();
        if (json.data != null) {
          data = UnpaidInvoicesModel.fromJson(json.data);
          for (var invoice in data.unpaidInvoices!) {
            invoice['isCheck'] = false;
            invoice['creditAmount'] = 0.0;
            invoice['creditTextController'] = TextEditingController();
          }
        }
        return data;
      },
      onError: (e) {},
    );
    update(['openBalance']);
  }

  void isChecked(bool isChecked, Map<String, dynamic> rowData) {
    if (isChecked == true) {
      rowData['creditAmount'] = rowData['amountDue'].toStringAsFixed(2);
      rowData['creditTextController'].text =
          rowData['amountDue'].toStringAsFixed(2);
      // unpaidInvoices.unpaidInvoices![index]['creditAmount'] =
      //     double.parse(textControllerList[index].text);
    } else if (isChecked == false) {
      //textControllerList[index].clear();
      rowData['creditTextController'].clear();
      rowData['creditAmount'] = 0.0;
    }

    amountToApply.value = 0.0;
    for (var invoice in unpaidInvoices.unpaidInvoices!) {
      if (invoice['creditAmount'] != null) {
        amountToApply.value +=
            double.parse((invoice['creditAmount']).toString());
      }
    }
    paymentAmountController.text = (amountToApply.value).toString();

    update(['creditAmountTextField']);
  }

  @override
  void onInit() {
    scaffoldKey = GlobalKey<ScaffoldState>();

    formKey = GlobalKey<FormState>();

    paymentAmountController = TextEditingController(text: '0.0');

    paymentMethodController = TextEditingController();
    paymentMethod = AppStrings.PAYMENT_METHODS[0];

    fromAccountController = TextEditingController();

    datePickerController = TextEditingController();
    datePickerController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    referenceNumberController = TextEditingController();

    commentController = TextEditingController();

    customerFilterController = TextEditingController();
    customerSearchTextController = TextEditingController();
    newFilterQuery = "isActive eq true";
    customerSearchBarQuery = "";
    customerSearchQuery = "";
    customerSortQuery = "customerName asc";
    customersPaginationKey = PagingController(firstPageKey: 0);

    customersPaginationKey.addPageRequestListener((pageKey) {
      getCustomerList(pageKey, customerSearchQuery, customerSortQuery);
    });

    super.onInit();
  }

  @override
  void dispose() {
    datePickerController.dispose();
    paymentMethodController.dispose();
    paymentAmountController.dispose();
    customerFilterController.dispose();
    fromAccountController.dispose();
    super.dispose();
  }
}
