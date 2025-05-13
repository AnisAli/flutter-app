import 'package:otrack/views/products/components/product_card.dart';

import '../../../exports/index.dart';

class ProductInfoForm extends GetView<AddProductController> {
  const ProductInfoForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_8),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.cardColor,
          width: Sizes.WIDTH_2,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Sizes.RADIUS_12),
          bottomRight: Radius.circular(Sizes.RADIUS_12),
          bottomLeft: Radius.circular(Sizes.RADIUS_12),
        ),
      ),
      child: Form(
        key: controller.productFormKey,
        child: Column(
          children: [
            const SpaceH12(),
            _buildImagePickerButton(context),
            const SpaceH8(),
            _buildTextFields(context),
            const SpaceH8(),
            _buildPriceFields(context),
            const SpaceH8(),
            _buildToggleGroup(context),
            const SpaceH8(),
            _buildSubmitButtons(context),
            const SpaceH4(),
          ],
        ),
      ),
    );
  }

  StaggeredGrid _buildTextFields(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: Responsive.getResponsiveValue(mobile: 1, tablet: 2),
      crossAxisSpacing: Sizes.PADDING_8,
      mainAxisSpacing: Sizes.PADDING_4,
      children: [
        Row(
          children: [
            Expanded(
              flex: 6,
              child: CustomTextFormField(
                autofocus: false,
                controller: controller.barcodeController,
                labelText: AppStrings.SCAN_BARCODE,
                prefixIconData: Iconsax.scan,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                suffixIconData: Iconsax.camera,
                onSuffixTap: () {
                  Get.to(
                    () => CustomBarcodeQRScanner(
                      onDetect: controller.searchByBarcode,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: CustomButton(
                buttonType: ButtonType.image,
                color: context.primaryColor,
                textColor: context.buttonTextColor,
                text: AppStrings.SAVE,
                image: Icon(
                  Icons.copy,
                  color: context.buttonTextColor,
                  size: Sizes.ICON_SIZE_24,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: context.scaffoldBackgroundColor,
                      context: context,
                      builder: (builder) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomScrollView(
                            slivers: [
                              const SpaceH12().sliverToBoxAdapter,
                              _buildSearchField(context).sliverToBoxAdapter,
                              const SpaceH12().sliverToBoxAdapter,
                              _buildProductList(),
                              const SpaceH12().sliverToBoxAdapter,
                            ],
                          ),
                        );
                      });
                },
                hasInfiniteWidth: false,
                verticalMargin: 0,
                buttonPadding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ],
        ),
        CustomTextFormField(
          autofocus: false,
          isRequired: true,
          controller: controller.nameController,
          labelText: AppStrings.NAME,
          prefixIconData: Iconsax.receipt,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          suffixIconData: Iconsax.camera,
          onChanged: controller.onProductNameChange,
          onSuffixTap: () {
            Get.to(
              () => CustomBarcodeQRScanner(
                onDetect: controller.addBarCodeWithName,
              ),
            );
          },
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.descriptionController,
          labelText: AppStrings.DESCRIPTION,
          prefixIconData: Iconsax.document_text,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: controller.onDescriptionChange,
        ),
        Row(children: [
          Expanded(
            flex: 6,
            child: GetBuilder<AddProductController>(
              builder: (_) {
                return FormField(
                  builder: (_) {
                    return CustomDropDownField<CategoryModel>(
                      controller: controller.parentCategoryController,
                      isRequired: true,
                      isEnabled: controller.parentCategories != null,
                      showLoading: controller.parentCategories == null,
                      showSearchBox: true,
                      title: AppStrings.PARENT_CATEGORY,
                      prefixIcon: Iconsax.forward_item,
                      onChange: controller.onParentCategoryChange,
                      items: controller.parentCategories,
                      selectedItem: controller.selectedParentCategory,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: CustomButton(
              buttonType: ButtonType.image,
              color: context.primaryColor,
              textColor: context.buttonTextColor,
              text: AppStrings.SAVE,
              image: Icon(
                Icons.add,
                color: context.buttonTextColor,
                size: Sizes.ICON_SIZE_24,
              ),
              onPressed: controller.onPressAddCategoryButton,
              hasInfiniteWidth: false,
              verticalMargin: 0,
              buttonPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),

        ]),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: Responsive.getResponsiveValue(mobile: 7, tablet: 13),
          child: CustomTextFormField(
            autofocus: false,
            controller: controller.productController.searchTextController,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: AppStrings.SEARCH_HINT_TEXT,
            labelColor: DarkTheme.darkShade3,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            prefixIconData: Iconsax.search_normal_1,
            suffixIconData: Iconsax.close_circle5,
            suffixIconColor: LightTheme.grayColorShade0,
            onSuffixTap: () {
              if (controller.productController.searchTextController.text !=
                  "") {
                controller.productController.searchTextController.clear();
                controller.productController.searchProducts("");
              }
            },
            onChanged: controller.productController.searchProducts,
          ),
        ),
        const SpaceW8(),
        Expanded(
          child: CustomButton(
            buttonType: ButtonType.image,
            color: context.primaryColor,
            image: const Icon(
              Iconsax.scan,
              color: DarkTheme.appBarIconsColor,
            ),
            buttonPadding:
                const EdgeInsets.symmetric(vertical: Sizes.PADDING_12),
            textColor: DarkTheme.appBarIconsColor,
            text: AppStrings.SCAN_BARCODE,
            hasInfiniteWidth: false,
            onPressed: () {
              Get.to(
                () => CustomBarcodeQRScanner(
                  onDetect: controller.productController.searchByBarcode,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return PagedSliverGrid<int, ProductModel>(
      pagingController: controller.productController.productsPaginationKey,
      shrinkWrapFirstPageIndicators: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.getResponsiveValue(
          mobile: 1,
          tablet: 2,
          desktop: 3,
        ),
        mainAxisExtent: Sizes.HEIGHT_100,
        crossAxisSpacing: Sizes.PADDING_8,
      ),
      builderDelegate: PagedChildBuilderDelegate<ProductModel>(
        animateTransitions: true,
        itemBuilder: (context, ProductModel product, _) {
          return controller
                  .productController.productsPaginationKey.itemList!.isEmpty
              ? const ProductShimmer()
              : InkWell(
                  onTap: () => controller.copyProductToForm(product),
                  child: ProductCard(product: product, showActiveToggle: true));
        },
        firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
          error: controller.productController.productsPaginationKey.error,
          onTryAgain:
              controller.productController.productsPaginationKey.refresh,
        ),
        noItemsFoundIndicatorBuilder: (_) => EmptyListIndicator(
          onTryAgain:
              controller.productController.productsPaginationKey.refresh,
        ),
        newPageProgressIndicatorBuilder: (_) =>
            const CupertinoActivityIndicator(
          radius: Sizes.ICON_SIZE_16,
        ),
        firstPageProgressIndicatorBuilder: (_) => const ProductShimmer(),
      ),
    );
  }

  StaggeredGrid _buildToggleGroup(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: Responsive.getResponsiveValue(mobile: 1, tablet: 2),
      crossAxisSpacing: Sizes.PADDING_8,
      mainAxisSpacing: Sizes.PADDING_2,
      children: [
        Obx(
          () => ToggleTileComponent(
            icon: controller.isTaxable.value
                ? Iconsax.money
                : Iconsax.money_forbidden,
            title: AppStrings.TAXABLE,
            value: controller.isTaxable.value,
            onChanged: controller.toggleTaxable,
          ),
        ),
      ],
    );
  }

  StaggeredGrid _buildPriceFields(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: Responsive.getResponsiveValue(mobile: 2, tablet: 2),
      crossAxisSpacing: Sizes.PADDING_8,
      mainAxisSpacing: Sizes.PADDING_4,
      children: [
        CustomTextFormField(
          autofocus: false,
          inputFormatters: controller.buildTextInputFormatters(),
          controller: controller.purchaseCostController,
          textAlign: TextAlign.end,
          hintText: '0.00',
          labelText: AppStrings.PURCHASE_COST,
          prefixIconData: Iconsax.dollar_square,
          textInputAction: TextInputAction.next,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onEditingComplete: () {
            String tempValue = controller.purchaseCostController.text;
            if (controller.purchaseCostController.text.startsWith('.')) {
              controller.purchaseCostController.text = '0$tempValue';
            }
            log.i(controller.purchaseCostController.text);
          },
          onChanged: controller.calculateMarginFromPurchaseCost,
          showClearButton: true,
          onSuffixTap: controller.purchaseCostController.clear,
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.salesPriceController,
          textAlign: TextAlign.end,
          hintText: '0.00',
          inputFormatters: controller.buildTextInputFormatters(),
          labelText: AppStrings.SALES_PRICE,
          prefixIconData: Iconsax.dollar_circle,
          textInputAction: TextInputAction.next,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: controller.calculateMarginFromSalesPrice,
          showClearButton: true,
          onSuffixTap: controller.salesPriceController.clear,
        ),
        FocusScope(
          onFocusChange: controller.onUnitPerCaseFocusLost,
          child: CustomTextFormField(
            autofocus: false,
            isRequired: true,
            controller: controller.unitPerCaseController,
            textAlign: TextAlign.end,
            hintText: '1',
            labelText: AppStrings.UNIT_PER_CASE,
            prefixIconData: Iconsax.shopping_bag,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            showClearButton: true,
            onSuffixTap: controller.unitPerCaseController.clear,
          ),
        ),
        FocusScope(
          onFocusChange: controller.onMarginPercentageFocusLost,
          child: CustomTextFormField(
            autofocus: false,
            controller: controller.marginController,
            textAlign: TextAlign.end,
            hintText: '0.00',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^(?!100(\.0{0,4})?$)\d{0,2}(\.\d{0,4})?$'),
              ),
            ],
            labelText: AppStrings.MARGIN,
            prefixIconData: Iconsax.percentage_circle,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: controller.calculateSalesPrice,
            showClearButton: true,
            onSuffixTap: controller.marginController.clear,
          ),
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.srpController,
          textAlign: TextAlign.end,
          hintText: '0.00',
          inputFormatters: controller.buildTextInputFormatters(),
          labelText: AppStrings.SRP,
          prefixIconData: Iconsax.dollar_square,
          textInputAction: TextInputAction.next,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: controller.calculateSrpPercentage,
          showClearButton: true,
          onSuffixTap: controller.srpController.clear,
        ),
        FocusScope(
          onFocusChange: controller.onSrpPercentageFocusLost,
          child: CustomTextFormField(
            autofocus: false,
            controller: controller.srpPercentageController,
            textAlign: TextAlign.end,
            hintText: '0.00',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^(?!100(\.0{0,4})?$)\d{0,2}(\.\d{0,4})?$'),
              ),
            ],
            labelText: AppStrings.SRP_PERCENTAGE,
            prefixIconData: Iconsax.percentage_square,
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: controller.calculateSrp,
            showClearButton: true,
            onSuffixTap: controller.srpPercentageController.clear,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerButton(BuildContext context) {
    return InkWell(
      onTap: () {}, //_showImagePickerBottomSheet(context),
      splashColor: context.fillColor,
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: context.titleSmall.color!,
        radius: const Radius.circular(Sizes.RADIUS_10),
        dashPattern: const [6, 4],
        strokeWidth: Sizes.WIDTH_1,
        borderPadding: const EdgeInsets.all(Sizes.PADDING_2),
        padding: const EdgeInsets.all(Sizes.PADDING_8),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.all(Radius.circular(Sizes.RADIUS_10)),
          child: GetBuilder<AddProductController>(
            builder: (_) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: (controller.productImage == null &&
                        (controller.arguments == null ||
                            controller.tempImageUrl == null))
                    ? _buildImagePlaceHolder(context)
                    : _buildImageWidget(context),
              );
            },
          ),
        ),
      ),
    );
  }

  Stack _buildImageWidget(BuildContext context) {
    return Stack(
      children: [
        (controller.arguments == null || controller.tempImageUrl == null)
            ? Image.file(
                controller.productImage!,
                height: Sizes.HEIGHT_160,
                width: Sizes.WIDTH_160,
                fit: BoxFit.cover,
              )
            : Image.network(controller.tempImageUrl ?? '',
                height: Sizes.HEIGHT_160,
                width: Sizes.WIDTH_160,
                fit: BoxFit.cover),
        Positioned(
          right: 0,
          child: InkWell(
            onTap: controller.removeProductImage,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.PADDING_4),
              child: CircleAvatar(
                backgroundColor: context.errorColor,
                radius: Sizes.RADIUS_12,
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: Sizes.ICON_SIZE_18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _buildImagePlaceHolder(BuildContext context) {
    return SizedBox(
      height: Sizes.HEIGHT_160,
      width: Sizes.WIDTH_160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.gallery,
            color: context.primaryColor,
            size: Sizes.ICON_SIZE_30,
          ),
          const SpaceH8(),
          Text(
            AppStrings.CAPTURE_OR_UPLOAD_IMAGE,
            style: context.captionLarge.copyWith(
              color: context.titleSmall.color!,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    CustomSnackBar.showCustomBottomSheet(
      color: context.scaffoldBackgroundColor,
      bottomSheet: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () =>
                  controller.pickImage(imageSource: ImageSource.camera),
              leading: Icon(
                Iconsax.camera,
                color: context.primaryColor,
              ),
              title: Text(
                AppStrings.CAPTURE_FROM_CAMERA,
                style: context.bodyText1.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              onTap: controller.pickImage,
              leading: Icon(
                Iconsax.gallery,
                color: context.primaryColor,
              ),
              title: Text(
                AppStrings.UPLOAD_FROM_GALLERY,
                style: context.bodyText1.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            const SpaceH12(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Obx(
              () => CustomButton(
                buttonType: ButtonType.loading,
                isLoading: controller.isLoading.value,
                color: context.primaryColor,
                textColor: context.buttonTextColor,
                text: AppStrings.SAVE,
                image: Icon(
                  Iconsax.document_download,
                  color: context.buttonTextColor,
                  size: Sizes.ICON_SIZE_24,
                ),
                onPressed: () async => await controller.saveProductForm(),
                hasInfiniteWidth: false,
                verticalMargin: 0,
              ),
            )),
        const SpaceW4(),
        if ((controller.arguments["backRoute"] &&
                (controller.arguments["fromQuickInvoice"] == null) ||
            (controller.isClone ?? false)))
          Expanded(
            child: CustomButton(
              buttonType: ButtonType.image,
              color: context.primaryColor,
              textColor: context.buttonTextColor,
              text: AppStrings.SAVE,
              image: Icon(
                Iconsax.more,
                color: context.buttonTextColor,
                size: Sizes.ICON_SIZE_24,
              ),
              onPressed: () {
                _showAdditionalOptionsSheet(context);
              },
              hasInfiniteWidth: false,
              verticalMargin: 0,
            ),
          ),
      ],
    );
  }

  void _showAdditionalOptionsSheet(BuildContext context) {
    CustomSnackBar.showCustomBottomSheet(
      color: context.scaffoldBackgroundColor,
      bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SpaceH12(),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Sizes.PADDING_14, vertical: Sizes.PADDING_2),
              child: CustomButton(
                buttonType: ButtonType.textWithImage,
                color: context.primaryColor,
                textColor: context.buttonTextColor,
                text: AppStrings.SAVE_AND_ADD_NEW,
                image: Icon(
                  Icons.add_box_outlined,
                  color: context.buttonTextColor,
                  size: Sizes.ICON_SIZE_24,
                ),
                onPressed: () async {
                  await controller.saveAndNewProductForm();
                },
                hasInfiniteWidth: true,
                verticalMargin: 5,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Sizes.PADDING_14, vertical: Sizes.PADDING_2),
              child: CustomButton(
                buttonType: ButtonType.textWithImage,
                color: context.primaryColor,
                textColor: context.buttonTextColor,
                text: AppStrings.SAVE_AND_CLONE,
                image: Icon(
                  Icons.copy_all,
                  color: context.buttonTextColor,
                  size: Sizes.ICON_SIZE_24,
                ),
                onPressed: () async {
                  await controller.saveAndCloneProductForm();
                },
                hasInfiniteWidth: true,
                verticalMargin: 5,
              ),
            ),
            const SpaceH20(),
          ]),
    );
  }
}
