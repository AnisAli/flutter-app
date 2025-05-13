import 'package:otrack/views/roles/components/add_role_form.dart';

import '../../../exports/index.dart';

class AddRole extends GetView<AddRoleController> {
  static const String routeName = '/addRole';

  const AddRole({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      showMenuButton: false,
      showThemeButton: false,
      simpleAppBar: _buildSimpleAppBar(context),
      customBottomNavigationBar: _buildSubmitButtons(context),
      children: [
        Column(
          children: const [AddRoleForm()],
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
        onPressed: () async => await controller.onSaveRoleForm(),
        hasInfiniteWidth: true,
        verticalMargin: 0,
      ),
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
        Get.arguments['pageType'] == 'edit' ? 'Edit Role' : 'New Role',
        style: context.titleMedium,
      ),
    );
  }
}
