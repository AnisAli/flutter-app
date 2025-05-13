import 'package:otrack/views/customers/components/customer_card.dart';
import '../../../exports/index.dart';
import '../../../widgets/templates/action_buttons/menu_button.dart';

class Customers extends GetView<CustomerController> {
  static const String routeName = '/customers';

  const Customers({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      extendedAppBar: _extendedAppBar(context),
      scaffoldKey: controller.scaffoldKey,
      padding: Sizes.PADDING_12,
      actionButton: _buildAddNewCustomerButton(context),
      children: [
        const SpaceH12().sliverToBoxAdapter,
        _buildCustomerList(),
        const SpaceH8().sliverToBoxAdapter,
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildCustomerList() {
    return SlidableAutoCloseBehavior(
      child: PagedSliverGrid<int, CustomerModel>(
        pagingController: controller.customersPaginationKey,
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
        builderDelegate: PagedChildBuilderDelegate<CustomerModel>(
          animateTransitions: true,
          itemBuilder: (context, CustomerModel customer, _) {
            return controller.customersPaginationKey.itemList!.isEmpty
                ? const ProductShimmer()
                : Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.5,
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) async {},
                          backgroundColor: (customer.isActive ?? false)
                              ? Colors.red
                              : context.primary,
                          foregroundColor: Colors.white,
                          //icon: Icons.archive,
                          label: (customer.isActive ?? false)
                              ? 'Inactive'
                              : 'Active',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            Get.toNamed(AppRoutes.ADD_CUSTOMER,
                                arguments: customer);
                          },
                          backgroundColor: Colors.yellow.shade800,
                          foregroundColor: Colors.white,
                          //icon: Icons.save,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: InkWell(
                        onTap: () =>
                            Get.toNamed(AppRoutes.CUSTOMER_DETAIL, arguments: {
                              'viaCustomers': true,
                              'customer': customer,
                            }),
                        child: CustomerCard(
                            customer: customer, showActiveToggle: true)));
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
          firstPageProgressIndicatorBuilder: (_) => const ProductShimmer(),
        ),
      ),
    );
  }

  Widget _extendedAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const MenuButton(),
            _buildAddNewCustomerButton(context),
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
              _showFilterSheet(context, AppStrings.FILTER);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list,
                  size: 22,
                  color: Colors.white,
                ),
                const SpaceW4(),
                Text(AppStrings.FILTER,
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
              AppStrings.SORT_BY,
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
        ],
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
            onSuffixTap: controller.onClearSearchBar,
            onChanged: controller.searchCustomers,
          ),
        ),
      ],
    );
  }

  Widget _buildAddNewCustomerButton(BuildContext context) {
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
      onPressed: () => Get.toNamed(AppRoutes.ADD_CUSTOMER),
      verticalMargin: 0,
      textColor: Colors.white,
      text: AppStrings.ADD_CUSTOMER,
      hasInfiniteWidth: false,
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
                      title: AppStrings.OPEN_BALANCE,
                      value: controller.isSortOpenBalance.value,
                      onTap: () => controller.onChangeSort('openBalance'),
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

  void _showFilterSheet(BuildContext context, String title) {
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
}
