import 'package:otrack/views/customers/components/bluetooth_printer_sheet_card.dart';
import 'package:zefyrka/zefyrka.dart';

import '../../../exports/index.dart';
import 'package:barcode_widget/barcode_widget.dart' as bar;

class InvoiceView extends GetView<InvoiceViewController> {
  static const String routeName = '/invoiceView';

  const InvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      showBackButton: false,
      extendedAppBarSize: 56,
      customBottomNavigationBar: _customBottomBar(context),
      extendedAppBar: _extendedAppBar(context),
      children: [
        const SpaceH12().sliverToBoxAdapter,
        _buildCustomerInfoContainer(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        _buildBillToInfoContainer(context).sliverToBoxAdapter,
        const SpaceH32().sliverToBoxAdapter,
        (controller.transactionSummaryModel.transactionType != 3 &&
                controller.transactionSummaryModel.transactionType != 8)
            ? _buildProductDataTable(context).sliverToBoxAdapter
            : _buildPaymentTable(context).sliverToBoxAdapter,
        if (controller.transactionSummaryModel.transactionType != 3) ...[
          const SpaceH20().sliverToBoxAdapter,
          _buildTotalContainer(context).sliverToBoxAdapter,
        ],
        const SpaceH60().sliverToBoxAdapter,
        Obx(() => controller.memo.isNotEmpty
            ? Text(
                'Notes: ${controller.memo.value}',
                style: context.captionLarge,
              )
            : Container()).sliverToBoxAdapter,
        const SpaceH44().sliverToBoxAdapter,
        if (controller.transactionSummaryModel.transactionType == 1 ||
            controller.transactionSummaryModel.transactionType == 2)
          Center(
              child: Obx(() => Text(
                    'Customer Total Open Balance ${controller.openBalance.value}',
                    style: context.titleMedium,
                  ))).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        if ((controller.argsCustomer.value.isQBCustomer ?? false) &&
            (controller.user.value?.company?.disclaimer?.isNotEmpty ?? false))
          _buildDisclaimer(context).sliverToBoxAdapter,
      ],
    ).scaffold();
  }

  void _showSendEmailSheet(BuildContext context, String title) {
    CustomSnackBar.showCustomBottomSheet(
        enableDrag: false,
        color: context.scaffoldBackgroundColor,
        bottomSheet: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: true,
              centerTitle: true,
              backgroundColor: context.scaffoldBackgroundColor,
              title: Text(
                title,
                style: context.titleLarge,
              )),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Sizes.PADDING_14, vertical: Sizes.PADDING_6),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SpaceH4(),
                Obx(() => CustomTextFormField(
                      autofocus: false,
                      labelText: AppStrings.FROM,
                      controller: controller.fromEmailController.value,
                      readOnly: true,
                      prefixIconData: Icons.email_outlined,
                      textInputAction: TextInputAction.next,
                    )),
                const SpaceH4(),
                CustomTextFormField(
                  autofocus: false,
                  controller: controller.toEmailController,
                  labelText: AppStrings.TO,
                  prefixIconData: Icons.email,
                  textInputAction: TextInputAction.next,
                ),
                const SpaceH4(),
                CustomTextFormField(
                  autofocus: false,
                  controller: controller.ccEmailController,
                  labelText: AppStrings.CC,
                  prefixIconData: Icons.co_present,
                  textInputAction: TextInputAction.next,
                ),
                const SpaceH4(),
                CustomTextFormField(
                  autofocus: false,
                  controller: controller.bccEmailController,
                  labelText: AppStrings.BCC,
                  prefixIconData: Icons.mark_email_unread_outlined,
                  textInputAction: TextInputAction.next,
                ),
                const SpaceH40(),
                _buildNotesWidget(context),
              ]),
            ),
          ),
          bottomNavigationBar: Container(
            margin:
                const EdgeInsets.only(bottom: 30, left: 10, right: 10, top: 15),
            child: Obx(() => Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomRoundButton(
                          text: AppStrings.CANCEL,
                          contrast: true,
                          isLoadingButton: true,
                          isLoading: controller.isLoading.value,
                          onPressed: () => Get.back()),
                    ),
                    const SpaceW12(),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomRoundButton(
                          text: AppStrings.SEND,
                          contrast: false,
                          isLoadingButton: true,
                          isLoading: controller.isLoading.value,
                          onPressed: () async {
                            controller.isLoading(true);
                            await controller.sendEmailInvoice();
                            controller.isLoading(false);
                          }),
                    ),
                  ],
                )),
          ),
        ));
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.PADDING_8,
            horizontal: Sizes.PADDING_4,
          ),
          child: Text(
            "${AppStrings.DISCLAIMER}: ${controller.user.value?.company?.disclaimer ?? ''}",
            style: context.subtitle1.copyWith(
              color: DarkTheme.darkShade3,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
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
              AppStrings.MESSAGE,
              style: context.subtitle1.copyWith(
                color: DarkTheme.darkShade3,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SpaceH4(),
          ZefyrEditor(
            controller: controller.notesController,
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
    return Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalRow(context, 'Total: ',
                  '${(controller.invoiceCart.total.value != 0.0 && (controller.transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${controller.invoiceCart.total.value.toStringAsFixed(2)}'),
              _buildTotalRow(context, 'Discount: ',
                  '${(controller.invoiceCart.discountedAmount.value != 0.0 && (controller.transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${controller.invoiceCart.discountedAmount.value.toStringAsFixed(2)}'),
              _buildTotalRow(context, 'Sales Tax: ',
                  '${(controller.invoiceCart.taxedAmount.value != 0.0 && (controller.transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${controller.invoiceCart.taxedAmount.value.toStringAsFixed(2)}'),
              _buildTotalRow(
                context,
                'Net Total: ',
                '${(controller.invoiceNetTotal.value != 0.0 && (controller.transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${controller.invoiceNetTotal.value}',
              )
            ]));
  }

  Widget _buildProductDataTable(BuildContext context) {
    return Obx(() => Table(
          border: TableBorder(
              bottom: BorderSide(color: DarkTheme.darkShade3),
              horizontalInside: BorderSide(color: DarkTheme.darkShade3)),
          children: [
            TableRow(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 140,
                        child:
                            Text('DESCRIPTION\nQTY', style: context.titleSmall),
                      ),
                      Text('SRP', style: context.titleSmall),
                      Flexible(
                          child: Text('  RETAIL', style: context.titleSmall)),
                      (Get.arguments['vendor'] != null)
                          ? Flexible(
                              child: Text('COST', style: context.titleSmall))
                          : Flexible(
                              child: Text('PRICE', style: context.titleSmall)),
                      Flexible(child: Text('TOTAL', style: context.titleSmall)),
                    ],
                  ),
                ),
              ],
            ),
            for (var i = 0; i < controller.invoiceCart.items.length; i++)
              TableRow(
                decoration:
                    BoxDecoration(color: context.scaffoldBackgroundColor),
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.invoiceCart.items[i].productName ?? '',
                          style: context.captionLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 130,
                              child: Text(
                                "Qty ${controller.invoiceCart.items[i].quantity}",
                                style: context.captionLarge,
                              ),
                            ),
                            Text(
                              '${controller.invoiceCart.items[i].suggestedRetailPrice?.toStringAsFixed(2)}',
                              style: context.captionLarge,
                            ),
                            Text(
                              ((controller.invoiceCart.items[i]
                                          .suggestedRetailPrice)! *
                                      (controller
                                          .invoiceCart.items[i].quantity))
                                  .toStringAsFixed(2),
                              style: context.captionLarge,
                            ),
                            Text(
                              '${controller.invoiceCart.items[i].price}',
                              style: context.captionLarge,
                            ),
                            Text(
                              '${(controller.invoiceNetTotal.value != 0.0 && (controller.transactionSummaryModel.transactionType == 2)) ? '-' : ''}${(controller.invoiceCart.items[i].price! * controller.invoiceCart.items[i].quantity).toStringAsFixed(2)}',
                              style: context.captionLarge,
                            ),
                          ],
                        ),
                        if (controller.invoiceCart.items[i].barCode != null &&
                            controller.invoiceCart.items[i].barCode != "" &&
                            controller.isShowBarcode.value) ...[
                          const SpaceH8(),
                          SizedBox(
                            width: (controller.invoiceCart.items[i].barCode
                                                ?.length ??
                                            0)
                                        .toDouble() <
                                    10
                                ? 18.5 *
                                    (controller.invoiceCart.items[i].barCode
                                                ?.length ??
                                            0)
                                        .toDouble()
                                : 190,
                            child: bar.BarcodeWidget(
                              barcode: bar.Barcode.code128(),
                              data:
                                  controller.invoiceCart.items[i].barCode ?? '',
                              drawText: false,
                              color: context.iconColor1,
                              height: 20,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ));
  }

  Widget _buildPaymentTable(BuildContext context) {
    return Obx(() => Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.2),
          },
          border: TableBorder(
              bottom: BorderSide(color: DarkTheme.darkShade3),
              horizontalInside: BorderSide(color: DarkTheme.darkShade3)),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('INVOICE', style: context.titleSmall),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('INVOICE TOTAL', style: context.titleSmall),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('APPLIED AMOUNT', style: context.titleSmall),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('APPLIED DATE', style: context.titleSmall),
                ),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(color: context.scaffoldBackgroundColor),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    controller.paymentInvoiceId.value,
                    style: context.captionLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    controller.totalPaymentInvoiceAmount.value
                        .toStringAsFixed(2),
                    style: context.captionLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "${controller.invoiceNetTotal.value}",
                    style: context.captionLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    controller.formatDate(
                        controller.transactionSummaryModel.date ??
                            '2023-03-09'),
                    style: context.captionLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildBillToInfoContainer(BuildContext context) {
    String byString = AppStrings.INVOICE_BY;
    String totalString = AppStrings.INVOICE_TOTAL;
    String retailString = AppStrings.INVOICE_RETAIL;
    if (controller.transactionSummaryModel.transactionType == 1) {
      byString = AppStrings.INVOICE_BY;
      totalString = AppStrings.INVOICE_TOTAL;
      retailString = AppStrings.INVOICE_RETAIL;
    } else if (controller.transactionSummaryModel.transactionType == 4) {
      byString = AppStrings.ORDER_BY;
      totalString = AppStrings.ORDER_TOTAL;
      retailString = AppStrings.ORDER_RETAIL;
    } else if (controller.transactionSummaryModel.transactionType == 2) {
      byString = AppStrings.CREDIT_MEMO_BY;
      totalString = AppStrings.CREDIT_MEMO_TOTAL;
      retailString = AppStrings.CREDIT_MEMO_RETAIL;
    } else if (controller.transactionSummaryModel.transactionType == 3 ||
        controller.transactionSummaryModel.transactionType == 8) {
      byString = AppStrings.PAYMENT_BY;
      totalString = AppStrings.PAYMENT_AMOUNT;
      retailString = AppStrings.PAYMENT_METHOD;
    }
    return SizedBox(
        width: double.maxFinite,
        child: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.BILL_TO,
                      textAlign: TextAlign.start,
                      style: context.titleMedium,
                    ),
                    Text(
                      controller.argsCustomer.value.customerName ?? '',
                      style: context.captionMedium.copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      controller.argsCustomer.value.address1 ?? '',
                      style: context.captionMedium.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${controller.argsCustomer.value.city ?? ''} ${controller.argsCustomer.value.state ?? ''} ${controller.argsCustomer.value.postalCode ?? ''} ',
                      style: context.captionMedium.copyWith(fontSize: 16),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      controller.argsCustomer.value.email ?? '',
                      style: context.captionMedium.copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      controller.argsCustomer.value.phoneNo ?? '',
                      style: context.captionMedium.copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    byString,
                    style: context.titleMedium,
                  ),
                  Text(
                    controller.invoiceByName.value,
                    style: context.captionMedium.copyWith(fontSize: 15),
                  ),
                  Text(
                    totalString,
                    style: context.titleMedium.copyWith(fontSize: 15),
                  ),
                  Text(
                    '${(controller.invoiceNetTotal.value != 0.0 && (controller.transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${controller.invoiceNetTotal.value}',
                    style: context.captionMedium.copyWith(fontSize: 16),
                  ),
                  Text(
                    retailString,
                    style: context.titleMedium.copyWith(fontSize: 15),
                  ),
                  (controller.transactionSummaryModel.transactionType != 3 &&
                          controller.transactionSummaryModel.transactionType !=
                              8)
                      ? Text(
                          '${(controller.invoiceRetail.value != 0.0 && (controller.transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${controller.invoiceRetail.value.toStringAsFixed(2)}',
                          style: context.captionMedium.copyWith(fontSize: 16),
                        )
                      : Text(
                          '${controller.paymentMethod}',
                          style: context.captionMedium.copyWith(fontSize: 16),
                        ),
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
        child: Column(children: [
          if (controller.transactionSummaryModel.transactionType != 4)
            _buildCustomerInfoDisplay(context),
          const SpaceH24(),
          _buildTransactionInfoDisplay(context),
        ]));
  }

  Widget _buildTransactionInfoDisplay(BuildContext context) {
    String title = '';
    if (controller.transactionSummaryModel.transactionType == 1) {
      title = 'INVOICE #';
    } else if (controller.transactionSummaryModel.transactionType == 2) {
      title = 'Credit Memo #';
    } else if (controller.transactionSummaryModel.transactionType == 3) {
      title = 'PAY #';
    } else if (controller.transactionSummaryModel.transactionType == 4) {
      title = 'SO #';
    } else if (controller.transactionSummaryModel.transactionType == 5 ||
        controller.transactionSummaryModel.transactionType == 6) {
      title = 'BILL #';
    }
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$title ${controller.transactionNumber ?? ''}',
              style: context.titleMedium,
            ),
            Text(
              'Date: ${controller.formatDate(controller.transactionDate.value)}',
              style: context.captionMedium.copyWith(fontSize: 14),
            ),
            if (controller.transactionSummaryModel.transactionType == 1)
              (controller.salesOrderId.value != 0)
                  ? Text(
                      'SO # ${controller.salesOrderId.value}',
                      style: context.captionMedium.copyWith(fontSize: 14),
                    )
                  : Container(),
          ],
        ));
  }

  Widget _buildCustomerInfoDisplay(BuildContext context) {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller.user.value?.company?.name ?? '',
              style: context.captionMedium.copyWith(fontSize: 14),
            ),
            Text(
              controller.user.value?.company?.address ?? '',
              style: context.captionMedium.copyWith(fontSize: 14),
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              controller.user.value?.email ?? '',
              style: context.captionMedium.copyWith(fontSize: 14),
            ),
            Text(
              controller.user.value?.company?.phoneNo ?? '',
              style: context.captionMedium.copyWith(fontSize: 14),
            ),
          ],
        ));
  }

  Widget _extendedAppBar(BuildContext context) {
    bool isShowSendEmailOption = false;
    bool isShowBarCodeOption = false;
    String title = 'Preview';
    if (controller.transactionSummaryModel.transactionType == 1) {
      title = AppStrings.INVOICE_PRINT_PREVIEW;
      isShowBarCodeOption = true;
      isShowSendEmailOption = true;
    } else if (controller.transactionSummaryModel.transactionType == 2) {
      title = AppStrings.CREDIT_MEMO_PREVIEW;
      isShowBarCodeOption = true;
      isShowSendEmailOption = true;
    } else if (controller.transactionSummaryModel.transactionType == 3) {
      title = AppStrings.PAYMENT_PREVIEW;
      isShowBarCodeOption = false;
      isShowSendEmailOption = true;
    } else if (controller.transactionSummaryModel.transactionType == 4) {
      title = AppStrings.SALES_ORDER_PREVIEW;
      isShowBarCodeOption = true;
      isShowSendEmailOption = true;
    } else if (controller.transactionSummaryModel.transactionType == 5) {
      title = AppStrings.BILL_PREVIEW;
      isShowBarCodeOption = true;
      isShowSendEmailOption = true;
    } else if (controller.transactionSummaryModel.transactionType == 6) {
      title = AppStrings.PURCHASE_ORDER_PREVIEW;
      isShowBarCodeOption = true;
      isShowSendEmailOption = true;
    } else if (controller.transactionSummaryModel.transactionType == 7) {
      title = AppStrings.CREDIT_MEMO_PREVIEW;
      isShowBarCodeOption = true;
      isShowSendEmailOption = true;
    } else if (controller.transactionSummaryModel.transactionType == 8) {
      title = AppStrings.CREDIT_MEMO_PREVIEW;
      isShowBarCodeOption = false;
      isShowSendEmailOption = true;
    }
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          backgroundColor: context.scaffoldBackgroundColor,
          iconTheme: IconThemeData(
            color: context.iconColor1, //change your color here
          ),
          title: Text(
            title,
            style: context.titleMedium,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.iconColor1,
            ), // Change to your desired icon
            onPressed: controller.moveBackToInitialPage,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isShowSendEmailOption)
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: CustomRoundButton(
                  text: AppStrings.SEND_EMAIL,
                  contrast: false,
                  onPressed: () =>
                      _showSendEmailSheet(context, AppStrings.EMAIL_INVOICE),
                ),
              ),
            const SpaceW12(),
            if (isShowBarCodeOption)
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Obx(
                  () => CustomRoundButton(
                    text: controller.isShowBarcode.value
                        ? AppStrings.HIDE_BARCODE
                        : AppStrings.SHOW_BARCODE,
                    contrast: true,
                    onPressed: controller.onPressHideBarCode,
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _customBottomBar(BuildContext context) {
    return Obx(() => Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: CustomRoundButton(
                    fillColor: (controller.isBluetoothConnected.value &&
                            controller.bluetoothDevice != null)
                        ? Colors.green
                        : null,
                    text: AppStrings.PRINT_RECEIPT,
                    onLongPressed: () => CustomSnackBar.showCustomBottomSheet(
                        enableDrag: false,
                        color: context.scaffoldBackgroundColor,
                        bottomSheet: const BluetoothPrinterSheetCard()),
                    contrast: false,
                    isLoadingButton: true,
                    isLoading: controller.isPrinterLoading.value,
                    onPressed: () => (controller.isBluetoothConnected.value &&
                            controller.bluetoothDevice != null)
                        ? {controller.printReceiptContent()}
                        : CustomSnackBar.showCustomBottomSheet(
                            enableDrag: false,
                            color: context.scaffoldBackgroundColor,
                            bottomSheet: const BluetoothPrinterSheetCard())),
              ),
              if (controller.transactionSummaryModel.transactionType != 3 &&
                  controller.transactionSummaryModel.transactionType != 8) ...[
                const SpaceW12(),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: CustomRoundButton(
                      text: AppStrings.PDF_DOWNLOAD,
                      contrast: true,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.onPressDownloadPDF),
                ),
              ]
            ]));
  }

  //Components of this page only//

  Widget _buildTotalRow(BuildContext context, String heading, String val) {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            heading,
            style: context.bodyLarge
                .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Text(
            val,
            style: context.bodyLarge.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
