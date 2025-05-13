import 'package:zefyrka/zefyrka.dart';

import '../../../exports/index.dart';

class TransactionSummaryVendorCard extends StatelessWidget {
  TransactionSummaryModel transactionSummaryModel;
  VendorDetailController vendorDetailController =
      Get.find<VendorDetailController>();
  bool isShowEdit = true;
  bool isShowApplyPayment = true;
  bool isShowConvertToInvoice = false;
  bool isShowPaymentDelete = false;
  bool isShowEditMemo = false;
  late TextEditingController tempApplyPaymentController;
  TransactionSummaryVendorCard(
      {Key? key, required this.transactionSummaryModel})
      : super(key: key) {
    tempApplyPaymentController =
        TextEditingController(text: transactionSummaryModel.balance.toString());
    if (transactionSummaryModel.transactionType == 5) {
      if (transactionSummaryModel.balance == 0) {
        isShowEdit = false;
        isShowApplyPayment = false;
      } else if ((transactionSummaryModel.balance)! <
          (transactionSummaryModel.amount)!) {
        isShowEdit = false;
      }
    } else if (transactionSummaryModel.transactionType == 6) {
      isShowApplyPayment = false;
      isShowConvertToInvoice = true;
    } else if (transactionSummaryModel.transactionType == 7) {
      isShowApplyPayment = false;
      isShowEdit = false;
      isShowEditMemo = true;
    } else if (transactionSummaryModel.transactionType == 8) {
      isShowApplyPayment = false;
      isShowEdit = false;
      isShowPaymentDelete = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? transactionTitle =
        '${transactionSummaryModel.transaction}# ${transactionSummaryModel.transactionNumber}';
    if (transactionSummaryModel.transactionType == 5) {
      transactionTitle = 'Bill # ${transactionSummaryModel.transactionNumber}';
    }
    RxBool isExpanded = false.obs;
    String viewText = 'View';
    if (transactionSummaryModel.transactionType == 7) {
      viewText = 'View Credit Bill';
    } else if (transactionSummaryModel.transactionType == 8) {
      viewText = 'View Payment';
    }

    return Obx(() => ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: ExpansionTile(
          title: Container(
            margin: const EdgeInsets.only(left: 10),
            width: double.maxFinite,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MM/dd/yyyy').format(
                            DateTime.parse(transactionSummaryModel.date ?? '')),
                        style: context.bodySmall
                            .copyWith(fontWeight: FontWeight.w400),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!vendorDetailController.viaVendors) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          transactionSummaryModel.customerName ?? '',
                          style: context.bodySmall
                              .copyWith(fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ]
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              transactionTitle ?? '',
                              textAlign: TextAlign.left,
                              style: context.bodySmall
                                  .copyWith(fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            if (transactionSummaryModel.transactionType == 5 ||
                                transactionSummaryModel.transactionType ==
                                    7) ...[
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '\$ ${transactionSummaryModel.balance?.toStringAsFixed(2)}',
                                style: context.bodySmall
                                    .copyWith(fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                          ],
                        ),
                      ),
                      if (transactionSummaryModel.transactionType == 5 ||
                          transactionSummaryModel.transactionType == 7)
                        transactionSummaryModel.balance != 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: transactionSummaryModel
                                                .transactionType ==
                                            5
                                        ? Colors.red.shade600
                                        : context.primary,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  transactionSummaryModel.transactionType == 5
                                      ? 'Due'
                                      : 'Open',
                                  style: context.bodySmall
                                      .copyWith(color: Colors.white),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  'Paid',
                                  style: context.bodySmall
                                      .copyWith(color: Colors.white),
                                ),
                              )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: 80,
                  child: Text(
                    '\$ ${transactionSummaryModel.amount?.toStringAsFixed(2)}',
                    style: context.titleSmall
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          trailing: const SizedBox(),
          tilePadding: EdgeInsets.zero,
          leading: isExpanded.value
              ? Icon(
                  Icons.keyboard_arrow_up,
                  color: context.iconColor1,
                )
              : Icon(
                  Icons.keyboard_arrow_down,
                  color: context.iconColor1,
                ),
          onExpansionChanged: (val) {
            isExpanded(val);
          },
          children: [
            Container(
              decoration: BoxDecoration(
                  color: context.cardColor,
                  border: Border.all(color: context.background, width: 0.5)),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Time: ${DateFormat("h:mm a").format(DateTime.parse(transactionSummaryModel.createdDate ?? '').toLocal())}",
                        style: context.bodySmall
                            .copyWith(fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Created by: ${transactionSummaryModel.createdBy}',
                          style: context.bodySmall
                              .copyWith(fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  const SpaceH16(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isShowApplyPayment)
                        _buildTileButton(context, Colors.green, 'Apply Payment',
                            () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    titlePadding: EdgeInsets.zero,
                                    elevation: 0,
                                    backgroundColor:
                                        context.scaffoldBackgroundColor,
                                    title: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: context.primary.withOpacity(0.7),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(28.0),
                                          topRight: Radius.circular(28.0),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 25),
                                      width: double.maxFinite,
                                      child: Text(
                                        "Payment for Bill#${transactionSummaryModel.transactionNumber}",
                                        style: context.titleLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    content: _showApplyPaymentDialog(context));
                              });
                        }),
                      if (isShowEdit)
                        _buildTileButton(context, Colors.red.shade600, 'Edit',
                            () {
                          if (vendorDetailController.viaVendors) {
                            Get.toNamed(
                              AppRoutes.QUICK_INVOICE,
                              arguments: {
                                "pageType": 'edit',
                                "transactionSummaryModel":
                                    transactionSummaryModel,
                                "viaCustomers": true,
                                'vendor':
                                    vendorDetailController.argsVendor.value,
                                'customer': vendorDetailController
                                    .getCustomerModelFromVendor(
                                        vendorDetailController.argsVendor.value)
                              },
                            );
                          } else {
                            // Get.toNamed(
                            //   AppRoutes.QUICK_INVOICE,
                            //   arguments: {
                            //     "pageType": 'edit',
                            //     "transactionSummaryModel":
                            //     transactionSummaryModel,
                            //     "viaCustomers": false,
                            //   },
                            // );
                          }
                        }),
                      if (isShowConvertToInvoice)
                        _buildTileButton(
                            context, Colors.purple.shade400, 'Convert to Bill',
                            () async {
                          vendorDetailController.isLoading(true);
                          await vendorDetailController.convertToBill(
                              transactionSummaryModel.id.toString());
                          if (vendorDetailController.viaVendors) {
                            //await vendorDetailController.getOpenInvoices();
                            //await customerDetailController.getCustomerDetail();
                          }
                          vendorDetailController.transactionsPaginationKey
                              .refresh();
                          vendorDetailController.isLoading(false);
                        }),
                      _buildTileButton(
                          context, Colors.blueAccent.shade700, viewText, () {
                        if (vendorDetailController.viaVendors) {
                          Get.toNamed(AppRoutes.INVOICE_VIEW, arguments: {
                            'customer': vendorDetailController
                                .getCustomerModelFromVendor(
                                    vendorDetailController.argsVendor.value),
                            "transactionSummaryModel": transactionSummaryModel,
                            'vendor': true
                          });
                        } else {
                          // Get.toNamed(AppRoutes.INVOICE_VIEW, arguments: {
                          //   "transactionSummaryModel": transactionSummaryModel,
                          // });
                        }
                      }),
                      if (isShowEditMemo)
                        _buildTileButton(context, Colors.red.shade600, 'Edit',
                            () {
                          // if (customerDetailController.viaCustomers) {
                          //   Get.toNamed(
                          //     AppRoutes.QUICK_INVOICE,
                          //     arguments: {
                          //       "pageType": 'editCredit',
                          //       "transactionSummaryModel":
                          //       transactionSummaryModel,
                          //       "viaCustomers": true,
                          //       'customer':
                          //       customerDetailController.argsCustomer.value
                          //     },
                          //   );
                          // } else {
                          //   Get.toNamed(
                          //     AppRoutes.QUICK_INVOICE,
                          //     arguments: {
                          //       "pageType": 'editCredit',
                          //       "transactionSummaryModel":
                          //       transactionSummaryModel,
                          //       "viaCustomers": false,
                          //     },
                          //   );
                          // }
                        }),
                      if (isShowPaymentDelete)
                        _buildTileButton(context, Colors.red.shade600, 'Delete',
                            () {
                          _showAlertDialog(context, () async {
                            Get.back();
                            vendorDetailController.isLoading(true);
                            await vendorDetailController.deletePayment(
                                transactionSummaryModel.id.toString());
                            if (vendorDetailController.viaVendors) {
                              //await customerDetailController.getOpenInvoices();
                              // await customerDetailController.getCustomerDetail();
                            }
                            vendorDetailController.transactionsPaginationKey
                                .refresh();
                            vendorDetailController.isLoading(false);
                          });
                        }),
                    ],
                  ),
                ],
              ),
            )
          ],
        )));
  }

  static void _showAlertDialog(BuildContext context, VoidCallback onPress) {
    // Icon(Icons.logout_rounded, color: context.iconColor1, size: 20),
    PanaraConfirmDialog.show(
      context,
      title: "Are you sure?",
      message: '',
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      color: context.primaryColor,
      onTapCancel: Get.back,
      onTapConfirm: onPress,
      panaraDialogType: PanaraDialogType.custom,
    );
  }

  Widget _buildRichText(BuildContext context, String name, String val) {
    return RichText(
        text: TextSpan(style: context.captionLarge, children: [
      TextSpan(
        text: name,
      ),
      TextSpan(text: val, style: context.titleMedium),
    ]));
  }

  Widget _showApplyPaymentDialog(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
          width: double.maxFinite,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRichText(context, 'Vendor: ',
                    transactionSummaryModel.vendorName ?? ''),
                _buildRichText(context, 'Bill Amount: ',
                    '\$ ${transactionSummaryModel.amount}'),
                _buildRichText(context, 'Amount Balance: ',
                    '\$ ${transactionSummaryModel.balance}'),
                const SpaceH16(),
                CustomDropDownField<String>(
                  controller: vendorDetailController.applyPaymentTypeController,
                  showSearchBox: false,
                  title: AppStrings.PAYMENT_TYPE,
                  prefixIcon: Icons.discount,
                  onChange: vendorDetailController.onChangeApplyPaymentMethod,
                  items: vendorDetailController.paymentTypeFilters,
                  selectedItem: vendorDetailController.applyPaymentType.value,
                ),
                const SpaceH4(),
                CustomTextFormField(
                  autofocus: false,
                  controller: tempApplyPaymentController,
                  textAlign: TextAlign.end,
                  fillColor: context.cardColor,
                  keyboardType: TextInputType.number,
                  prefixIconData: Icons.attach_money,
                  labelText: AppStrings.PAYMENT_AMOUNT,
                  onChanged: (val) {},
                  hintText: '0.00',
                ),
                if (vendorDetailController.applyPaymentType.value ==
                    'Check') ...[
                  const SpaceH8(),
                  CustomTextFormField(
                    autofocus: false,
                    controller: vendorDetailController.chequeNoController,
                    textAlign: TextAlign.start,
                    fillColor: context.cardColor,
                    keyboardType: TextInputType.text,
                    prefixIconData: Icons.note,
                    labelText: AppStrings.CHEQUE_NO,
                    onChanged: (val) {},
                    hintText: '',
                  ),
                  const SpaceH8(),
                  CustomTextFormField(
                    autofocus: false,
                    controller:
                        vendorDetailController.chequeDatePickerController,
                    labelText: AppStrings.PAYMENT_DATE,
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
                        vendorDetailController.chequeDatePickerController.text =
                            formattedDate;
                      }
                    },
                    prefixIconData: Icons.date_range_outlined,
                    textInputAction: TextInputAction.next,
                    fillColor: context.cardColor,
                  ),
                ],
                const SpaceH8(),
                _buildNotesWidget(context),
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
                        isLoading: vendorDetailController.isLoading.value,
                        isLoadingButton: true,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SpaceW12(),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomRoundButton(
                          text: 'Apply',
                          contrast: false,
                          isLoading: vendorDetailController.isLoading.value,
                          isLoadingButton: true,
                          onPressed: () async {
                            vendorDetailController.cashAmountController.text =
                                tempApplyPaymentController.text;
                            await vendorDetailController.onApplyPayment(
                                transactionSummaryModel.id,
                                transactionSummaryModel.vendorId ?? 0);
                          }),
                    ),
                  ],
                )
              ],
            ),
          )),
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
              vertical: Sizes.PADDING_4,
              horizontal: Sizes.PADDING_2,
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
            controller: vendorDetailController.notesController,
            minHeight: Sizes.HEIGHT_10,
            autofocus: false,
            scrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_8),
          ),
        ],
      ),
    );
  }

  Widget _buildTileButton(
      BuildContext context, Color color, String text, VoidCallback? onPressed) {
    return CustomButton(
      buttonType: ButtonType.text,
      constraints: const BoxConstraints(minWidth: 100),
      color: color,
      buttonPadding: const EdgeInsets.symmetric(
        vertical: Sizes.PADDING_8,
        horizontal: Sizes.PADDING_16,
      ),
      customTextStyle: context.titleSmall.copyWith(
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      onPressed: onPressed,
      verticalMargin: 0,
      textColor: Colors.white,
      text: text,
      hasInfiniteWidth: false,
    );
  }
}
