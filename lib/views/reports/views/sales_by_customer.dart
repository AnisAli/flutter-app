import '../../../exports/index.dart';
import '../../../widgets/templates/action_buttons/menu_button.dart';

class SalesByCustomer extends GetView<SalesByCustomerController> {
  static const String routeName = '/salesByCustomer';

  const SalesByCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      pinAppBar: true,
      showMenuButton: false,
      showThemeButton: false,
      physics: NeverScrollableScrollPhysics(),
      simpleAppBar: _buildSimpleAppBar(context),
      scaffoldKey: controller.scaffoldKey,
      padding: Sizes.PADDING_12,
      children: [
        const SpaceH8().sliverToBoxAdapter,
        _buildDateCustomerProductFilter(context).sliverToBoxAdapter,
        const SpaceH16().sliverToBoxAdapter,
        //_buildReport(context).sliverToBoxAdapter,
        controller
            .obx(
              (state) => controller.reportData.isEmpty
                  //? const SizedBox()
                  ? const EmptyListIndicator(
                      title: AppStrings.NO_REPORT_FOUND,
                    )
                  : _buildGenerateButton(),
            )
            .sliverToBoxAdapter,
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.onBackground, //change your color here
      ),
      pinned: true,
      centerTitle: true,
      title: Text(
        AppStrings.SALES_BY_CUSTOMER,
        style: context.titleMedium,
      ),
    );
  }

  Widget _extendedAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: const [
            MenuButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    TextEditingController searchTextController,
    Function(String)? search,
    Function()? onClearSearchBar,
  ) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: searchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppStrings.SEARCH_HINT_TEXT,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: onClearSearchBar,
            onChanged: search,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerList() {
    return PagedSliverGrid<int, CustomerModel>(
      pagingController: controller.customersPaginationKey,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.getResponsiveValue(
          mobile: 1,
          tablet: 2,
          desktop: 3,
        ),
        mainAxisExtent: Sizes.HEIGHT_50,
        crossAxisSpacing: Sizes.PADDING_8,
      ),
      builderDelegate: PagedChildBuilderDelegate<CustomerModel>(
        animateTransitions: true,
        itemBuilder: (context, CustomerModel customer, _) {
          return controller.customersPaginationKey.itemList!.length == 1
              ? const SizedBox(
                  height: Sizes.HEIGHT_500,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              : Obx(
                  () {
                    final isSelected =
                        controller.selectedCustomer.value == customer;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.PADDING_8),
                      child: ListTile(
                        onTap: () {
                          controller.selectedCustomer.value = customer;
                          controller.onCustomerFilterChange(
                              customer.customerName ?? customer.companyName!);
                          Get.back();
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: Sizes.PADDING_16),
                        minVerticalPadding: 0,
                        visualDensity: const VisualDensity(vertical: -2.5),
                        selectedTileColor: context.fillColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
                        ),
                        title: Row(
                          children: [
                            isSelected
                                ? Icon(
                                    Icons.radio_button_checked_rounded,
                                    size: Sizes.ICON_SIZE_22,
                                    color: context.primaryColor,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked_rounded,
                                    size: Sizes.ICON_SIZE_22,
                                    color: context.backgroundColor,
                                  ),
                            const SpaceW12(),
                            Text(
                              customer.customerName ?? customer.companyName!,
                              style: context.bodyLarge.copyWith(
                                color: context.bodyLarge.color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
        firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
          error: controller.customersPaginationKey.error,
          onTryAgain: controller.customersPaginationKey.refresh,
        ),
        noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
          onTryAgain: controller.customersPaginationKey.refresh,
        ),
        newPageProgressIndicatorBuilder: (_) =>
            const CupertinoActivityIndicator(
          radius: Sizes.ICON_SIZE_16,
        ),
        firstPageProgressIndicatorBuilder: (_) =>
            const CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _buildProductList() {
    return PagedSliverGrid<int, ProductModel>(
      pagingController: controller.productsPaginationKey,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.getResponsiveValue(
          mobile: 1,
          tablet: 2,
          desktop: 3,
        ),
        mainAxisExtent: Sizes.HEIGHT_50,
        crossAxisSpacing: Sizes.PADDING_8,
      ),
      builderDelegate: PagedChildBuilderDelegate<ProductModel>(
        animateTransitions: true,
        itemBuilder: (context, ProductModel product, _) {
          return controller.productsPaginationKey.itemList!.length == 1
              ? const SizedBox(
                  height: Sizes.HEIGHT_500,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              : Obx(() {
                  final isSelected =
                      controller.selectedProduct.value == product;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.PADDING_8),
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () {
                        controller.selectedProduct.value = product;
                        controller.onProductFilterChange(product.productName!);
                        Get.back();
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.PADDING_16),
                      minVerticalPadding: 0,
                      visualDensity: const VisualDensity(vertical: -2.5),
                      selectedTileColor: context.fillColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
                      ),
                      title: Row(
                        children: [
                          isSelected
                              ? Icon(
                                  Icons.radio_button_checked_rounded,
                                  size: Sizes.ICON_SIZE_22,
                                  color: context.primaryColor,
                                )
                              : Icon(
                                  Icons.radio_button_unchecked_rounded,
                                  size: Sizes.ICON_SIZE_22,
                                  color: context.backgroundColor,
                                ),
                          const SpaceW12(),
                          Expanded(
                            flex: 3,
                            // Adjust the flex value as needed
                            child: Text(
                              product.productName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.bodyLarge.copyWith(
                                color: context.bodyLarge.color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
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
        firstPageProgressIndicatorBuilder: (_) =>
            const CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Obx(
      () => CustomRoundButton(
        text: AppStrings.GENERATE_PDF,
        contrast: true,
        isLoading: controller.isLoading.value,
        onPressed: controller.getPDF,
      ),
    );
  }

  Widget _buildDateCustomerProductFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Date Filter
        CustomDropDownField(
          controller: controller.dateController,
          showSearchBox: false,
          title: AppStrings.DATE,
          onChange: controller.onDateChange,
          items: AppStrings.DATES,
          selectedItem: controller.date,
          prefixIcon: Iconsax.calendar5,
        ),
        const SpaceH8(),
        //Customer Filter
        CustomTextFormField(
          autofocus: false,
          controller: controller.customerFilterController,
          labelText: AppStrings.CUSTOMER,
          prefixIconData: Icons.person,
          suffixIconData: Iconsax.arrow_down5,
          //onChanged: controller.onCustomerFilterChange,
          readOnly: true,
          onTap: () {
            showModalBottomSheet(
              backgroundColor: context.scaffoldBackgroundColor,
              context: context,
              builder: (builder) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomScrollView(
                    slivers: [
                      const SpaceH12().sliverToBoxAdapter,
                      _buildSearchField(
                        context,
                        controller.customerSearchTextController,
                        controller.searchCustomers,
                        controller.onClearCustomerSearchBar,
                      ).sliverToBoxAdapter,
                      const SpaceH12().sliverToBoxAdapter,
                      _buildCustomerList(),
                      const SpaceH12().sliverToBoxAdapter,
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SpaceH8(),
        //Product Filter
        CustomTextFormField(
          autofocus: false,
          controller: controller.productFilterController,
          labelText: AppStrings.PRODUCT,
          prefixIconData: Icons.inventory,
          suffixIconData: Iconsax.arrow_down5,
          //onChanged: controller.onCustomerFilterChange,
          readOnly: true,
          onTap: () {
            showModalBottomSheet(
              backgroundColor: context.scaffoldBackgroundColor,
              context: context,
              builder: (builder) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomScrollView(
                    slivers: [
                      const SpaceH12().sliverToBoxAdapter,
                      _buildSearchField(
                        context,
                        controller.productSearchTextController,
                        controller.searchProducts,
                        controller.onClearProductSearchBar,
                      ).sliverToBoxAdapter,
                      const SpaceH12().sliverToBoxAdapter,
                      _buildProductList(),
                      const SpaceH12().sliverToBoxAdapter,
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SpaceH8(),
        _buildDateRangeBar(context),
        const SpaceH8(),
        _buildOptionsBar(context),
      ],
    );
  }

  Widget _buildDateRangeBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Date Range FROM and TO
        Row(
          children: [
            //FROM
            Expanded(
              child: CustomTextFormField(
                autofocus: false,
                controller: controller.fromDatePickerController,
                labelText: AppStrings.FROM,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    controller.fromDatePickerController.text = formattedDate;
                  }
                },
                onEditingComplete: controller.applyDateRange,
                prefixIconData: Icons.date_range_outlined,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SpaceW4(),
            //TO
            Expanded(
              child: CustomTextFormField(
                autofocus: false,
                controller: controller.toDatePickerController,
                labelText: AppStrings.TO,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    controller.toDatePickerController.text = formattedDate;
                  }
                },
                onEditingComplete: controller.applyDateRange,
                prefixIconData: CupertinoIcons.calendar_today,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.CALCULATE_COST_BY,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: context.primaryColor,
            ),
          ),
        ),
        InkWell(
          onTap: controller.onAverageCostClick,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => controller.isAverageCost.value == true
                      ? Row(
                          children: const [
                            Icon(
                              Iconsax.tick_circle,
                              color: Colors.green,
                            ),
                            SpaceW4(),
                          ],
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                ),
                Text(
                  AppStrings.AVERAGE_COST,
                  style: context.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SpaceW4(),
        InkWell(
          onTap: controller.onPurchaseCostClick,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => controller.isPurchaseCost.value == true
                      ? Row(
                          children: const [
                            Icon(
                              Iconsax.tick_circle,
                              color: Colors.green,
                            ),
                            SpaceW4(),
                          ],
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                ),
                Text(
                  AppStrings.PURCHASE_COST,
                  style: context.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReport(BuildContext context) {
    return controller.obx(
      (state) => Column(
        children: [
          controller.reportData.isEmpty
              ? const EmptyListIndicator(
                  title: AppStrings.NO_REPORT_FOUND,
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: Get.width * 2,
                    child: ListTileTheme(
                      horizontalTitleGap: 0.0,
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            height: 50,
                            child: _buildReportRow(
                              context,
                              {
                                'title': AppStrings.CUSTOMER,
                                'quantity': AppStrings.QTY,
                                'amount': AppStrings.AMOUNT,
                                'cogs': AppStrings.COGS,
                                'net': AppStrings.NET,
                                'gain': AppStrings.GAIN
                              },
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.reportData.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 50,
                                child: _buildReportRow(
                                  context,
                                  {
                                    'title':
                                        '${controller.reportData[index].customerName}',
                                    'quantity':
                                        (controller.reportData[index].quantity)
                                            .toString(),
                                    'amount': formatCurrency(
                                        controller.reportData[index].subTotal!),
                                    'cogs': formatCurrency(
                                        controller.reportData[index].cogs!),
                                    'net': formatCurrency(
                                        controller.reportData[index].netTotal!),
                                    'gain':
                                        '${controller.reportData[index].gain!.toStringAsFixed(2)}%'
                                  },
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            height: 50,
                            child: GetBuilder<SalesByCustomerController>(
                              id: 'totalData',
                              builder: (_) => _buildReportRow(
                                context,
                                {
                                  'title': AppStrings.TOTAL,
                                  'quantity':
                                      '${controller.totalReportData.quantity!}',
                                  'amount': formatCurrency(
                                      controller.totalReportData.subTotal!),
                                  'cogs': formatCurrency(
                                      controller.totalReportData.cogs!),
                                  'net': formatCurrency(
                                      controller.totalReportData.netTotal!),
                                  'gain':
                                      '${controller.totalReportData.gain!.toStringAsFixed(2)}%',
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          const SpaceH8(),
          controller.reportData.isEmpty
              ? const SizedBox()
              : _buildGenerateButton(),
        ],
      ),
      onLoading: Container(
        height: Get.height * 0.15,
        alignment: Alignment.center,
        child: const CustomLoader(size: 50),
      ),
    );
  }

  Widget _buildReportRow(BuildContext context, Map<String, dynamic> reportRow) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              reportRow['title'],
              textAlign: TextAlign.left,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reportRow['quantity'],
              textAlign: TextAlign.right,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reportRow['amount'],
              textAlign: TextAlign.right,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reportRow['cogs'],
              textAlign: TextAlign.right,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reportRow['net'],
              textAlign: TextAlign.right,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reportRow['gain'],
              textAlign: TextAlign.right,
              style: context.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double value) {
    final NumberFormat formatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }
}
