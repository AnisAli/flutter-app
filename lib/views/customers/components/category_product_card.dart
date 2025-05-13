import 'package:otrack/views/customers/components/product_edit_card.dart';

import '../../../exports/index.dart';

class CategoryProductCard extends StatefulWidget {
  const CategoryProductCard({Key? key}) : super(key: key);

  @override
  State<CategoryProductCard> createState() => _CategoryProductCardState();
}

class _CategoryProductCardState extends State<CategoryProductCard> {
  QuickInvoiceController quickInvoiceController =
      Get.find<QuickInvoiceController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ExpansionPanelList(
        key: Key('${quickInvoiceController.customerCategoryModelList.length}'),
        dividerColor: context.scaffoldBackgroundColor,
        expansionCallback: quickInvoiceController.onOpenCategoryTile,
        expandedHeaderPadding: EdgeInsets.zero,
        children: quickInvoiceController.customerCategoryModelList
            .asMap()
            .entries
            .map<ExpansionPanel>((entry) {
          final int index = entry.key;
          final String category = entry.value.categoryName;
          return ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: quickInvoiceController
                .customerCategoryModelList[index].isExpanded.value,
            backgroundColor: quickInvoiceController
                    .customerCategoryModelList[index].isExpanded.value
                ? context.primary
                : context.cardColor,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.maxFinite,
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            category,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.titleMedium.copyWith(
                                color: quickInvoiceController
                                        .customerCategoryModelList[index]
                                        .isExpanded
                                        .value
                                    ? context.scaffoldBackgroundColor
                                    : DarkTheme.darkShade3),
                          ),
                        ),
                        if (quickInvoiceController.isAnyCartItemExist(
                            quickInvoiceController
                                .customerCategoryModelList[index]))
                          Obx(() => Text(
                                "Items Selected: ${quickInvoiceController.customerCategoryModelList[index].selectedItemCount.value}",
                                style: context.titleMedium.copyWith(
                                    color: quickInvoiceController
                                            .customerCategoryModelList[index]
                                            .isExpanded
                                            .value
                                        ? context.scaffoldBackgroundColor
                                        : DarkTheme.darkShade3),
                              )),
                      ],
                    ),
                  ));
            },
            body: Column(
                mainAxisSize: MainAxisSize.min,
                children: entry.value.products.map((prod) {
                  // Find all occurrences of the current product in the invoice cart items
                  List<int> matchingIndices = [];
                  for (int i = 0;
                      i < quickInvoiceController.invoiceCart.items.length;
                      i++) {
                    if (quickInvoiceController.invoiceCart.items[i].productId ==
                        prod.productId) {
                      matchingIndices.add(i);
                    }
                  }
                  if (matchingIndices.isEmpty) {
                    return _buildExpandedProductCard(context, prod, index);
                  } else {
                    // To show all occurrences of the product in invoice cart
                    List<Widget> expandedCards = matchingIndices.map((i) {
                      return _buildExpandedProductCard(
                          context,
                          quickInvoiceController.invoiceCart.items[i],
                          isInitiallyExpanded: true,
                          index);
                    }).toList();
                    return Column(children: expandedCards);
                  }
                }).toList()),
          );
        }).toList()));
  }

  Widget _buildExpandedProductCard(
      BuildContext context, CategoryProductModel prod, int categoryIndex,
      {bool isInitiallyExpanded = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      color: context.cardColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductEditCard(
            prod: prod,
            categoryIndex: categoryIndex,
            confirmationNeeded: false,
            isInitiallyExpanded: isInitiallyExpanded,
          ),
        ],
      ),
    );
  }
}
