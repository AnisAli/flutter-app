import '../../../exports/index.dart';

class ProfitLossOverview extends GetView<ProfitLossOverviewController> {
  static const String routeName = '/profitLossOverview';

  const ProfitLossOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      pinAppBar: true,
      showMenuButton: false,
      showThemeButton: false,
      simpleAppBar: _buildSimpleAppBar(context),
      scaffoldKey: controller.scaffoldKey,
      padding: Sizes.PADDING_12,
      children: [
        const SpaceH8().sliverToBoxAdapter,
        _buildDateBar().sliverToBoxAdapter,
        const SpaceH8().sliverToBoxAdapter,
        _buildDateRangeBar(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        _buildReportCard(context).sliverToBoxAdapter,
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
        AppStrings.PROFIT_LOSS_OVERVIEW,
        style: context.titleMedium,
      ),
    );
  }

  Widget _buildDateBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropDownField(
          controller: controller.dateController,
          showSearchBox: false,
          title: AppStrings.DATE,
          onChange: controller.onDateChange,
          items: AppStrings.DATES,
          selectedItem: controller.date,
        )
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
                onEditingComplete: controller.getProfitLossReport,
                prefixIconData: Icons.date_range_outlined,
                textInputAction: TextInputAction.next,
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
                onEditingComplete: controller.getProfitLossReport,
                prefixIconData: CupertinoIcons.calendar_today,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /* Widget _buildFormulaBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '\nIncome',
                  textAlign: TextAlign.center,
                  style: context.titleMedium.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${controller.income.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: context.titleLarge,
                ),
              ],
            ),
            Text(
              '-',
              style: context.headline5.copyWith(color: Colors.grey),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Cost of\nGoods Sold',
                  textAlign: TextAlign.center,
                  style: context.titleMedium.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${controller.cogs.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: context.headlineSmall,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '-',
              style: context.headline5.copyWith(color: Colors.grey),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Operating\nExpenses',
                  textAlign: TextAlign.center,
                  style: context.titleMedium.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${controller.operatingExpense.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: context.headlineSmall,
                ),
              ],
            ),
            Text(
              '=',
              style: context.headline5.copyWith(color: Colors.grey),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Net\nProfit',
                  textAlign: TextAlign.center,
                  style: context.titleMedium.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${controller.netProfit.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: context.headlineSmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }*/

  Widget _buildReportCard(BuildContext context) {
    return GetBuilder<ProfitLossOverviewController>(
      id: 'reportData',
      builder: (_) => Column(
        children: [
          _buildReportCardTile(
            context,
            text: AppStrings.ACCOUNT.capitalize!,
            value:
                '${controller.fromDatePickerController.text} to ${controller.toDatePickerController.text}',
            isHavingChild: false,
            isHeading: true,
            textColor: Colors.grey,
          ),
          Divider(
            height: 0,
            color: context.dividerColor.withOpacity(0.25),
          ),
          _buildReportCardTile(
            context,
            text: AppStrings.SALES,
            value: formatCurrency(controller.reportData.amount!),
            isHavingChild: false,
            isHeading: false,
            textColor: Colors.grey,
          ),
          Divider(
            height: 0,
            color: context.dividerColor.withOpacity(0.25),
          ),
          _buildReportCardTile(
            context,
            text: AppStrings.COST_OF_GOODS_SOLD,
            value:
                formatCurrency(controller.reportData.costOfGoodsSold!),
            isHavingChild: false,
            isHeading: false,
            textColor: Colors.grey,
          ),
          Divider(
            height: 0,
            color: context.dividerColor.withOpacity(0.25),
          ),
          _buildReportCardTile(
            context,
            text: controller.reportData.grossProfit! < 0
                ? AppStrings.GROSS_LOSS
                : AppStrings.GROSS_PROFIT,
            value: formatCurrency(controller.reportData.grossProfit!),
            isHavingChild: true,
            childText: 'As a percentage of Total Income',
            childValue:
                '${controller.reportData.grossProfitPercent!.toStringAsFixed(0)}%',
            isHeading: false,
            textColor: context.primaryColor,
          ),
          Divider(
            height: 0,
            color: context.dividerColor.withOpacity(0.25),
          ),
          _buildReportCardTile(
            context,
            text: AppStrings.DAMAGE_EXPENSES,
            value: formatCurrency(controller.reportData.damagedExpense!),
            isHavingChild: false,
            isHeading: false,
            textColor: Colors.grey,
          ),
          Divider(
            height: 0,
            color: context.dividerColor.withOpacity(0.25),
          ),
          _buildReportCardTile(
            context,
            text: AppStrings.OPERATING_EXPENSES,
            value: formatCurrency(controller.reportData.expense!),
            isHavingChild: false,
            isHeading: false,
            textColor: Colors.grey,
          ),
          Divider(
            height: 0,
            color: context.dividerColor.withOpacity(0.25),
          ),
          _buildReportCardTile(
            context,
            text: controller.reportData.netProfit! < 0
                ? AppStrings.NET_LOSS
                : AppStrings.NET_PROFIT,
            value: formatCurrency(controller.reportData.netProfit!),
            isHavingChild: true,
            childText: 'As a percentage of Total Income',
            childValue:
                '${controller.reportData.netProfitPercent!.toStringAsFixed(0)}%',
            isHeading: false,
            textColor: controller.reportData.netProfit! < 0
                ? AppColors.redShade4
                : AppColors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCardTile(
    BuildContext context, {
    required String text,
    required String value,
    required bool isHavingChild,
    required bool isHeading,
    String? childText,
    String? childValue,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      height: isHavingChild ? 70 : 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isHavingChild
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: context.titleLarge.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      childText!,
                      style: context.titleMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : isHeading
                  ? Text(
                      text,
                      style: context.titleLarge,
                    )
                  : Text(
                      text,
                      style: context.titleLarge.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          isHavingChild
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      //'${controller.fromDatePickerController.text} to ${controller.toDatePickerController.text}',
                      value,
                      style: context.titleLarge.copyWith(color: textColor),
                    ),
                    Text(
                      //'${controller.fromDatePickerController.text} to ${controller.toDatePickerController.text}',
                      childValue!,
                      style: context.titleMedium.copyWith(color: textColor),
                    ),
                  ],
                )
              : Text(
                  //'${controller.fromDatePickerController.text} to ${controller.toDatePickerController.text}',
                  value,
                  style: isHeading
                      ? context.titleMedium.copyWith(color: textColor)
                      : context.titleLarge.copyWith(color: textColor),
                ),
        ],
      ),
    );
  }

  String formatCurrency(double value) {
    final NumberFormat formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }
}
