import 'package:otrack/views/customers/components/product_edit_card.dart';
import 'package:zefyrka/zefyrka.dart';
import '../../../exports/index.dart';
import '../../vendors/components/vendor_card.dart';
import 'customer_card.dart';

class PreviewSheetCard extends StatefulWidget {
  const PreviewSheetCard({Key? key}) : super(key: key);

  @override
  State<PreviewSheetCard> createState() => _PreviewSheetCardState();
}

class _PreviewSheetCardState extends State<PreviewSheetCard> {
  late VendorController vendorController = Get.find<VendorController>();
  late CustomerController customerController = Get.find<CustomerController>();
  QuickInvoiceController quickInvoiceController =
      Get.find<QuickInvoiceController>();
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      showBackButton: false,
      resizeToAvoidBottomInset: false,
      extendedAppBarSize: 56,
      customBottomNavigationBar: quickInvoiceController.isVendorThere
          ? _customVendorBottomBar(context)
          : _customBottomBar(context),
      extendedAppBar: quickInvoiceController.isVendorThere
          ? _extendedVendorAppBar(context)
          : _extendedAppBar(context),
      children: [
        const SpaceH12().sliverToBoxAdapter,
        _buildCustomerInfoContainer(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        _buildProductDataTable(context).sliverToBoxAdapter,
        const SpaceH20().sliverToBoxAdapter,
        _buildTotalContainer(context).sliverToBoxAdapter,
        const SpaceH20().sliverToBoxAdapter,
        if (quickInvoiceController.isVendorThere &&
            quickInvoiceController.pageType != 'credit') ...[
          _vendorBillNumber(context).sliverToBoxAdapter,
          const SpaceH20().sliverToBoxAdapter,
        ],
        _buildNotesWidget(context).sliverToBoxAdapter,
        const SpaceH16().sliverToBoxAdapter,
      ],
    ).scaffold();
  }

  Widget _vendorBillNumber(BuildContext context) {
    return CustomTextFormField(
      autofocus: false,
      controller: quickInvoiceController.billNumberController,
      hintText: AppStrings.BILL_N0,
      labelText: AppStrings.BILL_NUMBER,
      labelColor: context.iconColor1,
      prefixIconData: Icons.receipt,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
  }

  Widget _customBottomBar(BuildContext context) {
    bool isShowConvertToInvoice = false;
    bool isUpdateInvoice = false;
    bool isShowSubmitMemo = false;

    if (quickInvoiceController.pageType == 'edit') {
      if (quickInvoiceController.transactionType == 4) {
        isShowConvertToInvoice = true;
      }
      if (quickInvoiceController.transactionType == 1) {
        isUpdateInvoice = true;
      }
    }
    if (quickInvoiceController.pageType == 'credit' ||
        quickInvoiceController.pageType == 'editCredit') {
      isShowSubmitMemo = true;
      isUpdateInvoice = true;
    }
    return Obx(() => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isUpdateInvoice)
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: CustomRoundButton(
                  text: isShowConvertToInvoice
                      ? AppStrings.UPDATE_ORDER
                      : AppStrings.SAVE_AS_ORDER,
                  isLoadingButton: true,
                  isLoading: quickInvoiceController.isLoading.value,
                  contrast: true,
                  onPressed: () async =>
                      quickInvoiceController.invoiceCart.items.isNotEmpty
                          ? await quickInvoiceController.saveOrder('salesOrder')
                          : null,
                ),
              ),
            const SpaceW12(),
            isShowConvertToInvoice
                ? Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CustomRoundButton(
                      text: AppStrings.CONVERT_TO_INVOICE,
                      contrast: false,
                      isLoadingButton: true,
                      isLoading: quickInvoiceController.isLoading.value,
                      onPressed: () async =>
                          quickInvoiceController.invoiceCart.items.isNotEmpty
                              ? await quickInvoiceController.convertToInvoice(
                                  quickInvoiceController.editOrderId.toString())
                              : null,
                    ),
                  )
                : isShowSubmitMemo
                    ? Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: CustomRoundButton(
                          text: 'Submit Memo',
                          contrast: false,
                          isLoadingButton: true,
                          isLoading: quickInvoiceController.isLoading.value,
                          onPressed: () async => quickInvoiceController
                                  .invoiceCart.items.isNotEmpty
                              ? await quickInvoiceController
                                  .saveOrder('invoiceOrder')
                              : null,
                        ),
                      )
                    : Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: CustomRoundButton(
                          text: isUpdateInvoice
                              ? AppStrings.UPDATE_INVOICE
                              : AppStrings.SAVE_INVOICE,
                          isLoadingButton: true,
                          isLoading: quickInvoiceController.isLoading.value,
                          contrast: false,
                          onPressed: () async => quickInvoiceController
                                  .invoiceCart.items.isNotEmpty
                              ? await quickInvoiceController
                                  .saveOrder('invoiceOrder')
                              : null,
                        ),
                      )
          ],
        ));
  }

  Widget _customVendorBottomBar(BuildContext context) {
    bool isShowConvertToBill = false;
    bool isUpdateBill = false;
    bool isShowSubmitMemo = false;

    if (quickInvoiceController.pageType == 'edit') {
      if (quickInvoiceController.transactionType == 6) {
        isShowConvertToBill = true;
      }
      if (quickInvoiceController.transactionType == 5) {
        isUpdateBill = true;
      }
    }
    if (quickInvoiceController.pageType == 'credit' ||
        quickInvoiceController.pageType == 'editCredit') {
      isShowSubmitMemo = true;
      isUpdateBill = true;
    }

    return Obx(() => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isUpdateBill)
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: CustomRoundButton(
                  text: isShowConvertToBill
                      ? 'Update Order'
                      : 'Save Purchase Order',
                  isLoadingButton: true,
                  isLoading: quickInvoiceController.isLoading.value,
                  contrast: true,
                  onPressed: () async =>
                      quickInvoiceController.invoiceCart.items.isNotEmpty
                          ? await quickInvoiceController
                              .saveVendorOrder('purchaseOrder')
                          : null,
                ),
              ),
            const SpaceW12(),
            isShowConvertToBill
                ? Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CustomRoundButton(
                      text: 'Convert to Bill',
                      contrast: false,
                      isLoadingButton: true,
                      isLoading: quickInvoiceController.isLoading.value,
                      onPressed: () async =>
                          quickInvoiceController.invoiceCart.items.isNotEmpty
                              ? await quickInvoiceController.convertToBill(
                                  quickInvoiceController.editOrderId.toString())
                              : null,
                    ),
                  )
                : isShowSubmitMemo
                    ? Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: CustomRoundButton(
                          text: 'Submit Memo',
                          isLoadingButton: true,
                          isLoading: quickInvoiceController.isLoading.value,
                          contrast: false,
                          onPressed: () async => quickInvoiceController
                                  .invoiceCart.items.isNotEmpty
                              ? await quickInvoiceController
                                  .saveVendorOrder('bill')
                              : null,
                        ),
                      )
                    : Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: CustomRoundButton(
                          text: isUpdateBill ? 'Update Bill' : 'Save as Bill',
                          contrast: false,
                          isLoadingButton: true,
                          isLoading: quickInvoiceController.isLoading.value,
                          onPressed: () async => quickInvoiceController
                                  .invoiceCart.items.isNotEmpty
                              ? await quickInvoiceController
                                  .saveVendorOrder('bill')
                              : null,
                        ),
                      )
          ],
        ));
  }

  Widget _extendedAppBar(BuildContext context) {
    return Column(
      children: [
        AppBar(
            centerTitle: true,
            backgroundColor: context.scaffoldBackgroundColor,
            iconTheme: IconThemeData(
              color: context.iconColor1, //change your color here
            ),
            title: Text(
              (quickInvoiceController.pageType == 'credit')
                  ? 'Credit Memo'
                  : 'Invoice Preview',
              style: context.titleMedium,
            )),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CustomRoundButton(
                text: 'Change Customer',
                contrast: true,
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: context.scaffoldBackgroundColor,
                      context: context,
                      builder: (builder) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomScrollView(
                            slivers: [
                              const SpaceH12().sliverToBoxAdapter,
                              _buildSearchField(context).sliverToBoxAdapter,
                              const SpaceH12().sliverToBoxAdapter,
                              _buildCustomerList(),
                              const SpaceH12().sliverToBoxAdapter,
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
            const SpaceW12(),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CustomRoundButton(
                text: 'Add New line',
                contrast: false,
                onPressed: () {
                  Get.defaultDialog(
                    backgroundColor: context.scaffoldBackgroundColor,
                    title: 'Add New Product',
                    titleStyle: context.titleMedium,
                    content: SizedBox(
                        width: double.maxFinite,
                        child: _buildSuggestedSearchField(context)),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _extendedVendorAppBar(BuildContext context) {
    return Column(
      children: [
        AppBar(
            centerTitle: true,
            backgroundColor: context.scaffoldBackgroundColor,
            iconTheme: IconThemeData(
              color: context.iconColor1, //change your color here
            ),
            title: Text(
              (quickInvoiceController.pageType == 'credit')
                  ? 'Purchase Credit Memo'
                  : 'Bill Preview',
              style: context.titleMedium,
            )),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CustomRoundButton(
                text: 'Change Vendor',
                contrast: true,
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: context.scaffoldBackgroundColor,
                      context: context,
                      builder: (builder) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomScrollView(
                            slivers: [
                              const SpaceH12().sliverToBoxAdapter,
                              _buildVendorSearchField(context)
                                  .sliverToBoxAdapter,
                              const SpaceH12().sliverToBoxAdapter,
                              _buildVendorList(),
                              const SpaceH12().sliverToBoxAdapter,
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
            const SpaceW12(),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CustomRoundButton(
                text: 'Add New line',
                contrast: false,
                onPressed: () {
                  Get.defaultDialog(
                    backgroundColor: context.scaffoldBackgroundColor,
                    title: 'Add New Product',
                    titleStyle: context.titleMedium,
                    content: SizedBox(
                        width: double.maxFinite,
                        child: _buildSuggestedSearchField(context)),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: customerController.searchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppStrings.SEARCH_HINT_TEXT,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: customerController.onClearSearchBar,
            onChanged: customerController.searchCustomers,
          ),
        ),
      ],
    );
  }

  Widget _buildVendorSearchField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: vendorController.searchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppStrings.SEARCH_HINT_TEXT,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: vendorController.onClearSearchBar,
            onChanged: vendorController.searchCustomers,
          ),
        ),
      ],
    );
  }

  Widget _buildVendorList() {
    return SlidableAutoCloseBehavior(
      child: PagedSliverGrid<int, VendorModel>(
        pagingController: vendorController.vendorsPaginationKey,
        shrinkWrapFirstPageIndicators: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.getResponsiveValue(
            mobile: 1,
            tablet: 2,
            desktop: 3,
          ),
          mainAxisExtent: Sizes.HEIGHT_100,
          crossAxisSpacing: Sizes.PADDING_8,
        ),
        builderDelegate: PagedChildBuilderDelegate<VendorModel>(
          animateTransitions: true,
          itemBuilder: (context, VendorModel vendor, _) {
            return vendorController.vendorsPaginationKey.itemList!.isEmpty
                ? const ProductShimmer()
                : InkWell(
                    onTap: () {
                      CustomerModel customerModel = CustomerModel();
                      customerModel.customerId = vendor.vendorId;
                      customerModel.customerName = vendor.vendorName;
                      customerModel.companyName = vendor.companyName;
                      customerModel.isTaxable = vendor.isTaxable;
                      customerModel.isActive = vendor.isActive;
                      customerModel.email = vendor.email;
                      customerModel.phoneNo = vendor.phoneNo;
                      customerModel.address1 = vendor.address1;
                      customerModel.state = vendor.state;
                      customerModel.postalCode = vendor.postalCode;
                      customerModel.openBalance = vendor.openBalance;
                      customerModel.isQBCustomer = vendor.isQbVendor;
                      quickInvoiceController.argsCustomer.value = customerModel;
                      quickInvoiceController.invoiceCart.customerId =
                          customerModel.customerId;
                      Get.find<VendorDetailController>().argsVendor.value =
                          vendor;
                      Get.back();
                    },
                    child: VendorCard(vendor: vendor, showActiveToggle: true));
          },
          firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
            error: vendorController.vendorsPaginationKey.error,
            onTryAgain: vendorController.vendorsPaginationKey.refresh,
          ),
          noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
            onTryAgain: vendorController.vendorsPaginationKey.refresh,
          ),
          newPageProgressIndicatorBuilder: (_) =>
              const CupertinoActivityIndicator(
            radius: Sizes.ICON_SIZE_16,
          ),
          firstPageProgressIndicatorBuilder: (_) => const ProductShimmer(),
        ),
      ),
    );
  }

  Widget _buildCustomerList() {
    return PagedSliverGrid<int, CustomerModel>(
      pagingController: customerController.customersPaginationKey,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.getResponsiveValue(
          mobile: 1,
          tablet: 2,
          desktop: 3,
        ),
        mainAxisExtent: Sizes.HEIGHT_100,
        crossAxisSpacing: Sizes.PADDING_8,
      ),
      builderDelegate: PagedChildBuilderDelegate<CustomerModel>(
          animateTransitions: true,
          itemBuilder: (context, CustomerModel customer, _) {
            return customerController.customersPaginationKey.itemList!.isEmpty
                ? const CircularProgressIndicator.adaptive()
                : InkWell(
                    onTap: () {
                      quickInvoiceController.argsCustomer.value = customer;
                      quickInvoiceController.invoiceCart.customerId =
                          customer.customerId;
                      Get.find<CustomerDetailController>().argsCustomer.value =
                          customer;
                      Get.find<CustomerDetailController>()
                          .transactionsPaginationKey
                          .refresh();
                      Get.back();
                    },
                    child: CustomerCard(
                        customer: customer, showActiveToggle: true));
          },
          firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
                error: customerController.customersPaginationKey.error,
                onTryAgain: customerController.customersPaginationKey.refresh,
              ),
          noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
                onTryAgain: customerController.customersPaginationKey.refresh,
              ),
          newPageProgressIndicatorBuilder: (_) =>
              const CupertinoActivityIndicator(
                radius: Sizes.ICON_SIZE_16,
              ),
          firstPageProgressIndicatorBuilder: (_) =>
              const CircularProgressIndicator.adaptive()),
    );
  }

  Widget _buildSuggestedSearchField(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TypeAheadField(
          hideOnEmpty: true,
          minCharsForSuggestions: 3,
          hideSuggestionsOnKeyboardHide: true,
          keepSuggestionsOnLoading: false,
          keepSuggestionsOnSuggestionSelected: false,
          hideOnLoading: false,
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            color: Colors.yellow.shade100,
          ),
          textFieldConfiguration: TextFieldConfiguration(
            controller: quickInvoiceController.searchTextController,
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {
                    Get.to(
                      () => CustomBarcodeQRScanner(
                        onDetect:
                            quickInvoiceController.searchByBarcodeInAddNewLine,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.document_scanner,
                    color: context.primary,
                    size: Sizes.ICON_SIZE_20,
                  ),
                ),
                label: Text(
                  AppStrings.SEARCH_HINT_TEXT,
                  style: TextStyle(
                    color: DarkTheme.darkShade3,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () =>
                      quickInvoiceController.searchTextController.clear(),
                  icon: Icon(
                    Icons.cancel,
                    color: DarkTheme.darkShade3,
                    size: Sizes.ICON_SIZE_20,
                  ),
                ),
                labelStyle: context.captionLarge),
          ),
          suggestionsCallback: quickInvoiceController.suggestionCallback,
          itemBuilder: (context, suggestion) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                suggestion.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black),
              ),
            );
          },
          getImmediateSuggestions: true,
          onSuggestionSelected: (suggestion) async {
            var selectedProduct =
                await quickInvoiceController.addNewLineSuggestion(suggestion);

            if (!mounted) return;

            if (selectedProduct != null) {
              Get.back();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return _showAddNewLineDialog(context, selectedProduct);
                  });
            }
          }),
    );
  }

  Widget _showAddNewLineDialog(
      BuildContext context, CategoryProductModel product) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      backgroundColor: context.scaffoldBackgroundColor,
      title: Container(
        decoration: BoxDecoration(
          color: context.primary.withOpacity(0.7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28.0),
            topRight: Radius.circular(28.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        width: double.maxFinite,
        child: Text("Add New Item", style: context.titleLarge),
      ),
      content: _showProductEditCard(
          context,
          product,
          quickInvoiceController
              .getIndexFromCategoryName(product.rootCategoryName ?? '')),
    );
  }

  Widget _buildProductDataTable(BuildContext context) {
    return Obx(() => (quickInvoiceController.invoiceCart.items.isNotEmpty)
        ? SlidableAutoCloseBehavior(
            child: Table(
              border: TableBorder(
                  bottom: BorderSide(color: DarkTheme.darkShade3),
                  horizontalInside: BorderSide(color: DarkTheme.darkShade3)),
              children: [
                TableRow(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('ITEMS', style: context.titleSmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('AMOUNT', style: context.titleSmall),
                        ),
                      ],
                    ),
                  ],
                ),
                for (var i = 0;
                    i < quickInvoiceController.invoiceCart.items.length;
                    i++)
                  TableRow(
                    decoration:
                        BoxDecoration(color: context.scaffoldBackgroundColor),
                    children: [
                      Slidable(
                          endActionPane: ActionPane(
                            extentRatio: 0.30,
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) =>
                                    quickInvoiceController
                                        .onPressDeleteInvoiceItem(i),
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  int categoryIndex = quickInvoiceController
                                      .getIndexFromCategoryName(
                                          quickInvoiceController.invoiceCart
                                                  .items[i].rootCategoryName ??
                                              '');

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          titlePadding: EdgeInsets.zero,
                                          backgroundColor:
                                              context.scaffoldBackgroundColor,
                                          title: Container(
                                            decoration: BoxDecoration(
                                              color: context.primary
                                                  .withOpacity(0.7),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(28.0),
                                                topRight: Radius.circular(28.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 25),
                                            width: double.maxFinite,
                                            child: Text("Item Edit",
                                                style: context.titleLarge),
                                          ),
                                          content: _showProductEditCard(
                                              context,
                                              quickInvoiceController
                                                  .invoiceCart.items[i],
                                              categoryIndex),
                                        );
                                      });
                                },
                                backgroundColor: Colors.yellow.shade800,
                                foregroundColor: Colors.white,
                                icon: Icons.edit_outlined,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 6, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.loose,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${quickInvoiceController.invoiceCart.items[i].productName}",
                                        style: context.captionLarge,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SpaceH4(),
                                      Text(
                                        quickInvoiceController.isVendorThere
                                            ? "${quickInvoiceController.invoiceCart.items[i].quantity.toStringAsFixed(2)} x \$${quickInvoiceController.invoiceCart.items[i].cost?.toStringAsFixed(2)}"
                                            : "${quickInvoiceController.invoiceCart.items[i].quantity.toStringAsFixed(2)} x \$${quickInvoiceController.invoiceCart.items[i].price?.toStringAsFixed(2)}",
                                        style: context.captionLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (quickInvoiceController.invoiceCart
                                                .items[i].isTaxable !=
                                            null &&
                                        quickInvoiceController.invoiceCart
                                                .items[i].isTaxable ==
                                            true &&
                                        quickInvoiceController
                                            .invoiceCart.isTaxable.value)
                                      Text(
                                        "(T) ",
                                        style: context.titleSmall.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    Text(
                                      quickInvoiceController.isVendorThere
                                          ? '\$${(quickInvoiceController.invoiceCart.items[i].cost! * quickInvoiceController.invoiceCart.items[i].quantity).toStringAsFixed(2)}'
                                          : '\$${(quickInvoiceController.invoiceCart.items[i].price! * quickInvoiceController.invoiceCart.items[i].quantity).toStringAsFixed(2)}',
                                      style: context.captionLarge,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
              ],
            ),
          )
        : Center(
            child: Text(
              'No Items Selected!',
              style: context.titleLarge,
            ),
          ));
  }

  Widget _showProductEditCard(
      BuildContext context, CategoryProductModel prod, int categoryIndex) {
    return ProductEditCard(
      prod: prod,
      categoryIndex: categoryIndex,
      confirmationNeeded: true,
    );
  }

  Widget _buildNotesWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.PADDING_8),
      margin: const EdgeInsets.symmetric(vertical: Sizes.PADDING_4),
      decoration: BoxDecoration(
        border: Border.all(
          color: DarkTheme.darkShade3,
        ),
        color: context.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Sizes.RADIUS_12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.PADDING_8,
              horizontal: Sizes.PADDING_4,
            ),
            child: Text(
              'Memo:',
              style: context.subtitle1.copyWith(
                color: DarkTheme.darkShade3,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SpaceH4(),
          ZefyrEditor(
            controller: quickInvoiceController.notesController,
            minHeight: Sizes.HEIGHT_50,
            autofocus: false,
            scrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_8),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalContainer(BuildContext context) {
    return Obx(() => Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: context.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Subtotal:',
                    style: context.bodyLarge
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Text(
                    '\$${quickInvoiceController.invoiceCart.total.toStringAsFixed(2)}',
                    style:
                        context.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SpaceH12(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Discount:',
                    style: context.bodyLarge
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Text(
                    '\$${quickInvoiceController.invoiceCart.discountedAmount.toStringAsFixed(2)}',
                    style:
                        context.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SpaceH12(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Sales Tax 8.25%:',
                    style: context.bodyLarge.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${(quickInvoiceController.invoiceCart.taxedAmount.value).toStringAsFixed(2)}',
                    style: context.bodyLarge
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                  )
                ],
              ),
              const SpaceH16(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Total (USD): ',
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                    ),
                  ),
                  Text(
                    '\$${(quickInvoiceController.invoiceCart.total.value + (quickInvoiceController.invoiceCart.taxedAmount.value) - quickInvoiceController.invoiceCart.discountedAmount.value).toStringAsFixed(2)}',
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildCustomerInfoContainer(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: _buildCustomerInfoDisplay(context),
    );
  }

  Widget _buildCustomerInfoDisplay(BuildContext context) {
    String address = "";
    if (quickInvoiceController.argsCustomer.value.address1 != null) {
      address +=
          "${quickInvoiceController.argsCustomer.value.address1?.toUpperCase()}";
    }
    if (quickInvoiceController.argsCustomer.value.city != null) {
      address +=
          "${address.isNotEmpty ? ", " : ""}${quickInvoiceController.argsCustomer.value.city?.toUpperCase()}";
    }
    if (quickInvoiceController.argsCustomer.value.state != null) {
      address +=
          "${address.isNotEmpty ? ", " : ""}${quickInvoiceController.argsCustomer.value.state?.toUpperCase()}";
    }
    if (quickInvoiceController.argsCustomer.value.postalCode != null) {
      address +=
          "${address.isNotEmpty ? ", " : ""}${quickInvoiceController.argsCustomer.value.postalCode?.toUpperCase()}";
    }
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              quickInvoiceController.argsCustomer.value.companyName.toString(),
              style: context.captionMedium.copyWith(fontSize: 14),
            ),
            Text(
              address,
              style: context.captionMedium.copyWith(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              quickInvoiceController.argsCustomer.value.email ?? "",
              style: context.captionMedium.copyWith(fontSize: 14),
            ),
            Text(
              quickInvoiceController.argsCustomer.value.phoneNo ?? "",
              style: context.captionMedium.copyWith(fontSize: 14),
            ),
          ],
        ));
  }
}
