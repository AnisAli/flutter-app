import '../../../exports/index.dart';

class PaymentReceived extends GetView<PaymentReceivedController> {
  static const String routeName = '/paymentReceived';

  const PaymentReceived({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      showThemeButton: false,
      showMenuButton: true,
      //extendedAppBar: _extendedAppBar(context),
      scaffoldKey: controller.scaffoldKey,
      padding: Sizes.PADDING_12,
      //customBottomNavigationBar: _buildButton(context),
      children: [
        _buildCustomerBalanceDue(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        _buildTextFields(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
      ],
    ).scaffoldWithDrawer();
  }

  /*Widget _extendedAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const MenuButton(),
            //_buildQuickInvoiceButton(context),
          ],
        ),
        //_buildSearchField(context),
        //_buildOptionsBar(context),
      ],
    );
  }*/

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

  Widget bottomSheet(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFields(BuildContext context) {
    return Obx(
      () => Form(
        key: controller.formKey,
        child: Column(
          children: [
            //Customer Filter
            CustomTextFormField(
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
            CustomTextFormField(
              readOnly: true,
              isRequired: true,
              labelText: 'Payment Amount',
              textAlign: TextAlign.left,
              controller: controller.paymentAmountController,
              validator: controller.paymentAmountValidator,
              autofocus: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onTap: () {
                CustomSnackBar.showCustomBottomSheet(
                  color: context.scaffoldBackgroundColor,
                  bottomSheet: Scaffold(
                      resizeToAvoidBottomInset: true,
                      bottomNavigationBar: _buildAmountCredit(context),
                      appBar: AppBar(
                        backgroundColor: context.scaffoldBackgroundColor,
                        title: Text(
                          AppStrings.INVOICE,
                          style: context.titleLarge,
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.check,
                            color: context.primaryColor,
                          ),
                          onPressed: Get.back,
                        ),
                      ),
                      body: bottomSheet(context)),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDropDownField<String>(
                    controller: controller.paymentMethodController,
                    //showSearchBox: true,
                    title: 'Payment Method',
                    //prefixIcon: Icons.person,
                    onChange: controller.onPaymentMethodChange,
                    items: AppStrings.PAYMENT_METHODS,
                    selectedItem: controller.paymentMethod,
                    verticalPadding: 10,
                  ),
                ),
                const SpaceW8(),
                Expanded(
                  child: CustomDropDownField<String>(
                    isRequired: true,
                    controller: controller.fromAccountController,
                    title: 'From Account',
                    //prefixIcon: Icons.person,
                    onChange: controller.onFromAccountChange,
                    items: controller.fromAccounts,
                    selectedItem: controller.fromAccount,
                    verticalPadding: 10,
                  ),
                ),
              ],
            ),
            CustomTextFormField(
              enabled: controller.isEnabled.value,
              autofocus: false,
              controller: controller.datePickerController,
              labelText: 'Payment Date',
              onTap: () async {
                if (controller.isEnabled.value == false) {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    controller.datePickerController.text = formattedDate;
                  }
                }
              },
              prefixIconData: Icons.date_range_outlined,
              textInputAction: TextInputAction.next,
            ),
            CustomTextFormField(
              enabled: controller.isEnabled.value,
              labelText: 'Reference Number',
              textAlign: TextAlign.left,
              controller: controller.referenceNumberController,
              validator: controller.referenceNumberValidator,
              autofocus: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),
            CustomTextFormField(
              labelText: 'Comment/Note',
              controller: controller.commentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              maxLength: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.primaryColor,
          child: Row(
            children: [
              const SpaceW4(),
              Expanded(
                flex: 3,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '${AppStrings.DATE.capitalize}\n${AppStrings.INVOICE}',
                    textAlign: TextAlign.center,
                    style: context.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SpaceW4(),
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '${AppStrings.AMOUNT.capitalize}\nDUE AMOUNT',
                    textAlign: TextAlign.center,
                    style: context.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '\nAPPLY AMOUNT',
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: context.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          itemCount: controller.unpaidInvoices.unpaidInvoices!.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.unpaidInvoices.unpaidInvoices![index]['isCheck'] =
                  !(controller.unpaidInvoices.unpaidInvoices![index]
                      ['isCheck']);
              controller.isChecked(
                controller.unpaidInvoices.unpaidInvoices![index]['isCheck'],
                //index,
                controller.unpaidInvoices.unpaidInvoices![index],
              );
            },
            child: GetBuilder(
              init: controller,
              id: 'creditAmountTextField',
              builder: (_) => Container(
                color: controller.unpaidInvoices.unpaidInvoices![index]
                            ['isCheck'] ==
                        true
                    ? AppColors.orangeShade1
                    : Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 7.5),
                margin: const EdgeInsets.symmetric(vertical: 2.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SpaceW4(),
                        Expanded(
                          flex: 3,
                          child: Container(
                            //height: 50,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              '${controller.unpaidInvoices.unpaidInvoices![index]['invoiceDate']}\n${controller.unpaidInvoices.unpaidInvoices![index]['invoiceNo']}',
                              textAlign: TextAlign.center,
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SpaceW4(),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 50,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text.rich(
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackShade9.withOpacity(0.75),
                              ),
                              TextSpan(
                                text:
                                    '${controller.unpaidInvoices.unpaidInvoices![index]['totalAmount']}\n',
                                children: [
                                  TextSpan(
                                    text:
                                        '${controller.unpaidInvoices.unpaidInvoices![index]['amountDue'].toStringAsFixed(2)}',
                                    style: context.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SpaceW4(),
                        Expanded(
                          flex: 4,
                          child: CustomTextFormField(
                            autofocus: false,
                            textAlign: TextAlign.left,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            showClearButton: controller
                                    .unpaidInvoices
                                    .unpaidInvoices![index]
                                        ['creditTextController']
                                    .text
                                    .isEmpty
                                ? false
                                : true,
                            onSuffixTap: () {
                              controller.unpaidInvoices.unpaidInvoices![index]['isCheck'] = false;
                              controller.isChecked(
                                false,
                                //index,
                                controller
                                    .unpaidInvoices.unpaidInvoices![index],
                              );
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            labelText: controller
                                    .unpaidInvoices
                                    .unpaidInvoices![index]
                                        ['creditTextController']
                                    .text
                                    .isEmpty
                                ? AppStrings.AMOUNT
                                : '',
                            controller: controller.unpaidInvoices
                                .unpaidInvoices![index]['creditTextController'],
                            onChanged: (value) {
                              controller.unpaidInvoices.unpaidInvoices![index]
                                  ['creditAmount'] = double.parse(value);
                            },
                            onEditingComplete: () {
                              controller
                                          .unpaidInvoices
                                          .unpaidInvoices![index]
                                              ['creditTextController']
                                          .text ==
                                      ''
                                  ? controller.unpaidInvoices
                                      .unpaidInvoices![index]['isCheck'] = false
                                  : controller.unpaidInvoices
                                      .unpaidInvoices![index]['isCheck'] = true;
                              controller.amountToApply.value = 0.0;
                              for (var invoice in controller
                                  .unpaidInvoices.unpaidInvoices!) {
                                if (invoice['creditAmount'] != null) {
                                  controller.amountToApply.value +=
                                      double.parse(
                                          (invoice['creditAmount']).toString());
                                }
                              }
                              controller.paymentAmountController.text =
                                  (controller.amountToApply.value).toString();

                              controller.update(['creditAmountTextField']);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    Map<String, dynamic> rowData,
  ) {
    return InkWell(
      onTap: () {
        rowData['isCheck'] = !(rowData['isCheck']);
        controller.isChecked(
          rowData['isCheck'],
          //index,
          rowData,
        );
      },
      child: GetBuilder(
        init: controller,
        id: 'creditAmountTextField',
        builder: (_) => Container(
          color: rowData['isCheck'] == true
              ? context.fillColor
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Row(
                children: [
                  const SpaceW4(),
                  Expanded(
                    flex: 3,
                    child: Container(
                      //height: 50,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        '${rowData['invoiceDate']}\n${rowData['invoiceNo']}',
                        textAlign: TextAlign.center,
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SpaceW4(),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 50,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        '${rowData['totalAmount']}\n${rowData['amountDue'].toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SpaceW4(),
                  Expanded(
                    flex: 4,
                    child: CustomTextFormField(
                      autofocus: false,
                      textAlign: TextAlign.right,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      isRequired: true,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      labelText: 'Amount',
                      initialValue: rowData['creditAmount'] == 0.0
                          ? ''
                          : (rowData['creditAmount']).toString(),
                      //controller: controller.textControllerList[index],
                      onChanged: (value) {
                        rowData['creditAmount'] = value;
                      },
                      onEditingComplete: () {
                        controller.amountToApply.value = 0.0;
                        for (var invoice
                            in controller.unpaidInvoices.unpaidInvoices!) {
                          if (invoice['creditAmount'] != null) {
                            controller.amountToApply.value +=
                                invoice['creditAmount'];
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCredit(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(
        left: 20,
        bottom: 15,
        right: 20,
      ),
      height: 80,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: context.primaryColor,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Amount to Apply',
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SpaceH8(),
                Obx(
                  () => Text(
                    '\$${controller.amountToApply.toStringAsFixed(2)}',
                    style: context.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Credit to Apply',
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SpaceH8(),
                Obx(
                  () => Text(
                    '\$${controller.creditToApply.toStringAsFixed(2)}',
                    style: context.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ) /*Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                'Amount to Apply',
                style: context.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceH8(),
              Obx(
                () => Text(
                  '\$${controller.amountToApply.toStringAsFixed(2)}',
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Credit to Apply',
                style: context.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceH8(),
              Obx(
                () => Text(
                  '\$${controller.creditToApply.toStringAsFixed(2)}',
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )*/
        ;
  }

  Widget _buildCustomerBalanceDue(BuildContext context) {
    return Column(
      children: [
        Text(
          'Customer',
          style: context.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        GetBuilder(
          init: controller,
          id: 'text',
          builder: (_) {
            return Text(
              controller.customerFilterController.text.isEmpty
                  ? ''
                  : controller.customerFilterController.text,
              style: context.titleLarge,
            );
          },
        ),
        const SpaceH16(),
        Text(
          'Balance Due',
          style: context.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        GetBuilder(
          init: controller,
          id: 'openBalance',
          builder: (_) {
            return Text(
              (controller.unpaidInvoices.openBalance?.toStringAsFixed(2)) ??
                  '0.0',
              style: context.titleLarge,
            );
          },
        ),
      ],
    );
  }

/*Widget _buildButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
      child: CustomButton(
        //buttonType: ButtonType.textWithImage,
        color: context.primaryColor,
        textColor: context.buttonTextColor,
        text: 'Apply Credit',
        onPressed: controller.onApplyCreditClick,
        hasInfiniteWidth: false,
        verticalMargin: 0,
      ),
    );
  }*/
}
