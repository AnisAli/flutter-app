import '../../../exports/index.dart';

class VendorController extends GetxController {
  // to debounce search effect //
  final _deBouncer = Debouncer(milliseconds: 400);
  late final GlobalKey<ScaffoldState> scaffoldKey;
  late String searchQuery;
  late String sortQuery;
  late String newFilterQuery;
  late String searchBarQuery;

  late TextEditingController searchTextController;
  late final PagingController<int, VendorModel> vendorsPaginationKey;

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
    super.onInit();
    scaffoldKey = GlobalKey<ScaffoldState>();
    searchTextController = TextEditingController();
    activeFilterController = TextEditingController();
    activeFilter = activeFilters[1];
    taxFilterController = TextEditingController();
    taxFilter = taxTypeFilters[0];
    searchQuery = '';
    searchBarQuery = '';
    sortQuery = "vendorName asc";
    newFilterQuery = "isActive eq true";
    makeOneQueryFromTwo();
    vendorsPaginationKey = PagingController(firstPageKey: 0);
    vendorsPaginationKey.addPageRequestListener((pageKey) {
      getVendorList(pageKey, searchQuery, sortQuery);
    });
  }

  void onPressVendorCard(VendorModel vendor) =>
      Get.toNamed(AppRoutes.VENDOR_DETAIL, arguments: {
        'viaVendors': true,
        'vendor': vendor,
      });

  //Filter Functions //
  void onActiveFilterChange(String? selected) {
    activeFilter = selected;
    activeFilterController.text = selected!;
  }

  void onTaxFilterChange(String? selected) {
    taxFilter = selected;
    taxFilterController.text = selected!;
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
    vendorsPaginationKey.refresh();
    update();
    Get.back();
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
    vendorsPaginationKey.refresh();
    Get.back();
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

  void applySortFilters() {
    String newSortQuery = applySortQuery();
    if (newSortQuery == sortQuery) {
      // Do nothing if the new sort query is the same as the current one
      Get.back();
      return;
    }

    sortQuery = newSortQuery;
    vendorsPaginationKey.refresh();
    Get.back();
  }

  String applySortQuery() {
    String newSortQuery = "";

    if (isSortName.value) {
      newSortQuery = 'vendorName ${isSortAscending.value ? "asc" : "desc"}';
    } else if (isSortOpenBalance.value) {
      newSortQuery = 'openBalance ${isSortAscending.value ? "asc" : "desc"}';
    }
    return newSortQuery;
  }

  ////---------------///

  void searchCustomers(String val) {
    _deBouncer.run(() {
      if (val.isEmpty) {
        searchBarQuery = "";
        searchQuery = newFilterQuery;
      } else {
        searchBarQuery = "( contains(tolower(vendorName) , tolower('$val')) or "
            "contains(tolower(companyName) , tolower('$val')) or "
            "contains(tolower(phoneNo) , tolower('$val')) or "
            "contains(tolower(address1) , tolower('$val')) )";
        makeOneQueryFromTwo();
      }
      vendorsPaginationKey.refresh();
    });
  }

  void onClearSearchBar() {
    if (searchTextController.text != "") {
      searchTextController.clear();
      searchCustomers("");
    }
  }

  ////Vendor List Fetching///
  Future<void> getVendorList(int pageKey, String filter, String sort) async {
    try {
      List<VendorModel> newItems = (await BaseClient.safeApiCall(
        ApiConstants.GET_VENDOR_LIST,
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
          List<VendorModel>? vendors;
          if (json.data['value'] != null) {
            vendors = [];
            json.data['value'].forEach((v) {
              vendors?.add(VendorModel.fromJson(v));
            });
          }
          return vendors;
        },
        onError: (e) {},
      ));
      final isLastPage = newItems.length < ApiConstants.ITEM_COUNT;
      if (isLastPage) {
        vendorsPaginationKey.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        vendorsPaginationKey.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      vendorsPaginationKey.error = error;
    }
  }

  @override
  void dispose() {
    searchTextController.dispose();
    vendorsPaginationKey.dispose();
    activeFilterController.dispose();
    taxFilterController.dispose();

    super.dispose();
  }
}
