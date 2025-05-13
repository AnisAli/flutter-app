import '../../../exports/index.dart';

class ItemReport extends GetView<ItemReportController> {
  static const String routeName = '/itemReport';

  const ItemReport({super.key});

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
          _buildProductInfoContainer(context).sliverToBoxAdapter,
          const SpaceH24().sliverToBoxAdapter,
          _buildSummaryTable(context).sliverToBoxAdapter,
          const SpaceH12().sliverToBoxAdapter,
        ]).scaffold();
  }

  Widget _buildProductInfoContainer(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          _buildProductInfoDisplay(context),
        ]));
  }

  Widget _buildProductInfoDisplay(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          controller.argProduct.description ?? '',
          style: context.captionMedium.copyWith(fontSize: 14),
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          controller.argProduct.rootCategoryName ?? '',
          style: context.captionMedium.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSummaryTable(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
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
                    child: Text('COMPANY', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('NUM', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('RATE', style: context.titleSmall),
                  ),
                ],
              ),
            ],
          )
        : Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
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
                    child: Text('COMPANY', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('NUM', style: context.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('RATE', style: context.titleSmall),
                  ),
                ],
              ),
              for (var i = 0; i < controller.itemReports.length; i++)
                TableRow(
                  decoration:
                      BoxDecoration(color: context.scaffoldBackgroundColor),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat('MM-dd-yy').format(DateTime.parse(
                            controller.itemReports[i].transactionDate ?? '')),
                        style: context.captionLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${controller.itemReports[i].companyName}',
                        style: context.captionLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${controller.itemReports[i].transactionNumber}',
                        style: context.captionLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "\$${controller.itemReports[i].rate}",
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

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      pinned: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.iconColor1, //change your color here
      ),
      centerTitle: true,
      title: Text(
        controller.argProduct.productName ?? '',
        style: context.titleLarge
            .copyWith(color: context.primary, fontSize: Sizes.TEXT_SIZE_20),
      ),
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
                  text: AppStrings.PDF_DOWNLOAD,
                  contrast: false,
                  isLoadingButton: true,
                  isLoading: controller.isLoading.value,
                  onPressed: () {}),
            ),
          ],
        ));
  }
}
