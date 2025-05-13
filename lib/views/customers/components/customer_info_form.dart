import '../../../exports/index.dart';

class CustomerInfoForm extends GetView<AddCustomerController> {
  const CustomerInfoForm({super.key});

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
        key: controller.customerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SpaceH12(),
            _buildTextFields(context),
            const SpaceH96(),
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
        CustomTextFormField(
          autofocus: false,
          isRequired: true,
          controller: controller.customerNameController,
          labelText: AppStrings.CUSTOMER_NAME,
          prefixIconData: Iconsax.receipt,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: controller.onCustomerNameChange,
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.companyNameController,
          labelText: AppStrings.COMPANY_NAME,
          prefixIconData: Iconsax.document_text,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: controller.onCompanyNameChange,
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.emailAddressController,
          labelText: AppStrings.EMAIL_ADDRESS,
          prefixIconData: Icons.email_outlined,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
        ),
        CustomTextFormField(
          autofocus: false,
          hintText: '123-456-7890',
          controller: controller.phoneNumberController,
          labelText: AppStrings.PHONE_NO,
          prefixIconData: Icons.phone_android,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
            MaskTextInputFormatter(
                mask: '###-###-####', filter: {"#": RegExp(r'[0-9]')}),
          ],
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.streetAddressController,
          labelText: AppStrings.STREET_ADDRESS,
          prefixIconData: Icons.house_outlined,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.streetAddress,
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.cityController,
          labelText: AppStrings.CITY,
          prefixIconData: Icons.location_city_outlined,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        CustomDropDownField<String>(
          controller: controller.stateController,
          showSearchBox: true,
          title: AppStrings.STATE,
          prefixIcon: Icons.map_outlined,
          onChange: controller.onStateChange,
          items: AppStrings.usStates,
          selectedItem: controller.selectedState,
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.zipCodeController,
          labelText: AppStrings.ZIP_CODE,
          prefixIconData: CupertinoIcons.compass,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
        ),
        Obx(
          () => ToggleTileComponent(
            icon: controller.isTaxable.value
                ? Iconsax.money
                : Iconsax.money_forbidden,
            title: AppStrings.TAXABLE,
            value: controller.isTaxable.value,
            onChanged: controller.isTaxable,
          ),
        ),
        CustomTextFormField(
          autofocus: false,
          controller: controller.saleTaxIdController,
          labelText: AppStrings.SALE_TAX_ID,
          prefixIconData: CupertinoIcons.tag_fill,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
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
          await controller.onSaveCustomerForm();
        },
        hasInfiniteWidth: true,
        verticalMargin: 0,
      ),
    );
  }
}
