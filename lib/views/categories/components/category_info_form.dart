import 'package:otrack/views/categories/controllers/add_category_controller.dart';

import '../../../exports/index.dart';

class CategoryInfoFrom extends GetView<AddCategoryController> {
  const CategoryInfoFrom({super.key});

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
        key: controller.categoryFormKey,
        child: Column(
          children: [
            const SpaceH12(),
            _buildImagePickerButton(context),
            const SpaceH8(),
            _buildTextFields(context),
            const SpaceH8(),
            const SpaceH180(),
            const SpaceH60(),
            const SpaceH96(),
            const SpaceH96(),
            _buildSubmitButtons(context),
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
        CustomTextFormField(
          autofocus: false,
          isRequired: true,
          controller: controller.categoryNameController,
          labelText: AppStrings.NAME,
          prefixIconData: Iconsax.receipt,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        Obx(
          () => ToggleTileComponent(
            icon: controller.isShowOnWeb.value
                ? Icons.web_asset
                : Icons.web_asset_off,
            title: AppStrings.SHOW_ON_WEB,
            value: controller.isShowOnWeb.value,
            onChanged: controller.isShowOnWeb,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButtons(BuildContext context) {
    return Obx(
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
        onPressed: () async {
          await controller.onSaveCategoryForm();
        },
        hasInfiniteWidth: true,
        verticalMargin: 0,
      ),
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
          child: GetBuilder<AddCategoryController>(
            builder: (_) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildImagePlaceHolder(context),
              );
            },
          ),
        ),
      ),
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
}
