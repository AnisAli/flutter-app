import 'dart:ui';

import 'package:otrack/views/customers/components/category_product_card.dart';
import 'package:otrack/views/customers/components/preview_sheet_card.dart';
import 'package:otrack/views/customers/views/root_category_product.dart';
import '../../../exports/index.dart';
import '../components/product_edit_card.dart';
import '../components/root_category_card.dart';

class QuickInvoice extends GetView<QuickInvoiceController> {
  static const String routeName = '/quickInvoice';

  const QuickInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        pinAppBar: true,
        overscroll: true,
        showThemeButton: false,
        showMenuButton: false,
        customBottomNavigationBar: _buildCustomBottomNavigationBar(context),
        simpleAppBar: _buildSimpleAppBar(context),
        scrollController: controller.scrollController,
        children: [
          const SpaceH8().sliverToBoxAdapter,
          _buildSearchField(context).sliverToBoxAdapter,
          const SpaceH4().sliverToBoxAdapter,
          _buildTabs(context).sliverToBoxAdapter,
          const SpaceH8().sliverToBoxAdapter,
          Obx(() => _buildTabBody(context)),
        ]).scaffold();
  }

  Widget _buildCategoryTabBody(BuildContext context) {
    return controller.isShowAllRootSearchProducts.value
        ? _buildProductList()
        : _buildCategoryCardGrid(context).sliverToBoxAdapter;
  }

  Widget _buildCategoryCardGrid(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns in the grid
      ),
      itemCount: controller.rootCategories.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        // Get the root category name from the list
        String categoryName =
            controller.rootCategories[index].rootCategoryName ?? '';

        return InkWell(
            onTap: () async {
              await controller.getRootProducts(
                  controller.rootCategories[index].rootCategoryId ?? 1);
              Get.to(() => RootCategoryProduct(
                  rootCategory: controller.rootCategories[index]));
            },
            child: RootCategoryCard(categoryName: categoryName));
      },
    );
  }

  List<Widget> _buildShowCategorySearchBar(BuildContext context) {
    return [
      Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: _buildCategorySearchField(context)),
    ];
  }

  Widget _buildProductList() {
    return PagedSliverList<int, ProductModel>(
      pagingController: controller.productsPaginationKey,
      shrinkWrapFirstPageIndicators: true,
      builderDelegate: PagedChildBuilderDelegate<ProductModel>(
        animateTransitions: true,
        itemBuilder: (context, ProductModel product, _) {
          CategoryProductModel prod =
              CategoryProductModel.fromProductModel(product);
          int ind = controller.invoiceCart.items
              .indexWhere((item) => item.productId == prod.productId);

          if (ind != -1) {
            prod = controller.invoiceCart.items[ind];
          }
          return controller.productsPaginationKey.itemList?.isEmpty ?? true
              ? const ProductShimmer()
              : _buildExpandedProductCard(context, prod, -1);
        },
        firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
          error: controller.productsPaginationKey.error,
          onTryAgain: controller.productsPaginationKey.refresh,
        ),
        noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
          onTryAgain: controller.productsPaginationKey.refresh,
        ),
        newPageProgressIndicatorBuilder: (_) =>
            const CupertinoActivityIndicator(
          radius: Sizes.ICON_SIZE_16,
        ),
        firstPageProgressIndicatorBuilder: (_) => const ProductShimmer(),
      ),
    );
  }

  Widget _buildExpandedProductCard(
      BuildContext context, CategoryProductModel prod, int categoryIndex,
      {bool isInitiallyExpanded = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(bottom: 3),
      color: context.cardColor,
      child: ProductEditCard(
        prod: prod,
        categoryIndex: categoryIndex,
        confirmationNeeded: false,
        isInitiallyExpanded: isInitiallyExpanded,
        isFromRootCategoryPage: true,
      ),
    );
  }

  Widget _buildCategorySearchField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
              autofocus: false,
              controller: controller.searchTextProductListController,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: AppStrings.SEARCH_HINT_TEXT,
              labelColor: DarkTheme.darkShade3,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.emailAddress,
              prefixIconData: Iconsax.search_normal_1,
              suffixIconData: Iconsax.close_circle5,
              suffixIconColor: LightTheme.grayColorShade0,
              onSuffixTap: () {
                if (controller.searchTextProductListController.text != "") {
                  controller.searchTextProductListController.clear();
                  controller.searchProducts("");
                }
                controller.isShowAllRootSearchProducts(false);
              },
              onChanged: (val) {
                controller.searchProducts(val);
                if (val != '') {
                  controller.isShowAllRootSearchProducts(true);
                } else {
                  controller.isShowAllRootSearchProducts(false);
                }
              }),
        ),
        const SpaceW8(),
        Expanded(
          child: CustomButton(
            buttonType: ButtonType.image,
            color: context.primaryColor,
            image: const Icon(
              Iconsax.scan,
              color: DarkTheme.appBarIconsColor,
            ),
            buttonPadding:
                const EdgeInsets.symmetric(vertical: Sizes.PADDING_12),
            textColor: DarkTheme.appBarIconsColor,
            text: AppStrings.SCAN_BARCODE,
            hasInfiniteWidth: false,
            onPressed: () {
              Get.to(
                () => CustomBarcodeQRScanner(
                  onDetect: controller.searchByBarcodeForSearchField,
                ),
              );
            },
          ),
        ),
        const SpaceW8(),
        Expanded(
          child: CustomButton(
              buttonType: ButtonType.image,
              color: context.primaryColor,
              image: const Icon(
                Icons.add,
                color: DarkTheme.appBarIconsColor,
              ),
              buttonPadding:
                  const EdgeInsets.symmetric(vertical: Sizes.PADDING_12),
              textColor: DarkTheme.appBarIconsColor,
              text: AppStrings.SCAN_BARCODE,
              hasInfiniteWidth: false,
              onPressed: controller.onPressAddProductButton),
        ),
      ],
    );
  }

  Widget _buildTabBody(BuildContext context) {
    if (controller.tabIndex.value == 0) {
      return (!controller.isShimmerEffectLoading.value)
          ? _buildCategoryTabBody(context)
          : const ProductShimmer().sliverToBoxAdapter;
    } else if (controller.tabIndex.value == 1) {
      return const CategoryProductCard().sliverToBoxAdapter;
    } else {
      return _buildScannerBody(context).sliverToBoxAdapter;
    }
  }

  Widget _buildScannerBody(BuildContext context) {
    return Obx(
      () => (controller.isScannerEnable.value)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        thumbColor: context.primary,
                        value: controller.alwaysScanSwitch.value,
                        onChanged: controller.onToggleAlwaysScanSwitch,
                      ),
                    ),
                    const SpaceW8(),
                    Text(
                      'Continuous Scan',
                      style: context.bodyMedium
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                _buildMobileScanner(context),
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.invoiceCart.items.length,
                      itemBuilder: (context, index) {
                        final product = controller.invoiceCart.items[index];
                        final categoryIndex =
                            controller.getIndexFromCategoryName(
                                product.rootCategoryName ?? '');

                        return Container(
                          color: context.cardColor,
                          child: Column(
                            children: [
                              ProductEditCard(
                                prod: product,
                                isInitiallyExpanded: index ==
                                    controller.invoiceCart.items.length - 1,
                                categoryIndex: categoryIndex,
                                confirmationNeeded: false,
                                scannerPage: true,
                              ),
                              Divider(
                                height: 2,
                                thickness: 1,
                                color: context.primary,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  Widget _buildMobileScanner(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: 220,
        width: double.maxFinite,
        child: MobileScanner(
            controller: controller.scanController,
            fit: BoxFit.fitWidth,
            onDetect: (capture) async {
              if (!controller.isBarCodeLoading.value) {
                final List<Barcode> barcodes = capture.barcodes;
                // controller.scannedImageBytes.value = capture.image;
                for (final barcode in barcodes) {
                  debugPrint('BarcodeType: ${barcode.format}');
                  controller.isLoading(true);
                  await controller.searchByBarcode(barcode, context);
                  controller.isLoading(false);
                  break;
                }
              }
            }),
      ),
      Obx(() => (!controller.isBarCodeLoading.value)
          ? Container(
              height: 210,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(5.0),
              decoration: ShapeDecoration(
                shape: QrScannerOverlayShape(
                  borderColor: Colors.greenAccent,
                  borderRadius: Sizes.RADIUS_14,
                  borderLength: Sizes.WIDTH_20,
                  borderWidth: Sizes.WIDTH_10,
                  cutOutSize: double.maxFinite,
                  cutOutBottomOffset: 0,
                ),
              ),
            )
          : InkWell(
              onTap: controller.onPressTabToScan,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.primary, width: 3),
                ),
                alignment: Alignment.center,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blurred overlay
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 10, sigmaY: 25), // Adjust blur intensity
                        child: Container(
                          color: Colors
                              .transparent, // Apply color if you want to tint the overlay
                          width: double.infinity,
                          height: 220,
                          child: Center(
                            child: Text(
                              "Tab to scan",
                              style: context.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (controller.isLoading.value)
                      const CircularProgressIndicator.adaptive(),
                  ],
                ),
              ),
            )),
    ]);
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.topCenter,
      child: TabBar(
        onTap: controller.onTabChange,
        controller: controller.tabController,
        tabs: controller.myTabs,
        labelColor: context.iconColor1,
        unselectedLabelColor: context.iconColor1,
        labelStyle: context.captionMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        enableFeedback: true,
        labelPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _showDiscountDropDown(BuildContext context) {
    return Obx(() => SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDropDownField<String>(
                controller: controller.discountTypeController,
                showSearchBox: false,
                title: AppStrings.NONE_FIXED_PERCENTAGE,
                prefixIcon: Icons.discount,
                onChange: controller.onDiscountTypeChange,
                items: controller.discountTypes,
                selectedItem: controller.discountType.value,
              ),
              const SpaceH4(),
              if (controller.discountType.value == controller.discountTypes[1])
                CustomTextFormField(
                  autofocus: true,
                  controller: controller.fixedDiscountAmountController,
                  textAlign: TextAlign.end,
                  fillColor: context.scaffoldBackgroundColor,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIconData: Icons.attach_money,
                  labelText: 'Fixed Discount',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,10}(\.\d{0,2})?'),
                    ),
                  ],
                  onChanged: (val) {},
                  hintText: '\$0.00',
                ),
              if (controller.discountType.value == controller.discountTypes[2])
                CustomTextFormField(
                  autofocus: true,
                  controller: controller.percentageDiscountAmountController,
                  textAlign: TextAlign.end,
                  fillColor: context.scaffoldBackgroundColor,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIconData: Icons.percent_outlined,
                  labelText: 'Percentage Discount',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{1,2}$'),
                    ),
                  ],
                  onChanged: (val) {},
                  hintText: '%00',
                ),
              const SpaceH20(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CustomRoundButton(
                      text: AppStrings.CANCEL,
                      contrast: true,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SpaceW12(),
                  if (controller.discountType.value !=
                          controller.discountTypes[0] ||
                      controller.isDiscountSelected())
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomRoundButton(
                          text: 'Apply',
                          contrast: false,
                          onPressed: controller.onApplyDiscount),
                    ),
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildCustomBottomNavigationBar(BuildContext context) {
    TextStyle customStyle =
        context.titleSmall.copyWith(color: Colors.white, fontSize: 12);
    Color primeBackgroundColor =
        (controller.pageType == 'credit' || controller.pageType == 'editCredit')
            ? DarkTheme.darkShade3
            : context.primary;
    // RxBool isBottomBarExpanded = false.obs;
    return Obx(() => ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExpansionTile(
            initiallyExpanded: false,
            backgroundColor: primeBackgroundColor,
            collapsedBackgroundColor: primeBackgroundColor,
            title: Container(
              margin: const EdgeInsets.only(left: 10),
              width: double.maxFinite,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.pageType == 'credit' ||
                      controller.pageType == 'editCredit')
                    Text(
                      '(Credit Memo)',
                      style: context.subtitle1.copyWith(color: Colors.white),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: customStyle,
                      ),
                      Text(
                        '\$${controller.invoiceCart.total.toStringAsFixed(2)}',
                        style: customStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Discount:',
                            style: customStyle,
                          ),
                          if (controller.isBottomBarExpanded.value)
                            InkWell(
                              onTap: () {
                                Get.defaultDialog(
                                    title: "Select Discount",
                                    backgroundColor:
                                        context.scaffoldBackgroundColor,
                                    titleStyle: context.titleMedium,
                                    content: _showDiscountDropDown(context));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: context.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: (controller.discountTempType ==
                                        controller.discountTypes[1])
                                    ? Text(
                                        "${controller.discountTempFixedAmount != 0.00 ? '\$${controller.discountTempFixedAmount}' : " "}  ",
                                        style: customStyle.copyWith(
                                            color: context.iconColor1),
                                        textScaleFactor: 0.7,
                                      )
                                    : Text(
                                        "${controller.discountTempPercent.value != 0.00 ? '${controller.discountTempPercent} %' : " "}  ",
                                        style: customStyle.copyWith(
                                            color: context.iconColor1),
                                        textScaleFactor: 0.7,
                                      ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '\$${controller.invoiceCart.discountedAmount.value.toStringAsFixed(2)}',
                        style: customStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Tax(${controller.argsCustomer.value.taxPercent ?? '0.00'}%):',
                            style: customStyle,
                          ),
                          if (controller.isBottomBarExpanded.value)
                            Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                activeColor: context.scaffoldBackgroundColor,
                                thumbColor: primeBackgroundColor,
                                value: controller.invoiceCart.isTaxable.value,
                                onChanged: (val) {
                                  controller.invoiceCart.isTaxable(val);
                                  if (controller.isVendorThere) {
                                    controller.invoiceCart
                                        .calculateVendorTaxedAmount();
                                  } else {
                                    controller.invoiceCart
                                        .calculateTaxedAmount();
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '\$${(controller.invoiceCart.taxedAmount.value).toStringAsFixed(2)}',
                        style: customStyle,
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: customStyle,
                      ),
                      Text(
                        '\$${(controller.invoiceCart.total.value + (controller.invoiceCart.taxedAmount.value) - controller.invoiceCart.discountedAmount.value).toStringAsFixed(2)}',
                        style: customStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            trailing: const SizedBox(),
            tilePadding: EdgeInsets.zero,
            leading: controller.isBottomBarExpanded.value
                ? const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
            onExpansionChanged: (val) {
              controller.isBottomBarExpanded.value = val;
              if (!val) {
                customStyle = context.titleSmall
                    .copyWith(color: Colors.white, fontSize: 12);
              }
              if (val) {
                customStyle = context.titleLarge
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500);
              }
            },
            children: [
              _customBottomButtons(context),
            ],
          ),
        )));
  }

  Widget _customBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: context.scaffoldBackgroundColor,
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: CustomRoundButton(
                text: 'Cancel',
                contrast: true,
                onPressed: () {
                  Get.back();
                }),
          ),
          const SpaceW12(),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: CustomRoundButton(
              text: 'Preview',
              contrast: false,
              onPressed: () => CustomSnackBar.showCustomBottomSheet(
                  enableDrag: false,
                  color: context.scaffoldBackgroundColor,
                  bottomSheet: const PreviewSheetCard()),
            ),
          ),
        ],
      ),
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
          controller: controller.searchTextController,
          decoration: InputDecoration(
              label: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: context.primary,
                  ),
                  const SpaceW4(),
                  Text(
                    AppStrings.SEARCH_HINT_TEXT,
                    style: TextStyle(
                      color: DarkTheme.darkShade3,
                    ),
                  ),
                ],
              ),
              suffixIcon: IconButton(
                onPressed: () => controller.searchTextController.clear(),
                icon: Icon(
                  Icons.cancel,
                  color: DarkTheme.darkShade3,
                  size: Sizes.ICON_SIZE_20,
                ),
              ),
              labelStyle: context.captionLarge),
        ),
        suggestionsCallback: controller.suggestionCallback,
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
        onSuggestionSelected: controller.onSuggestionSelection,
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Obx(() => Row(
        children: controller.tabIndex.value == 2
            ? _buildScanSearchBar(context)
            : controller.tabIndex.value == 1
                ? _buildFrequentlyOrderedSearchBar(context)
                : _buildShowCategorySearchBar(context)));
  }

  List<Widget> _buildFrequentlyOrderedSearchBar(BuildContext context) {
    return [
      Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: _buildSuggestedSearchField(context)),
      const SpaceW8(),
      Expanded(
        child: CustomButton(
            buttonType: ButtonType.image,
            color: context.primaryColor,
            image: const Icon(
              Icons.add,
              color: DarkTheme.appBarIconsColor,
            ),
            buttonPadding:
                const EdgeInsets.symmetric(vertical: Sizes.PADDING_12),
            textColor: DarkTheme.appBarIconsColor,
            text: AppStrings.SCAN_BARCODE,
            hasInfiniteWidth: false,
            onPressed: controller.onPressAddProductButton),
      ),
    ];
  }

  List<Widget> _buildScanSearchBar(BuildContext context) {
    return [
      Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: controller.changeSearchBehaviour.value
              ? _buildSuggestedSearchField(context)
              : _buildScannerSearchField(context)),
      const SpaceW8(),
      Expanded(
        child: CustomButton(
            buttonType: ButtonType.image,
            color: context.primaryColor,
            image: Icon(
              controller.changeSearchBehaviour.value
                  ? Iconsax.scan
                  : CupertinoIcons.textformat_abc,
              color: DarkTheme.appBarIconsColor,
            ),
            buttonPadding:
                const EdgeInsets.symmetric(vertical: Sizes.PADDING_12),
            textColor: DarkTheme.appBarIconsColor,
            text: AppStrings.SCAN_BARCODE,
            hasInfiniteWidth: false,
            onPressed: controller.onPressChangeSearchBehaviour),
      ),
      const SpaceW8(),
      Expanded(
        child: CustomButton(
            buttonType: ButtonType.image,
            color: context.primaryColor,
            image: const Icon(
              Icons.add,
              color: DarkTheme.appBarIconsColor,
            ),
            buttonPadding:
                const EdgeInsets.symmetric(vertical: Sizes.PADDING_12),
            textColor: DarkTheme.appBarIconsColor,
            text: AppStrings.SCAN_BARCODE,
            hasInfiniteWidth: false,
            onPressed: controller.onPressAddProductButton),
      ),
    ];
  }

  Widget _buildScannerSearchField(BuildContext context) {
    return CustomTextFormField(
      autofocus: false,
      controller: controller.searchBarcodeTextController,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelText: AppStrings.SEARCH_BARCODE_HERE_TEXT,
      labelColor: DarkTheme.darkShade3,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      prefixIconData: Iconsax.scan,
      suffixIconData: Iconsax.close_circle5,
      suffixIconColor: LightTheme.grayColorShade0,
      onSuffixTap: controller.searchBarcodeTextController.clear,
      onFieldSubmit: (val) {
        controller.onSubmitSearchBarcode(val, context);
      },
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      pinned: true,
      backgroundColor: context.scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: context.iconColor1),
        onPressed: () => controller.checkIfCartEmpty(context),
      ),
      centerTitle: true,
      title: Obx(() => Column(
            children: [
              if (controller.isVendorThere)
                Text(
                  "Vendor",
                  style: context.titleMedium,
                ),
              Text(
                controller.argsCustomer.value.customerName ?? "",
                style: context.titleLarge.copyWith(
                    color: context.primary, fontSize: Sizes.TEXT_SIZE_22),
              ),
            ],
          )),
    );
  }
}
