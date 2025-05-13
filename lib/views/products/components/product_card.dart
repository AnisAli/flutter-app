import 'package:get/utils.dart';
import '../../../exports/index.dart';
import 'network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool? showActiveToggle;
  ProductController productController = Get.find<ProductController>();

  ProductCard({
    Key? key,
    required this.product,
    this.showActiveToggle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade400, width: 0.5))),
      child: Card(
          borderOnForeground: false,
          elevation: 0,
          margin: const EdgeInsets.all(0),
          color: context.scaffoldBackgroundColor,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (showActiveToggle! && productController.isShowActive.value)
                  _buildActiveToggle(context),
                if (productController.isShowImage.value)
                  _buildImageHeader(context),
                _buildProductInfo(context),
                _buildIcons(context),
              ],
            ),
          )),
    );
  }

  Expanded _buildProductInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (productController.isShowName.value)
              Text(
                product.productName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.bodyText1.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            const SpaceH4(),
            if (productController.isShowDescription.value)
              Text(
                product.description ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.bodyText2.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            const SpaceH4(),
            if (productController.isShowParentCategory.value)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      " ${(product.rootCategoryName ?? "").toUpperCase()}.",
                      style: context.captionLarge.copyWith(
                        fontWeight: FontWeight.w400,
                        backgroundColor: context.background,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            const SpaceH4(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (productController.isShowSalePrice.value)
            Text("\$${product.price!.toStringAsFixed(2)}",
                style: context.titleLarge.copyWith(
                  fontWeight: FontWeight.w400,
                  fontFamily: AppStrings.WORK_SANS,
                  letterSpacing: 1,
                )),
          Text("Qty: ${product.quantityInHand}",
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.w400,
                fontFamily: AppStrings.WORK_SANS,
                letterSpacing: 1,
              )),


          if (productController.isShowIndicators.value)
            Row(
              children: [
                if (product.isLossWarning())
                  Icon(
                    Icons.warning_amber,
                    size: Sizes.ICON_SIZE_20,
                    color: context.iconColor,
                  ),
                if (product.barcode != "" && product.barcode != null)
                  Icon(
                    CupertinoIcons.barcode_viewfinder,
                    size: Sizes.ICON_SIZE_20,
                    color: context.iconColor,
                  ),
                if (product.isTaxable == true)
                  Icon(
                    Icons.account_balance_outlined,
                    size: Sizes.ICON_SIZE_20,
                    color: context.iconColor,
                  ),
                if (product.isOutOfStock())
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: Sizes.ICON_SIZE_20,
                    color: context.iconColor,
                  ),
                if (product.suggestedRetailPrice != null && product.suggestedRetailPrice != 0.00)
                  Icon(
                    Icons.attach_money,
                    size: Sizes.ICON_SIZE_20,
                    color: context.iconColor,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: NetworkImageWithLoader(
        product.imageUrl,
        radius: Sizes.RADIUS_12,
      ),
    );
  }

  Widget _buildActiveToggle(BuildContext context) {
    return Container(
      color: product.isActive! ? Colors.transparent : Colors.red.shade800,
      height: double.infinity,
      width: Sizes.WIDTH_6,
    );
  }
}
