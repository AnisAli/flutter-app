import '../../../exports/index.dart';

class AddUserListForm extends GetView<AddUserListController> {
  const AddUserListForm({super.key});

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
        key: controller.userListFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH8(),
            Text(
              "Customer's Info",
              style: context.titleLarge.copyWith(fontWeight: FontWeight.w500),
            ),
            const SpaceH12(),
            _buildTextFields(context),
            const SpaceH24(),
            if (Get.arguments['pageType'] != 'edit') ...[
              Text(
                "Credentials",
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w500),
              ),
              const SpaceH12(),
              _buildPasswordFields(context),
              const SpaceH12(),
            ],
            if (Get.arguments['pageType'] == 'edit')
              _dropDownPasswordUpdateFields(context),
            const SpaceH12(),
          ],
        ),
      ),
    );
  }

  Widget _dropDownPasswordUpdateFields(BuildContext context) {
    RxBool isExpanded = false.obs;
    return ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: Obx(() => ExpansionTile(
              title: Text(
                "Credentials",
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w500),
              ),
              trailing: const SizedBox(),
              tilePadding: EdgeInsets.zero,
              leading: isExpanded.value
                  ? Icon(
                      Icons.keyboard_arrow_up,
                      color: context.iconColor1,
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color: context.iconColor1,
                    ),
              onExpansionChanged: (val) {
                isExpanded(val);
              },
              children: [
                _buildPasswordFields(context),
                const SpaceH12(),
                CustomButton(
                  buttonType: ButtonType.loading,
                  isLoading: controller.isLoading.value,
                  color: context.primaryColor,
                  textColor: context.buttonTextColor,
                  text: AppStrings.UPDATE_PASSWORD,
                  image: Icon(
                    Icons.password,
                    color: context.buttonTextColor,
                    size: Sizes.ICON_SIZE_24,
                  ),
                  onPressed: () async {
                    controller.onUpdatePassword();
                  },
                  hasInfiniteWidth: true,
                  verticalMargin: 0,
                ),
                const SpaceH12(),
              ],
            )));
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
          controller: controller.emailController,
          labelText: AppStrings.EMAIL,
          prefixIconData: Icons.email,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        CustomTextFormField(
          autofocus: false,
          isRequired: true,
          controller: controller.firstNameController,
          labelText: AppStrings.FIRST_NAME,
          prefixIconData: Iconsax.receipt,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        CustomTextFormField(
          autofocus: false,
          isRequired: false,
          controller: controller.lastNameController,
          labelText: AppStrings.LAST_NAME,
          prefixIconData: Iconsax.receipt,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        GetBuilder<AddUserListController>(
          builder: (_) {
            return FormField(
              builder: (_) {
                return CustomDropDownField<RoleModel>(
                  controller: controller.roleController,
                  isRequired: true,
                  isEnabled: controller.roles != null,
                  showLoading: controller.roles == null,
                  showSearchBox: true,
                  title: AppStrings.ROLES,
                  prefixIcon: Iconsax.user,
                  onChange: controller.onRoleChange,
                  items: controller.roles,
                  selectedItem: controller.selectedRole,
                );
              },
            );
          },
        ),
      ],
    );
  }

  StaggeredGrid _buildPasswordFields(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: Responsive.getResponsiveValue(mobile: 1, tablet: 2),
      crossAxisSpacing: Sizes.PADDING_8,
      mainAxisSpacing: Sizes.PADDING_4,
      children: [
        CustomTextFormField(
          autofocus: false,
          isRequired: Get.arguments['pageType'] == 'new' ? true : false,
          controller: controller.passwordController,
          labelText: AppStrings.PASSWORD,
          prefixIconData: Iconsax.password_check,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        CustomTextFormField(
          autofocus: false,
          isRequired: false,
          controller: controller.confirmPasswordController,
          labelText: AppStrings.CONFIRM_PASSWORD,
          prefixIconData: Iconsax.password_check,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
