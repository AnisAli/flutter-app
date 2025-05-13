import 'package:otrack/views/users/components/add_user_list_form.dart';

import '../../../exports/index.dart';

class AddUserList extends GetView<AddUserListController> {
  static const String routeName = '/addUserList';

  const AddUserList({super.key});

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
          children: const [
            AddUserListForm(),
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
        onPressed: () async => await controller.onSaveUserForm(),
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
        Get.arguments['pageType'] == 'edit' ? 'Edit User' : 'New User',
        style: context.titleMedium,
      ),
    );
  }
}
