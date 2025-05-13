import '../../../exports/index.dart';
import '../components/product_edit_card.dart';

class RootCategoryProduct extends StatefulWidget {
  final RootCategory rootCategory;
  const RootCategoryProduct({Key? key, required this.rootCategory})
      : super(key: key);

  @override
  State<RootCategoryProduct> createState() => _RootCategoryProductState();
}

class _RootCategoryProductState extends State<RootCategoryProduct> {
  QuickInvoiceController quickInvoiceController = Get.find();
  late List<CategoryProductModel> products = [];
  TextEditingController categorySearchController = TextEditingController();
  late final PagingController<int, ProductModel> productsPaginationKey;
  late String filter = "";
  // to debounce search effect //
  final _deBouncer = Debouncer(milliseconds: 400);

  @override
  void initState() {
    productsPaginationKey = PagingController(firstPageKey: 0);
    filter = "rootCategoryId eq ${widget.rootCategory.rootCategoryId}";
    productsPaginationKey.addPageRequestListener((pageKey) {
      getCategoryBasedProductList(pageKey, filter);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      showBackButton: false,
      simpleAppBar: _buildSimpleAppBar(context),
      resizeToAvoidBottomInset: false,
      children: [
        const SpaceH12().sliverToBoxAdapter,
        _buildScannerSearchField(context).sliverToBoxAdapter,
        const SpaceH12().sliverToBoxAdapter,
        _buildCategoryBasedProductList()
      ],
    ).scaffold();
  }

  Widget _buildCategoryBasedProductList() {
    return SlidableAutoCloseBehavior(
      child: PagedSliverList<int, ProductModel>(
        pagingController: productsPaginationKey,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<ProductModel>(
          animateTransitions: true,
          itemBuilder: (context, ProductModel product, _) {
            CategoryProductModel prod =
                CategoryProductModel.fromProductModel(product);
            int ind = quickInvoiceController.invoiceCart.items
                .indexWhere((item) => item.productId == prod.productId);

            if (ind != -1) {
              prod = quickInvoiceController.invoiceCart.items[ind];
            }
            return productsPaginationKey.itemList?.isEmpty ?? true
                ? const ProductShimmer()
                : _buildExpandedProductCard(context, prod, -1);
          },
          firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
            error: productsPaginationKey.error,
            onTryAgain: productsPaginationKey.refresh,
          ),
          noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
            onTryAgain: productsPaginationKey.refresh,
          ),
          newPageProgressIndicatorBuilder: (_) =>
              const CupertinoActivityIndicator(
            radius: Sizes.ICON_SIZE_16,
          ),
          firstPageProgressIndicatorBuilder: (_) => const ProductShimmer(),
        ),
      ),
    );
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
            isFromRootCategoryPage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      pinned: true,
      backgroundColor: context.scaffoldBackgroundColor,
      centerTitle: true,
      title: Text(
        widget.rootCategory.rootCategoryName ?? '',
        style: context.titleLarge
            .copyWith(color: context.primary, fontSize: Sizes.TEXT_SIZE_22),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: context.iconColor1),
        onPressed: Get.back,
      ),
    );
  }

  Widget _buildScannerSearchField(BuildContext context) {
    return CustomTextFormField(
      autofocus: false,
      controller: categorySearchController,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelText:
          '${AppStrings.SEARCH} ${widget.rootCategory.rootCategoryName ?? ''}',
      labelColor: DarkTheme.darkShade3,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      prefixIconData: Icons.search,
      suffixIconData: Iconsax.close_circle5,
      suffixIconColor: LightTheme.grayColorShade0,
      onSuffixTap: () {
        filter = "rootCategoryId eq ${widget.rootCategory.rootCategoryId}";
        categorySearchController.clear();
        productsPaginationKey.refresh();
      },
      onChanged: (val) {
        _deBouncer.run(() {
          filter =
              "rootCategoryId eq ${widget.rootCategory.rootCategoryId} and (contains(tolower(ProductName),tolower('$val')) or "
              "contains(tolower(description) , tolower('$val'))  or  "
              "contains(tolower(barcode) , tolower('$val')))";
          productsPaginationKey.refresh();
        });
      },
    );
  }

  Future<void> getCategoryBasedProductList(int pageKey, String filter) async {
    try {
      String customerId =
          quickInvoiceController.argsCustomer.value.customerId.toString();
      List<ProductModel> newItems = (await BaseClient.safeApiCall(
        "${ApiConstants.GET_CUSTOMER_BASED_PRODUCT_LIST}(CustomerId=$customerId)",
        //ApiConstants.GET_PRODUCT_LIST,
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        queryParameters: {
          '\$count': true,
          '\$skip': pageKey,
          '\$top': ApiConstants.ITEM_COUNT,
          if (filter != '') '\$filter': filter,
          '\$orderby': 'productName asc',
        },
        onSuccess: (response) {
          if (quickInvoiceController.isVendorThere) {
            return ProductResponseModel.fromVendorJson(response.data)
                    .products ??
                <ProductModel>[];
          } else {
            return ProductResponseModel.fromJson(response.data).products ??
                <ProductModel>[];
          }
        },
        onError: (e) {},
      ));

      final isLastPage = newItems.length < ApiConstants.ITEM_COUNT;
      if (isLastPage) {
        productsPaginationKey.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        productsPaginationKey.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      productsPaginationKey.error = error;
    }
  }

  @override
  void dispose() {
    productsPaginationKey.dispose();
    categorySearchController.dispose();
    super.dispose();
  }
}
