import '../../../exports/index.dart';

class OpenBalance extends GetView<OpenBalanceController> {
  static const String routeName = '/openBalance';

  const OpenBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      pinAppBar: true,
      showMenuButton: false,
      showThemeButton: false,
      physics: NeverScrollableScrollPhysics(),
      simpleAppBar: _buildSimpleAppBar(context),
      //extendedAppBar: _extendedAppBar(context),
      scaffoldKey: controller.scaffoldKey,
      padding: Sizes.PADDING_12,
      children: [
        const SpaceH8().sliverToBoxAdapter,
        _buildSelectCustomer(context).sliverToBoxAdapter,
        const SpaceH16().sliverToBoxAdapter,
        _buildGenerateButton().sliverToBoxAdapter,
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
        AppStrings.OPEN_BALANCE,
        style: context.titleMedium,
      ),
    );
  }

  Widget _buildSelectCustomer(BuildContext context) {
    return CustomTextFormField(
      autofocus: false,
      controller: controller.customerFilterController,
      labelText: AppStrings.SELECT_CUSTOMER,
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
                  _buildCustomerSearchField(context).sliverToBoxAdapter,
                  const SpaceH12().sliverToBoxAdapter,
                  _buildCustomerList(),
                  const SpaceH12().sliverToBoxAdapter,
                ],
              ),
            );
          },
        );
      },
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
          return controller.customersPaginationKey.itemList!.isEmpty
              ? const SizedBox(
                  height: Sizes.HEIGHT_500,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              : Obx(
                  () {
                    final isSelected = controller.selectedCustomers.contains(customer);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.PADDING_8),
                      child: ListTile(
                        onTap: () {
                          if (!isSelected) {
                          //  controller.selectedCustomers.remove(customer);
                          //  controller.updateCustomerFilterController();
                          //} else {
                            controller.selectedCustomers.clear();
                            controller.selectedCustomers.add(customer);
                            controller.updateCustomerFilterController();
                          }

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

  /*Widget _buildCustomerList() {
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
          return controller.customersPaginationKey.itemList!.isEmpty
              ? const SizedBox(
            height: Sizes.HEIGHT_500,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
              : Obx(
                () {
              final isSelected = controller.selectedCustomer.value == customer;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_8),
                child: ListTile(
                  onTap: () {
                    if (isSelected) {
                      controller.selectedCustomer.value = null;
                    } else {
                      controller.selectedCustomer.value = customer;
                    }
                    controller.updateCustomerFilterController();
                    Get.back();
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_16),
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
  }*/


  Widget _buildCustomerSearchField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: controller.customerSearchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppStrings.SEARCH_HINT_TEXT,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: controller.onClearCustomerSearchBar,
            onChanged: controller.searchCustomers,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Obx(
      () => CustomRoundButton(
        text: AppStrings.GENERATE_PDF,
        contrast: true,
        isLoading: controller.isLoading.value,
        onPressed: controller.getOpenBalancePDF,
      ),
    );
  }
}
