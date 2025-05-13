import '../../../exports/index.dart';
import '../../../widgets/templates/action_buttons/menu_button.dart';
import '../components/product_card.dart';

class Products extends GetView<ProductController> {
  static const String routeName = '/products';

  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      extendedAppBar: _extendedAppBar(context),
      scaffoldKey: controller.scaffoldKey,
      padding: Sizes.PADDING_12,
      // TODO : To Keep Search Bar always on Top
      // physics: const NeverScrollableScrollPhysics(),
      actionButton: _buildAddNewProductButton(context),
      children: [
        const SpaceH24().sliverToBoxAdapter,
        _buildProductList(),
        const SpaceH8().sliverToBoxAdapter,
      ],
    ).scaffoldWithDrawer();
  }

  Widget _extendedAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const MenuButton(),
            _buildAddNewProductButton(context),
          ],
        ),
        _buildSearchField(context),
        _buildOptionsBar(context),
      ],
    );
  }

  Widget _buildOptionsBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      height: 55,
      color: context.primary,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _showFilterSheet(context, 'Filters');
            },
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list,
                  size: 22,
                  color: Colors.white,
                ),
                const SpaceW4(),
                Text('Filter',
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          const VerticalDivider(
            thickness: 2,
            width: 40,
            color: Colors.white,
          ),
          InkWell(
            onTap: () {
              _showSortSheet(context, AppStrings.SORT_BY);
            },
            child: Text(
              'Sort by',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 2,
            width: 40,
            color: Colors.white,
          ),
          InkWell(
            onTap: () {
              _showSettingSheet(context, AppStrings.SETTINGS);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.settings,
                  size: 22,
                  color: Colors.white,
                ),
                const SpaceW8(),
                Text(AppStrings.SETTINGS,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return SlidableAutoCloseBehavior(
      child: PagedSliverGrid<int, ProductModel>(
        pagingController: controller.productsPaginationKey,
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
        builderDelegate: PagedChildBuilderDelegate<ProductModel>(
          animateTransitions: true,
          itemBuilder: (context, ProductModel product, _) {
            return controller.productsPaginationKey.itemList!.isEmpty
                ? const ProductShimmer()
                : Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.75,
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            if (product.isActive != null) {
                              await controller.productToggleStatus(
                                  product.productId.toString(),
                                  product.isActive ?? false);
                            }
                          },
                          backgroundColor: (product.isActive ?? false)
                              ? Colors.red
                              : context.primary,
                          foregroundColor: Colors.white,
                          //icon: Icons.archive,
                          label: (product.isActive ?? false)
                              ? 'Inactive'
                              : 'Active',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            Get.toNamed(
                              AppRoutes.ADD_PRODUCT,
                              arguments: {
                                'product': product,
                                'isCloned': false,
                                "backRoute": false
                              },
                            );
                          },
                          backgroundColor: Colors.yellow.shade800,
                          foregroundColor: Colors.white,
                          //icon: Icons.save,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            Get.toNamed(
                              AppRoutes.ADD_PRODUCT,
                              arguments: {
                                'product': product,
                                'isCloned': true,
                                "backRoute": false
                              },
                            );
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          //icon: Icons.save,
                          label: 'Clone',
                        ),
                      ],
                    ),
                    startActionPane: ActionPane(
                      extentRatio: 0.6,
                      motion: const DrawerMotion(),
                      children: [
                        if (Get.put(AuthManager()).userPermissions.data?.role ==
                            'Administrator') ...[
                          SlidableAction(
                            onPressed: (BuildContext context) async {
                              Get.toNamed(AppRoutes.ITEM_REPORT, arguments: {
                                'pageType': 'sale',
                                'product': product
                              });
                            },
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                            //icon: Icons.archive,
                            label: 'Sales',
                          ),
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              Get.toNamed(AppRoutes.ITEM_REPORT, arguments: {
                                'pageType': 'purchase',
                                'product': product
                              });
                            },
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            //icon: Icons.save,
                            label: 'Purchases',
                          ),
                        ]
                      ],
                    ),
                    child:
                        ProductCard(product: product, showActiveToggle: true),
                  );
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
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: controller.searchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppStrings.SEARCH_HINT_TEXT,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: () {
              if (controller.searchTextController.text != "") {
                controller.searchTextController.clear();
                controller.searchProducts("");
              }
            },
            onChanged: controller.searchProducts,
          ),
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
                  onDetect: controller.searchByBarcode,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddNewProductButton(BuildContext context) {
    return CustomButton(
      buttonType: ButtonType.textWithImage,
      constraints: const BoxConstraints(minWidth: 100),
      color: context.primaryColor,
      image: const Icon(Iconsax.add, color: Colors.white),
      buttonPadding: const EdgeInsets.symmetric(
        vertical: Sizes.PADDING_8,
        horizontal: Sizes.PADDING_12,
      ),
      customTextStyle: context.titleMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      onPressed: () =>
          Get.toNamed(AppRoutes.ADD_PRODUCT, arguments: {'backRoute': true}),
      verticalMargin: 0,
      textColor: Colors.white,
      text: AppStrings.ADD_PRODUCT,
      hasInfiniteWidth: false,
    );
  }

  void _showFilterSheet(BuildContext context, String title) {
    if (controller.parentCategories == null) {
      controller.getParentCategories();
    }
    CustomSnackBar.showCustomBottomSheet(
      color: context.scaffoldBackgroundColor,
      bottomSheet: Scaffold(
        appBar: AppBar(
          backgroundColor: context.scaffoldBackgroundColor,
          title: Text(
            title,
            style: context.titleLarge,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor1),
            onPressed: Get.back,
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Sizes.PADDING_14, vertical: Sizes.PADDING_6),
                child: Column(
                  children: [
                    const SpaceH4(),
                    GetBuilder<ProductController>(builder: (_) {
                      return CustomDropDownField<CategoryModel>(
                        controller: controller.parentFilterCategoryController,
                        isEnabled: controller.parentCategories != null,
                        showLoading: controller.parentCategories == null,
                        showSearchBox: true,
                        title: AppStrings.PARENT_CATEGORY,
                        prefixIcon: Iconsax.forward_item,
                        onMultipleChange: controller.onParentCategoryChange,
                        items: controller.parentCategories,
                        selectedItems: controller.selectedParentCategories,
                        selectionType: SelectionType.multiple,
                      );
                    }),
                    const SpaceH4(),
                    CustomDropDownField<String>(
                      controller: controller.activeFilterController,
                      showSearchBox: false,
                      title: AppStrings.ACTIVE_INACTIVE_ALL,
                      prefixIcon: Iconsax.activity,
                      onChange: controller.onActiveFilterChange,
                      items: controller.activeFilters,
                      selectedItem: controller.activeFilter,
                    ),
                    const SpaceH4(),
                    CustomDropDownField<String>(
                      controller: controller.taxFilterController,
                      showSearchBox: false,
                      title: AppStrings.TAX_NONTAX_ALL,
                      prefixIcon: Iconsax.bank,
                      onChange: controller.onTaxFilterChange,
                      items: controller.taxTypeFilters,
                      selectedItem: controller.taxFilter,
                    ),
                    const SpaceH4(),
                    CustomDropDownField<String>(
                      controller: controller.stockFilterController,
                      showSearchBox: false,
                      title: AppStrings.IN_OUT_STOCK_ALL,
                      prefixIcon: Iconsax.shopping_cart,
                      onChange: controller.onStockFilterChange,
                      items: controller.stockFilters,
                      selectedItem: controller.stockFilter,
                    ),
                    const SpaceH4(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Sizes.PADDING_14, vertical: Sizes.PADDING_6),
                child: CustomButton(
                  buttonType: ButtonType.textWithImage,
                  color: context.primaryColor,
                  textColor: context.buttonTextColor,
                  text: AppStrings.CLEAR_FILTERS,
                  image: Icon(
                    Iconsax.filter_remove,
                    color: context.buttonTextColor,
                    size: Sizes.ICON_SIZE_24,
                  ),
                  onPressed: controller.clearFilters,
                  hasInfiniteWidth: true,
                  verticalMargin: 0,
                ),
              ),
            ]),
        bottomNavigationBar: Container(
          margin:
              const EdgeInsets.only(bottom: 25, left: 10, right: 10, top: 15),
          child: CustomButton(
            buttonType: ButtonType.textWithImage,
            color: context.primaryColor,
            textColor: context.buttonTextColor,
            text: AppStrings.APPLY,
            image: Icon(
              Iconsax.filter,
              color: context.buttonTextColor,
              size: Sizes.ICON_SIZE_24,
            ),
            onPressed: controller.applySelectedFilters,
            hasInfiniteWidth: false,
            verticalMargin: 0,
          ),
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context, String title) {
    CustomSnackBar.showCustomBottomSheet(
      color: context.scaffoldBackgroundColor,
      bottomSheet: Scaffold(
        appBar: AppBar(
          backgroundColor: context.scaffoldBackgroundColor,
          title: Text(
            title,
            style: context.titleLarge,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor1),
            onPressed: Get.back,
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Sizes.PADDING_14, vertical: Sizes.PADDING_6),
            child: Column(
              children: [
                Obx(
                  () => CheckTileComponent(
                    icon: Iconsax.receipt,
                    title: AppStrings.NAME,
                    value: controller.isSortName.value,
                    onTap: () => controller.onChangeSort('name'),
                  ),
                ),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Iconsax.document_text,
                      title: AppStrings.DESCRIPTION,
                      value: controller.isSortDescription.value,
                      onTap: () => controller.onChangeSort('description'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Iconsax.forward_item,
                      title: AppStrings.PARENT_CATEGORY,
                      value: controller.isSortParentCategory.value,
                      onTap: () => controller.onChangeSort('parentCategory'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Iconsax.money,
                      title: AppStrings.TAXABLE_AND_NONTAXABLE,
                      value: controller.isSortTaxable.value,
                      onTap: () => controller.onChangeSort('taxable'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Iconsax.activity,
                      title: AppStrings.ACTIVE_PRODUCTS_INACTIVE,
                      value: controller.isSortActive.value,
                      onTap: () => controller.onChangeSort('active'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Icons.shopping_cart_outlined,
                      title: AppStrings.IN_STOCK_AND_OUT_OF_STOCK,
                      value: controller.isSortInStock.value,
                      onTap: () => controller.onChangeSort('inStock'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Icons.monetization_on_outlined,
                      title: AppStrings.PRICE,
                      value: controller.isSortPrice.value,
                      onTap: () => controller.onChangeSort('price'),
                    )),
                const SpaceH4(),
                Obx(
                  () => ToggleTileComponent(
                    icon: controller.isSortAscending.value
                        ? CupertinoIcons.sort_up
                        : CupertinoIcons.sort_down,
                    title: controller.isSortAscending.value
                        ? AppStrings.ASCENDING_ORDER
                        : AppStrings.DESCENDING_ORDER,
                    value: controller.isSortAscending.value,
                    onChanged: controller.isSortAscending,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(
            bottom: 30,
            left: 10,
            right: 10,
          ),
          child: CustomButton(
            buttonType: ButtonType.textWithImage,
            color: context.primaryColor,
            textColor: context.buttonTextColor,
            text: AppStrings.APPLY,
            image: Icon(
              Icons.arrow_back,
              color: context.buttonTextColor,
              size: Sizes.ICON_SIZE_24,
            ),
            onPressed: controller.applySortFilters,
            hasInfiniteWidth: false,
            verticalMargin: 0,
          ),
        ),
      ),
    );
  }

  void _showSettingSheet(BuildContext context, String title) {
    CustomSnackBar.showCustomBottomSheet(
      color: context.scaffoldBackgroundColor,
      bottomSheet: Scaffold(
        appBar: AppBar(
            backgroundColor: context.scaffoldBackgroundColor,
            title: Text(
              title,
              style: context.titleLarge,
            )),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Sizes.PADDING_14, vertical: Sizes.PADDING_6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => ToggleTileComponent(
                    icon: Iconsax.receipt,
                    title: AppStrings.NAME,
                    value: controller.isShowName.value,
                    onChanged: null,
                  ),
                ),
                const SpaceH4(),
                Obx(() => ToggleTileComponent(
                      icon: Iconsax.document_text,
                      title: AppStrings.DESCRIPTION,
                      value: controller.isShowDescription.value,
                      onChanged: null,
                    )),
                const SpaceH4(),
                Obx(
                  () => ToggleTileComponent(
                    icon: Iconsax.forward_item,
                    title: AppStrings.PARENT_CATEGORY,
                    value: controller.isShowParentCategoryTemp.value,
                    onChanged: controller.isShowParentCategoryTemp,
                  ),
                ),
                const SpaceH4(),
                Obx(
                  () => ToggleTileComponent(
                    icon: Iconsax.activity,
                    title: AppStrings.ACTIVE_INACTIVE_PRODUCT,
                    value: controller.isShowActiveTemp.value,
                    onChanged: controller.isShowActiveTemp,
                  ),
                ),
                const SpaceH4(),
                Obx(
                  () => ToggleTileComponent(
                    icon: CupertinoIcons.bell,
                    title: AppStrings.INDICATORS,
                    value: controller.isShowIndicatorsTemp.value,
                    onChanged: controller.isShowIndicatorsTemp,
                  ),
                ),
                const SpaceH4(),
                Obx(
                  () => ToggleTileComponent(
                    icon: Icons.sell_outlined,
                    title: AppStrings.SALES_PRICE,
                    value: controller.isShowSalePriceTemp.value,
                    onChanged: controller.isShowSalePriceTemp,
                  ),
                ),
                const SpaceH4(),
                Obx(
                  () => ToggleTileComponent(
                    icon: Icons.image_outlined,
                    title: AppStrings.IMAGE,
                    value: controller.isShowImageTemp.value,
                    onChanged: controller.isShowImageTemp,
                  ),
                ),
                const SpaceH4(),
                CustomTextFormField(
                  autofocus: false,
                  controller: controller.combinedPdiDatePickerController,
                  labelText: 'Extract Combined PDI Date',
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      controller.combinedPdiDatePickerController.text =
                          formattedDate;
                      controller.fromPdiDateText.value = formattedDate;
                    }
                  },
                  prefixIconData: Icons.date_range_outlined,
                  textInputAction: TextInputAction.next,
                ),
                const SpaceH4(),
                Obx(() => controller.fromPdiDateText.isNotEmpty
                    ? CustomButton(
                        buttonType: ButtonType.loading,
                        color: context.primaryColor,
                        isLoading: controller.isLoading.value,
                        textColor: context.buttonTextColor,
                        text: 'Download PDI File',
                        image: Icon(
                          Icons.save,
                          color: context.buttonTextColor,
                          size: Sizes.ICON_SIZE_24,
                        ),
                        onPressed: () {
                          controller.downloadAndDisplayPDIFile(context);
                        },
                        hasInfiniteWidth: true,
                        verticalMargin: 0,
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(
            bottom: 30,
            left: 10,
            right: 10,
          ),
          child: CustomButton(
            buttonType: ButtonType.textWithImage,
            color: context.primaryColor,
            textColor: context.buttonTextColor,
            text: AppStrings.APPLY,
            image: Icon(
              Icons.save,
              color: context.buttonTextColor,
              size: Sizes.ICON_SIZE_24,
            ),
            onPressed: controller.onApplyDisplaySetting,
            hasInfiniteWidth: false,
            verticalMargin: 0,
          ),
        ),
      ),
    );
  }
}
