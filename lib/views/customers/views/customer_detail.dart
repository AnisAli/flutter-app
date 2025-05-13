import '../../../exports/index.dart';
import '../../../widgets/templates/action_buttons/menu_button.dart';
import '../components/customer_card.dart';

class CustomerDetail extends GetView<CustomerDetailController> {
  static const String routeName = '/customerDetail';

  const CustomerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.viaCustomers
        ? _buildViaCustomerPage(context)
        : _buildDirectTransactionsPage(context);
  }

  Widget _buildDirectTransactionsPage(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      padding: Sizes.PADDING_12,
      scaffoldKey: controller.scaffoldKey,
      extendedAppBar: _extendedAppBar(context),
      // physics: const NeverScrollableScrollPhysics(),
      children: [
        const SpaceH12().sliverToBoxAdapter,
        _buildAllTabList(),
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildViaCustomerPage(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      overscroll: true,
      showThemeButton: false,
      showMenuButton: false,
      simpleAppBar: _buildSimpleAppBar(context),
      children: [
        _buildCustomerInfoContainer(context).sliverToBoxAdapter,
        const SpaceH8().sliverToBoxAdapter,
        _buildBigInfoContainers(context).sliverToBoxAdapter,
        const SpaceH4().sliverToBoxAdapter,
        _buildSearchField(context).sliverToBoxAdapter,
        const SpaceH8().sliverToBoxAdapter,
        _buildOptionsBar(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        _buildTabs(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        _buildAllTabList(),
      ],
    ).scaffold();
  }

  Widget _extendedAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const MenuButton(),
            _buildQuickInvoiceButton(context),
          ],
        ),
        _buildSearchField(context),
        _buildOptionsBar(context),
      ],
    );
  }

  Widget _buildQuickInvoiceButton(BuildContext context) {
    return CustomButton(
      buttonType: ButtonType.textWithImage,
      constraints: const BoxConstraints(minWidth: 100),
      color: context.primaryColor,
      image: Icon(
        Icons.add,
        color: context.buttonTextColor,
      ),
      buttonPadding: const EdgeInsets.symmetric(
        vertical: Sizes.PADDING_8,
        horizontal: Sizes.PADDING_12,
      ),
      customTextStyle: context.titleMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: context.buttonTextColor,
      ),
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
                    _buildCustomerSearchField(context).sliverToBoxAdapter,
                    const SpaceH12().sliverToBoxAdapter,
                    _buildCustomerList(),
                    const SpaceH12().sliverToBoxAdapter,
                  ],
                ),
              );
            });
      },
      verticalMargin: 0,
      textColor: Colors.white,
      text: AppStrings.NEW,
      hasInfiniteWidth: false,
    );
  }

  Widget _buildCustomerList() {
    return PagedSliverGrid<int, CustomerModel>(
      pagingController: controller.customerController.customersPaginationKey,
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
          return controller
                  .customerController.customersPaginationKey.itemList!.isEmpty
              ? const CircularProgressIndicator.adaptive()
              : InkWell(
                  onTap: () => controller.onCustomerSelection(customer),
                  child:
                      CustomerCard(customer: customer, showActiveToggle: true));
        },
        firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
          error: controller.customerController.customersPaginationKey.error,
          onTryAgain:
              controller.customerController.customersPaginationKey.refresh,
        ),
        noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
          onTryAgain:
              controller.customerController.customersPaginationKey.refresh,
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

  Widget _buildCustomerSearchField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: controller.customerController.searchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppStrings.SEARCH_HINT_TEXT,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: controller.customerController.onClearSearchBar,
            onChanged: controller.customerController.searchCustomers,
          ),
        ),
      ],
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
                      controller: controller.paymentTypeFilterController,
                      showSearchBox: false,
                      title: AppStrings.PAYMENT_TYPE,
                      prefixIcon: Icons.payment,
                      onChange: controller.onPaymentTypeFilterChange,
                      items: controller.paymentTypeFilters,
                      selectedItem: controller.paymentTypeFilter,
                    ),
                    const SpaceH4(),
                    CustomTextFormField(
                      autofocus: false,
                      controller: controller.startDatePickerController,
                      labelText: AppStrings.START_DATE,
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
                          controller.startDatePickerController.text =
                              formattedDate;
                        }
                      },
                      prefixIconData: Icons.date_range_outlined,
                      textInputAction: TextInputAction.next,
                    ),
                    const SpaceH4(),
                    CustomTextFormField(
                      autofocus: false,
                      controller: controller.endDatePickerController,
                      labelText: AppStrings.END_DATE,
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
                          controller.endDatePickerController.text =
                              formattedDate;
                        }
                      },
                      prefixIconData: CupertinoIcons.calendar_today,
                      textInputAction: TextInputAction.next,
                    ),
                    const SpaceH4(),
                    CustomTextFormField(
                      autofocus: false,
                      controller: controller.minAmountController,
                      labelText: AppStrings.MIN_AMOUNT,
                      prefixIconData: Icons.monetization_on_outlined,
                      textInputAction: TextInputAction.next,
                    ),
                    const SpaceH4(),
                    CustomTextFormField(
                      autofocus: false,
                      controller: controller.maxAmountController,
                      labelText: AppStrings.MAX_AMOUNT,
                      prefixIconData: Icons.monetization_on,
                      textInputAction: TextInputAction.next,
                    ),
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
                Obx(() => CheckTileComponent(
                      icon: Icons.date_range,
                      title: AppStrings.DATE,
                      value: controller.isSortDate.value,
                      onTap: () => controller.onChangeSort('date'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Icons.date_range_outlined,
                      title: AppStrings.MODIFIED_DATE,
                      value: controller.isSortModifiedDate.value,
                      onTap: () => controller.onChangeSort('modifiedDate'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Icons.category_outlined,
                      title: AppStrings.TRANSACTION_TYPE,
                      value: controller.isSortTransactionType.value,
                      onTap: () => controller.onChangeSort('transactionType'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Icons.numbers,
                      title: AppStrings.TRANSACTION_NUM,
                      value: controller.isSortTransactionNum.value,
                      onTap: () => controller.onChangeSort('transactionNumber'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Icons.monetization_on_outlined,
                      title: AppStrings.AMOUNT,
                      value: controller.isSortAmount.value,
                      onTap: () => controller.onChangeSort('amount'),
                    )),
                const SpaceH4(),
                Obx(() => CheckTileComponent(
                      icon: Icons.money_off_csred,
                      title: AppStrings.AMOUNT_DUE,
                      value: controller.isSortAmountDue.value,
                      onTap: () => controller.onChangeSort('balance'),
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

  Widget _buildOptionsBar(BuildContext context) {
    return Obx(() => TransactionSummaryOptionBar(
          onPressedOption1: () => _showFilterSheet(context, AppStrings.FILTER),
          onPressedOption2: () => _showSortSheet(context, AppStrings.SORT_BY),
          isContrastColor: controller.isFilterApplied.value,
        ));
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
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

  Widget _buildSearchField(BuildContext context) {
    String searchHintText = AppStrings.SEARCH;
    if (controller.tabIndex == 4) {
      searchHintText += ' Sales Order';
    } else if (controller.tabIndex == 1) {
      searchHintText += ' Invoice';
    } else if (controller.tabIndex == 2) {
      searchHintText += ' Credit Memo';
    } else if (controller.tabIndex == 3) {
      searchHintText += ' Payment';
    } else if (controller.tabIndex == 0) {
      searchHintText += ' Transaction Number';
    }
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: controller.searchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: searchHintText,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: controller.onClearSearchBar,
            onChanged: controller.searchByTransactionNumber,
          ),
        ),
      ],
    );
  }

  Widget _buildAllTabList() {
    return PagedSliverList(
      shrinkWrapFirstPageIndicators: true,
      pagingController: controller.transactionsPaginationKey,
      builderDelegate: PagedChildBuilderDelegate<TransactionSummaryModel>(
        animateTransitions: true,
        itemBuilder: (context, TransactionSummaryModel transaction, _) {
          return controller.transactionsPaginationKey.itemList!.isEmpty
              ? const ProductShimmer()
              : TransactionSummaryCard(transactionSummaryModel: transaction);
        },
        firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
          error: controller.transactionsPaginationKey.error,
          onTryAgain: controller.transactionsPaginationKey.refresh,
        ),
        noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
          onTryAgain: controller.transactionsPaginationKey.refresh,
        ),
        newPageProgressIndicatorBuilder: (_) =>
            const CupertinoActivityIndicator(
          radius: Sizes.ICON_SIZE_16,
        ),
        firstPageProgressIndicatorBuilder: (_) => const ProductShimmer(),
      ),
    );
  }

  Widget _buildBigInfoContainers(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.CUSTOMER_OPEN_BALANCE_REPORT,
                arguments: {'customer': controller.argsCustomer.value}),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: context.cardColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopify_outlined,
                    color: context.primary,
                    size: 60,
                  ),
                  Expanded(
                      flex: 1,
                      child: Obx(
                        () => Column(
                          children: [
                            Text(
                              AppStrings.OPEN_BALANCE,
                              style: context.titleMedium,
                            ),
                            controller.isLoading.value
                                ? CircularProgressIndicator(
                                    color: context.primary,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    "\$${controller.argsCustomer.value.openBalance ?? 0.00}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: context.titleLarge,
                                  ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        const SpaceW12(),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: context.cardColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description,
                  color: context.primary,
                  size: 60,
                ),
                Obx(() => Column(
                      children: [
                        Text(
                          AppStrings.OPEN_INVOICES,
                          style: context.titleMedium,
                        ),
                        controller.isLoading.value
                            ? CircularProgressIndicator(
                                color: context.primary,
                                strokeWidth: 2,
                              )
                            : Text(
                                "${controller.openInvoices.toInt()}",
                                style: context.titleLarge,
                              )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfoContainer(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCustomerInfoDisplay(context),
          _buildCustomerIconOptions(context),
        ],
      ),
    );
  }

  Widget _buildCustomerIconOptions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () async => controller.openLauncher('tel'),
              child: _buildAvatarIcon(context, Icons.phone),
            ),
            const SpaceW8(),
            InkWell(
              onTap: () async => controller.openLauncher('sms'),
              child: _buildAvatarIcon(context, Icons.chat_outlined),
            ),
          ],
        ),
        const SpaceH8(),
        Row(
          children: [
            InkWell(
                onTap: controller.onPressEditButton,
                child: _buildAvatarIcon(context, Icons.edit_outlined)),
            const SpaceW8(),
            _buildPopUpMenuButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildPopUpMenuButton(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          // row has two child icon and text.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.flash_on,
                color: context.iconColor1,
                size: Sizes.ICON_SIZE_20,
              ),
              const SpaceW8(),
              Text(
                AppStrings.NEW_INVOICE,
                style: context.bodyMedium.copyWith(fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          // row has two child icon and text.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.note_alt_outlined,
                color: context.iconColor1,
                size: Sizes.ICON_SIZE_20,
              ),
              const SpaceW8(),
              Text(
                AppStrings.CREDIT_MEMO,
                style: context.bodyMedium.copyWith(fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      ],
      onSelected: controller.onSelectedPopupMenuItem,
      offset: const Offset(0, 40),
      color: context.scaffoldBackgroundColor,
      elevation: 1,
      child: _buildAvatarIcon(context, CupertinoIcons.add),
    );
  }

  Widget _buildCustomerInfoDisplay(BuildContext context) {
    RxString address = "".obs;
    if (controller.argsCustomer.value.address1 != null) {
      address.value +=
          "${controller.argsCustomer.value.address1?.toUpperCase()}";
    }
    if (controller.argsCustomer.value.city != null) {
      address.value +=
          "${address.isNotEmpty ? ", " : ""}${controller.argsCustomer.value.city?.toUpperCase()}";
    }
    if (controller.argsCustomer.value.state != null) {
      address.value +=
          "${address.isNotEmpty ? ", " : ""}${controller.argsCustomer.value.state?.toUpperCase()}";
    }
    if (controller.argsCustomer.value.postalCode != null) {
      address.value +=
          "${address.isNotEmpty ? ", " : ""}${controller.argsCustomer.value.postalCode?.toUpperCase()}";
    }
    return Flexible(
      flex: 1,
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.argsCustomer.value.companyName.toString(),
                style: context.bodyText1.copyWith(fontSize: 14),
              ),
              Text(
                address.value,
                style: context.bodyText1.copyWith(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                controller.argsCustomer.value.email ?? "",
                style: context.bodyText1.copyWith(fontSize: 14),
              ),
              Text(
                controller.argsCustomer.value.phoneNo ?? "",
                style: context.bodyText1.copyWith(fontSize: 14),
              ),
            ],
          )),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
        primary: true,
        pinned: true,
        backgroundColor: context.scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: context.iconColor1, //change your color here
        ),
        centerTitle: true,
        title: Obx(
          () => Text(
            controller.argsCustomer.value.customerName.toString(),
            style: context.titleLarge
                .copyWith(color: context.primary, fontSize: Sizes.TEXT_SIZE_22),
          ),
        ));
  }

  Widget _buildAvatarIcon(BuildContext context, IconData data) {
    IconData iconData = data;
    return CircleAvatar(
      radius: 16,
      backgroundColor: context.primaryColor,
      child: Icon(
        iconData,
        size: Sizes.ICON_SIZE_18,
        color: Colors.white,
      ),
    );
  }
}
