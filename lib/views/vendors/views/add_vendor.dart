import 'package:otrack/views/vendors/components/vendor_info_form.dart';

import '../../../exports/index.dart';

class AddVendor extends GetView<AddVendorController> {
  static const String routeName = '/addVendor';

  const AddVendor({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      overscroll: false,
      customBottomNavigationBar: _buildSubmitButtons(context),
      appBarTitle: (controller.argsVendor == null)
          ? AppStrings.ADD_VENDOR
          : AppStrings.EDIT_VENDOR,
      children: [
        Column(
          children: const [
            VendorInfoForm(),
          ],
        ).sliverToBoxAdapter,
      ],
    ).scaffold();
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
          await controller.onSaveVendorForm();
        },
        hasInfiniteWidth: true,
        verticalMargin: 0,
      ),
    );
  }
}
