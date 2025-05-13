import '../../../exports/index.dart';

class CustomerController extends GetxController {
  // to debounce search effect //
  final _deBouncer = Debouncer(milliseconds: 400);

  late final GlobalKey<ScaffoldState> scaffoldKey;
  late TextEditingController searchTextController;
  late final PagingController<int, CustomerModel> customersPaginationKey;
  late String searchQuery;
  late String searchBarQuery;
  late String newFilterQuery;
  late String sortQuery;

  //---Sorting Bools //

  RxBool isSortName = true.obs;
  RxBool isSortOpenBalance = false.obs;
  RxBool isSortAscending = true.obs;

  //---Filter Sheet ///
  late TextEditingController taxFilterController;
  late TextEditingController activeFilterController;

  List<String> activeFilters = ['All', 'Active', 'Inactive'];
  String? activeFilter;

  List<String> taxTypeFilters = ['All', 'Taxable', 'Non-Taxable'];
  String? taxFilter;

  //-----------//////

  @override
  void onInit() {
    newFilterQuery = "isActive eq true";
    searchQuery = "";
    searchBarQuery = "";
    sortQuery = "customerName asc";
    searchTextController = TextEditingController();
    scaffoldKey = GlobalKey<ScaffoldState>();
    taxFilterController = TextEditingController();
    taxFilter = taxTypeFilters[0];
    activeFilterController = TextEditingController();
    activeFilter = activeFilters[1];
    makeOneQueryFromTwo();
    customersPaginationKey = PagingController(firstPageKey: 0);
    customersPaginationKey.addPageRequestListener((pageKey) {
      getCustomerList(pageKey, searchQuery, sortQuery);
    });

    super.onInit();
  }

  //Search Bar Functions//

  void searchCustomers(String val) {
    _deBouncer.run(() {
      if (val.isEmpty) {
        searchBarQuery = "";
        searchQuery = newFilterQuery;
      } else {
        searchBarQuery =
            "( contains(tolower(customerName) , tolower('$val')) or "
            "contains(tolower(companyName) , tolower('$val')) or "
            "contains(tolower(phoneNo) , tolower('$val')) or "
            "contains(tolower(address1) , tolower('$val')) )";
        makeOneQueryFromTwo();
      }
      customersPaginationKey.refresh();
    });
  }

  void onClearSearchBar() {
    if (searchTextController.text != "") {
      searchTextController.clear();
      searchCustomers("");
    }
  }

  void makeOneQueryFromTwo() {
    String finalQuery = "";
    if (newFilterQuery.isNotEmpty) {
      finalQuery = newFilterQuery;
    }
    if (searchBarQuery.isNotEmpty) {
      if (finalQuery.isNotEmpty) {
        finalQuery += " and ";
      }
      finalQuery += searchBarQuery;
    }
    searchQuery = finalQuery;
  }

  //Sort Functions///

  void onChangeSort(String fieldName) {
    isSortName.value = false;
    isSortOpenBalance.value = false;

    switch (fieldName) {
      case 'name':
        isSortName.value = true;
        break;
      case 'openBalance':
        isSortOpenBalance.value = true;
        break;
    }
  }

  String applySortQuery() {
    String newSortQuery = "";

    if (isSortName.value) {
      newSortQuery = 'customerName ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortOpenBalance.value) {
      newSortQuery = 'openBalance ${isSortAscending.value ? "asc" : "desc"}';
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

    sortQuery = newSortQuery;
    customersPaginationKey.refresh();
    Get.back();
  }

  //Filters Functions///

  void onTaxFilterChange(String? selected) {
    taxFilter = selected;
    taxFilterController.text = selected!;
  }

  void onActiveFilterChange(String? selected) {
    activeFilter = selected;
    activeFilterController.text = selected!;
  }

  void applySelectedFilters() {
    newFilterQuery = "";
    List<String> filters = [];

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

    newFilterQuery = filters.join(" and ");
    if (newFilterQuery == searchQuery) {
      // Do nothing if the new filter query is the same as the current one
      Get.back();
      return;
    }

    makeOneQueryFromTwo();
    customersPaginationKey.refresh();
    Get.back();
  }

  void clearFilters() {
    if (newFilterQuery == "") {
      Get.back();
      return;
    }
    newFilterQuery = "";
    activeFilterController.clear();
    activeFilter = null;
    taxFilterController.clear();
    taxFilter = null;
    makeOneQueryFromTwo();
    customersPaginationKey.refresh();
    update();
    Get.back();
  }

  ////Customer List ///

  Future<void> getCustomerList(int pageKey, String filter, String sort) async {
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

  @override
  void dispose() {
    searchTextController.dispose();
    customersPaginationKey.dispose();
    taxFilterController.dispose();
    activeFilterController.dispose();
    super.dispose();
  }
}
