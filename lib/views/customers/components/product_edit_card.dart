import '../../../exports/index.dart';

class ProductEditCard extends StatefulWidget {
  CategoryProductModel prod;
  int categoryIndex;
  bool confirmationNeeded;
  bool scannerPage;
  bool isInitiallyExpanded;
  bool isFromRootCategoryPage;

  ProductEditCard(
      {super.key,
      required this.prod,
      this.scannerPage = false,
      this.isInitiallyExpanded = false,
      this.isFromRootCategoryPage = false,
      required this.confirmationNeeded,
      required this.categoryIndex});

  @override
  State<ProductEditCard> createState() => _ProductEditCardState();
}

class _ProductEditCardState extends State<ProductEditCard> {
  QuickInvoiceController quickInvoiceController =
      Get.find<QuickInvoiceController>();
  late double tempQuantity;
  late int index;
  late String? defaultPrice;
  late String? defaultSrp;
  late String priceLabel;
  late TextEditingController priceController;
  late TextEditingController srpController;
  late TextEditingController tempQuantityController;
  late TextEditingController totalAmountController;
  @override
  void initState() {
    super.initState();
    tempQuantity = widget.prod.quantity;
    if (quickInvoiceController.isVendorThere) {
      priceLabel = 'Purchase Cost';
      totalAmountController = TextEditingController(
          text: '${widget.prod.quantity * (widget.prod.cost ?? 0).toDouble()}');
      priceController =
          TextEditingController(text: (widget.prod.cost ?? 0.0).toString());
      defaultPrice = (widget.prod.cost ?? 0.0).toString();
    } else if (widget.isFromRootCategoryPage) {
      priceLabel = 'Sales Price';
      priceController =
          TextEditingController(text: widget.prod.basePrice.toString());
      defaultPrice = widget.prod.basePrice?.toStringAsFixed(2);
      srpController = TextEditingController(
          text: "${widget.prod.suggestedRetailPrice ?? 0.0}");
      defaultSrp = (widget.prod.suggestedRetailPrice ?? 0.0).toString();
    } else {
      priceLabel = 'Sales Price';
      priceController =
          TextEditingController(text: widget.prod.price.toString());
      defaultPrice = widget.prod.price?.toStringAsFixed(2);
      srpController = TextEditingController(
          text: "${widget.prod.suggestedRetailPrice ?? 0.0}");
      defaultSrp = (widget.prod.suggestedRetailPrice ?? 0.0).toString();
    }
    tempQuantityController =
        TextEditingController(text: widget.prod.quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    index = quickInvoiceController.getIndexIfCartItemExist(widget.prod);
    if (!widget.confirmationNeeded) {
      if (quickInvoiceController.isVendorThere) {
        priceController =
            TextEditingController(text: widget.prod.cost.toString());
      } else {
        priceController =
            TextEditingController(text: widget.prod.price.toString());
      }
    }
    return widget.confirmationNeeded
        ? _buildEditCardContent(context)
        : ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            child: ExpansionTile(
              initiallyExpanded: widget.isInitiallyExpanded,
              maintainState: true,
              title: Container(
                margin: const EdgeInsets.only(left: 10),
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 220,
                          child: Text(
                            widget.prod.productName ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: context.titleMedium
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            widget.prod.barCode ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: context.titleMedium
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (widget.isFromRootCategoryPage)
                          SizedBox(
                            width: 220,
                            child: Text(
                              widget.prod.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: context.titleMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: DarkTheme.darkShade3),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      'Qty',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: context.titleMedium
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      index != -1
                          ? quickInvoiceController
                              .invoiceCart.items[index].quantity
                              .toStringAsFixed(2)
                          : '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: context.titleMedium
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              trailing: const SizedBox(),
              tilePadding: EdgeInsets.zero,
              onExpansionChanged: (val) {},
              children: [
                _buildEditCardContent(context),
                _showSalesHistory(context),
              ],
            ));
  }

  Widget _showSalesHistory(BuildContext context) {
    RxBool isExpandedSalesHistory = false.obs;
    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      dense: true,
      horizontalTitleGap: 0.0,
      minLeadingWidth: 0,
      child: ExpansionTile(
        trailing: const SizedBox(),
        tilePadding: EdgeInsets.zero,
        backgroundColor: Colors.grey.shade400,
        collapsedBackgroundColor: Colors.grey.shade400,
        title: Container(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.only(left: 10),
            width: double.maxFinite,
            alignment: Alignment.centerLeft,
            child: Obx(() => Text(
                  (isExpandedSalesHistory.value)
                      ? 'Hide Sales History'
                      : 'Show Sales History',
                  style: context.titleSmall
                      .copyWith(color: context.scaffoldBackgroundColor),
                ))),
        onExpansionChanged: (val) async {
          isExpandedSalesHistory.value = val;
          if (val && widget.prod.lastOrders.isEmpty) {
            await quickInvoiceController
                .onFetchingOrderHistoryProd(widget.prod);
          }
        },
        children: [
          Container(
            height: 90,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Date',
                      style: context.titleMedium.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Qty',
                      style: context.titleMedium.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Price',
                      style: context.titleMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Obx(() => Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          widget.prod.lastOrders.length,
                          (int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.prod.lastOrders[index].orderDate ??
                                        '',
                                    style: context.titleMedium
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.prod.lastOrders[index].quantity !=
                                            null
                                        ? widget.prod.lastOrders[index].quantity
                                            .round()
                                            .toString()
                                        : '0',
                                    style: context.titleMedium
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.prod.lastOrders[index].price != null
                                        ? widget.prod.lastOrders[index].price
                                            .toString()
                                        : '0.00',
                                    style: context.titleMedium
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEditCardContent(BuildContext context) {
    return GetBuilder(
      init: quickInvoiceController,
      builder: (GetxController controller) {
        return Container(
          color: context.cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (!widget.confirmationNeeded)
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.deepOrange.shade300,
                      child: InkWell(
                        onTap: () async {
                          ProductModel detailedProduct =
                              await quickInvoiceController
                                  .getProduct(widget.prod.productId.toString());

                          var result = await Get.toNamed(
                            AppRoutes.ADD_PRODUCT,
                            arguments: {
                              'product': detailedProduct,
                              'isCloned': false,
                              "backRoute": false,
                              "backRoutePath": 'onlyBack',
                            },
                          );

                          if (result != null) {
                            widget.prod.productName = result['productName'];
                            widget.prod.description = result['description'];

                            ///Comment out if want to update Price or Cost after edit product//
                            // if (quickInvoiceController.isVendorThere) {
                            //   widget.prod.cost = result['purchaseCost'];
                            //   priceController.text =
                            //       widget.prod.cost.toString();
                            // } else {
                            //   widget.prod.price = result['price'];
                            //   priceController.text =
                            //       widget.prod.price.toString();
                            // }
                          }
                          quickInvoiceController.customerCategoryModelList
                              .refresh();
                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          size: Sizes.ICON_SIZE_18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SpaceW16(),
                  if (!widget.isFromRootCategoryPage)
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.prod.description ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: DarkTheme.darkShade3),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SpaceH8(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      FocusScope(
                        onFocusChange: (val) {
                          if (!val) {
                            quickInvoiceController.invoiceCart.items.refresh();
                            if (priceController.text.isEmpty) {
                              priceController.text = defaultPrice.toString();
                            }
                          }
                        },
                        child: CustomTextFormField(
                          autofocus: false,
                          controller: priceController,
                          textAlign: TextAlign.end,
                          showClearButton: true,
                          onSuffixTap: priceController.clear,
                          fillColor: context.scaffoldBackgroundColor,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          focusBorderColor: context.scaffoldBackgroundColor,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,10}(\.\d{0,4})?'),
                            ),
                          ],
                          onChanged: (val) {
                            if (!widget.confirmationNeeded) {
                              if (val.isNotEmpty) {
                                if (quickInvoiceController.isVendorThere) {
                                  widget.prod.cost = val.toDouble();
                                  quickInvoiceController.invoiceCart
                                      .calculateVendorTaxedAmount();
                                  quickInvoiceController.invoiceCart
                                      .calculateVendorTotal();

                                  //calculate totalCost controller text from purchaseCost //
                                  calculateTotalCostFromPurchaseCost(
                                      val.toDouble());
                                } else {
                                  widget.prod.price = val.toDouble();
                                  quickInvoiceController.invoiceCart
                                      .calculateTaxedAmount();
                                  quickInvoiceController.invoiceCart
                                      .calculateTotal();
                                }
                              } else {
                                widget.prod.price = defaultPrice?.toDouble();
                              }
                            }
                          },
                          hintText: '0.00',
                          width: 120,
                          height: 35,
                          verticalPadding: 0,
                        ),
                      ),
                      const SpaceH4(),
                      Text(
                        priceLabel,
                        style: context.captionMedium.copyWith(
                          color: DarkTheme.darkShade3,
                        ),
                      ),
                      if (!quickInvoiceController.isVendorThere) ...[
                        const SpaceH8(),
                        Column(
                          children: [
                            Focus(
                              onFocusChange: (val) {
                                if (!val) {
                                  if (srpController.text.isEmpty) {
                                    srpController.text = defaultSrp.toString();
                                  }
                                }
                              },
                              child: CustomTextFormField(
                                autofocus: false,
                                controller: srpController,
                                textAlign: TextAlign.end,
                                showClearButton: true,
                                onSuffixTap: srpController.clear,
                                fillColor: context.scaffoldBackgroundColor,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                focusBorderColor:
                                    context.scaffoldBackgroundColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d{0,10}(\.\d{0,4})?'),
                                  ),
                                ],
                                onChanged: (val) {
                                  widget.prod.suggestedRetailPrice =
                                      val.toDouble();
                                },
                                hintText: '0.00',
                                width: 120,
                                height: 35,
                                verticalPadding: 0,
                              ),
                            ),
                            const SpaceH4(),
                            Text(
                              'SRP',
                              style: context.captionMedium.copyWith(
                                color: DarkTheme.darkShade3,
                              ),
                            )
                          ],
                        ),
                      ],
                    ],
                  ),
                  Column(
                    children: [
                      CounterView(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return _showAddQuantityDialog(
                                    context,
                                    (index != -1)
                                        ? quickInvoiceController
                                            .invoiceCart.items[index].quantity
                                        : 0.0,
                                    widget.confirmationNeeded);
                              });
                        },
                        initNumber: (widget.confirmationNeeded)
                            ? tempQuantity.obs
                            : index != -1
                                ? quickInvoiceController
                                    .invoiceCart.items[index].quantity.obs
                                : 0.0.obs,
                        counterCallback: (val) {
                          tempQuantity = val;
                          tempQuantityController.text = val.toString();
                          if (!widget.confirmationNeeded) {
                            widget.prod.quantity = val;
                            quickInvoiceController.onAddRemoveItem(
                                val, widget.prod, widget.categoryIndex);
                          }

                          //for calculating totalCost from qty //
                          if (quickInvoiceController.isVendorThere) {
                            calculateTotalCostFromQuantity(val);
                          }
                          setState(() {});
                        },
                      ),
                      const SpaceH4(),
                      Text(
                        'Qty',
                        style: context.captionMedium.copyWith(
                          color: DarkTheme.darkShade3,
                        ),
                      ),
                      if (!quickInvoiceController.isVendorThere) ...[
                        const SpaceH12(),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                widget.prod.quantity *= -1;
                                tempQuantity *= -1;
                                quickInvoiceController.onAddRemoveItem(
                                    widget.prod.quantity,
                                    widget.prod,
                                    widget.categoryIndex);
                                quickInvoiceController.update();
                              },
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: context.primary,
                                child: const Icon(
                                  CupertinoIcons.plus_slash_minus,
                                  size: Sizes.ICON_SIZE_20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SpaceH4(),
                            Text(
                              'Sign',
                              style: context.captionMedium.copyWith(
                                color: DarkTheme.darkShade3,
                              ),
                            )
                          ],
                        ),
                      ]
                    ],
                  ),
                ],
              ),
              const SpaceH8(),
              if (quickInvoiceController.isVendorThere) ...[
                Column(
                  children: [
                    CustomTextFormField(
                      autofocus: false,
                      controller: totalAmountController,
                      textAlign: TextAlign.end,
                      showClearButton: true,
                      onSuffixTap: totalAmountController.clear,
                      fillColor: context.scaffoldBackgroundColor,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      focusBorderColor: context.scaffoldBackgroundColor,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,10}(\.\d{0,4})?'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val.isNotEmpty &&
                            quickInvoiceController
                                    .invoiceCart.items[index].quantity !=
                                0.0) {
                          calculateFromTotalCost(val.toDouble());
                        }
                      },
                      hintText: '0.00',
                      width: 120,
                      height: 35,
                      verticalPadding: 0,
                    ),
                    const SpaceH4(),
                    Text(
                      'Total Cost',
                      style: context.captionMedium.copyWith(
                        color: DarkTheme.darkShade3,
                      ),
                    )
                  ],
                ),
                const SpaceH8(),
              ],
              if (!quickInvoiceController.isVendorThere &&
                  (quickInvoiceController.pageType == 'credit' ||
                      quickInvoiceController.pageType == 'editCredit')) ...[
                Row(
                  children: [
                    Checkbox(
                        value: widget.prod.isDamaged ?? false,
                        onChanged: (val) {
                          widget.prod.isDamaged = val;
                          quickInvoiceController.update();
                        }),
                    const SpaceW4(),
                    Text(
                      'Damage/Bad Inventory',
                      style: context.titleMedium
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SpaceH8(),
              ],
              if (!widget.confirmationNeeded) _buildQuantityOptions(context),
              if (widget.confirmationNeeded)
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
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomRoundButton(
                          text: 'Apply',
                          contrast: false,
                          onPressed: () {
                            if (widget.confirmationNeeded) {
                              if (quickInvoiceController.isVendorThere) {
                                if (priceController.text.isNotEmpty) {
                                  widget.prod.cost =
                                      priceController.text.toDouble();
                                  quickInvoiceController.invoiceCart
                                      .calculateVendorTaxedAmount();
                                  quickInvoiceController.invoiceCart
                                      .calculateVendorTotal();
                                } else {
                                  widget.prod.price = defaultPrice?.toDouble();
                                }
                              } else {
                                if (priceController.text.isNotEmpty) {
                                  widget.prod.price =
                                      priceController.text.toDouble();
                                  quickInvoiceController.invoiceCart
                                      .calculateTaxedAmount();
                                  quickInvoiceController.invoiceCart
                                      .calculateTotal();
                                } else {
                                  widget.prod.price = defaultPrice?.toDouble();
                                }
                              }
                              quickInvoiceController.onAddRemoveItem(
                                  tempQuantity,
                                  widget.prod,
                                  widget.categoryIndex);

                              Get.back();
                            }
                          }),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityOptions(BuildContext context) {
    return Container(
      color: context.cardColor,
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var quantity in [1, 5, 10, 12, 24])
            _circularAvatar(context, quantity.toString(), () {
              quickInvoiceController.onAddRemoveItem(
                  quantity.toDouble(), widget.prod, widget.categoryIndex,
                  addUpQuantity: true);
              //for calculating totalCost from qty //
              if (quickInvoiceController.isVendorThere &&
                  totalAmountController.text.isNotEmpty) {
                calculateTotalCostFromQuantity(widget.prod.quantity);
              }
              setState(() {});
            }),
          _circularAvatarIcon(context, CupertinoIcons.delete_solid, () {
            _showAlertDialog(context, () {
              quickInvoiceController.onAddRemoveItem(
                  0, widget.prod, widget.categoryIndex,
                  addUpQuantity: true);
              setState(() {});
              Get.back();
            });
          }),
        ],
      ),
    );
  }

  static void _showAlertDialog(BuildContext context, onPress) {
    // Icon(Icons.logout_rounded, color: context.iconColor1, size: 20),
    PanaraConfirmDialog.show(
      context,
      title: "Are you sure?",
      textColor: Colors.black,
      message: "",
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      color: context.primaryColor,
      onTapCancel: Get.back,
      onTapConfirm: onPress,
      panaraDialogType: PanaraDialogType.custom,
    );
  }

  Widget _circularAvatar(BuildContext context, String text, onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: context.primary),
        ),
        child: Center(
          child: Text(
            text,
            style: context.titleMedium.copyWith(color: context.primary),
          ),
        ),
      ),
    );
  }

  Widget _circularAvatarIcon(BuildContext context, IconData iconData, onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: context.primary),
        ),
        child: Center(
            child: Icon(
          iconData,
          color: context.primary,
          size: 20,
        )),
      ),
    );
  }

  Widget _showAddQuantityDialog(
      BuildContext context, double qty, bool isConfirmationNeed) {
    TextEditingController qtyController =
        TextEditingController(text: qty.toString());
    FocusNode focusNode = FocusNode();

    if (isConfirmationNeed) {
      qtyController = tempQuantityController;
    }

    // Ensure the focus is maintained and text is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNode.hasFocus) {
        qtyController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: qtyController.text.length,
        );
      }
    });

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
          child: Text(AppStrings.QUANTITY, style: context.titleLarge),
        ),
        content: Container(
          color: context.cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Focus(
                focusNode: focusNode,
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      qtyController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: qtyController.text.length,
                      );
                    });
                  }
                },
                child: CustomTextFormField(
                  autofocus: true,
                  controller: qtyController,
                  textAlign: TextAlign.end,
                  showClearButton: true,
                  onSuffixTap: qtyController.clear,
                  fillColor: context.scaffoldBackgroundColor,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  focusBorderColor: context.scaffoldBackgroundColor,
                  hintText: '0.0',
                  width: 120,
                  height: 35,
                  verticalPadding: 0,
                ),
              ),
              const SpaceH8(),
              Text(
                AppStrings.QUANTITY,
                style: context.captionMedium.copyWith(
                  color: DarkTheme.darkShade3,
                ),
              ),
              const SpaceH24(),
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
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CustomRoundButton(
                        text: 'Apply',
                        contrast: false,
                        onPressed: () {
                          if (qtyController.text.isNotEmpty) {
                            tempQuantity = qtyController.text.toDouble();
                            if (!widget.confirmationNeeded) {
                              widget.prod.quantity = tempQuantity;
                              quickInvoiceController.onAddRemoveItem(
                                  tempQuantity,
                                  widget.prod,
                                  widget.categoryIndex);
                            }
                          }
                          Get.back();
                        }),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  // Calculating Functions //
  void calculateFromTotalCost(double totalCost) {
    priceController.text = (totalCost.toDouble() /
            quickInvoiceController.invoiceCart.items[index].quantity)
        .toString();
    widget.prod.cost = priceController.text.toDouble();
    quickInvoiceController.invoiceCart.calculateVendorTaxedAmount();
    quickInvoiceController.invoiceCart.calculateVendorTotal();
  }

  void calculateTotalCostFromQuantity(double qty) {
    totalAmountController.text =
        (priceController.text.toDouble() * qty).toString();
  }

  void calculateTotalCostFromPurchaseCost(double cost) {
    totalAmountController.text = (cost * widget.prod.quantity).toString();
  }
}
