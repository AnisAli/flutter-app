import 'package:otrack/views/company/components/company_info_form.dart';

import '../../../exports/index.dart';

class CompanyProfile extends GetView<CompanyController> {
  static const String routeName = '/companyProfile';

  const CompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      pinAppBar: true,
      simpleAppBar: _buildSimpleAppBar(context),
      customBottomNavigationBar: _buildSubmitButtons(context),
      scaffoldKey: controller.scaffoldKey,
      children: [
        Column(
          children: [
            Obx(() => controller.isShimmerEffect.value
                ? const ProductShimmer()
                : const CompanyInfoForm())
          ],
        ).sliverToBoxAdapter,
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildSubmitButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => CustomButton(
            buttonType: ButtonType.loading,
            isLoading: controller.isLoading.value,
            color: context.primaryColor,
            textColor: context.buttonTextColor,
            text: AppStrings.SAVE,
            onPressed: () async {
              controller.isLoading(true);
              await controller.onSaveCompanyInfo();
              controller.isLoading(false);
            },
            hasInfiniteWidth: true,
            verticalMargin: 0,
          ),
        ),
        const SpaceH8(),
        CustomButton(
          buttonType: ButtonType.text,
          isLoading: controller.isLoading.value,
          color: context.primaryColor,
          textColor: context.buttonTextColor,
          text: AppStrings.CANCEL,
          onPressed: () => Get.offAllNamed(AppRoutes.HOME),
          hasInfiniteWidth: true,
          verticalMargin: 0,
        ),
      ],
    );
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
        'Profile Details',
        style: context.titleMedium,
      ),
    );
  }
}
