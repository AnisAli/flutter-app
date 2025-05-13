import '../../../exports/index.dart';

class VendorAging extends GetView<VendorAgingController> {
  static const String routeName = '/vendorAging';

  const VendorAging({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        pinAppBar: true,
        overscroll: true,
        showThemeButton: false,
        showMenuButton: false,
        simpleAppBar: _buildSimpleAppBar(context),
        customBottomNavigationBar: _customBottomBar(context),
        children: [
          const SpaceH12().sliverToBoxAdapter,
          _buildCompanyInfoContainer(context).sliverToBoxAdapter,
          const SpaceH24().sliverToBoxAdapter,
          _buildSummaryTable(context).sliverToBoxAdapter,
        ]).scaffold();
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
      title: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vendor Aging',
            style: context.titleMedium,
          ),
          Text(
            controller.argVendor.vendorName ?? '',
            style: context.titleLarge
                .copyWith(color: context.primary, fontSize: Sizes.TEXT_SIZE_20),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTable(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? Table(
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            border: TableBorder(
                bottom: BorderSide(color: DarkTheme.darkShade3),
                horizontalInside: BorderSide(color: DarkTheme.darkShade3)),
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('DATE', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('NUM', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('AMOUNT', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('BALANCE', style: context.titleSmall),
                  ),
                ],
              ),
            ],
          )
        : Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            border: TableBorder(
                bottom: BorderSide(color: DarkTheme.darkShade3),
                horizontalInside: BorderSide(color: DarkTheme.darkShade3)),
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('DATE', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('NUM', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('AMOUNT', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('BALANCE', style: context.titleSmall),
                  ),
                ],
              ),
              for (var i = 0;
                  i < controller.vendorAgingTransactions.length;
                  i++)
                TableRow(
                  decoration:
                      BoxDecoration(color: context.scaffoldBackgroundColor),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat('MM-dd-yy').format(DateTime.parse(
                            controller.vendorAgingTransactions[i].billDate ??
                                '')),
                        style: context.captionLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${controller.vendorAgingTransactions[i].billNumber}',
                        style: context.captionLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "\$${controller.vendorAgingTransactions[i].totalAmount}",
                        style: context.captionLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "\$${controller.vendorAgingTransactions[i].amountDue}",
                        style: context.captionLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 5),
                    child: Text('TOTAL', style: context.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 5),
                    child: Text(
                        '\$${controller.getTotalDueBalance().toStringAsFixed(2)}',
                        style: context.titleMedium),
                  ),
                ],
              ),
            ],
          ));
  }

  Widget _buildCompanyInfoContainer(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          _buildCompanyInfoDisplay(context),
        ]));
  }

  Widget _buildCompanyInfoDisplay(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          controller.argVendor.companyName ?? '',
          style: context.captionMedium.copyWith(fontSize: 14),
        ),
        Text(
          controller.argVendor.address1 ?? '',
          style: context.captionMedium.copyWith(fontSize: 14),
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          controller.argVendor.email ?? '',
          style: context.captionMedium.copyWith(fontSize: 14),
        ),
        Text(
          controller.argVendor.phoneNo ?? '',
          style: context.captionMedium.copyWith(fontSize: 14),
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
                  text: AppStrings.SEND_EMAIL,
                  contrast: false,
                  isLoadingButton: true,
                  isLoading: controller.isLoading.value,
                  onPressed: () {}),
            ),
            const SpaceW12(),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CustomRoundButton(
                  text: AppStrings.PDF_DOWNLOAD,
                  contrast: true,
                  isLoadingButton: true,
                  isLoading: controller.isLoading.value,
                  onPressed: () {}),
            ),
          ],
        ));
  }
}
