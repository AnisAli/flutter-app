import '../../../exports/index.dart';

class AddUserListController extends GetxController {
  late final GlobalKey<FormState> userListFormKey;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController roleController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  late UserListModel argUserListModel;

  late RxBool isLoading;

  List<RoleModel>? roles;
  RoleModel? selectedRole;

  @override
  void onInit() async {
    userListFormKey = GlobalKey<FormState>();
    isLoading = false.obs;
    if (Get.arguments['pageType'] == 'new') {
      firstNameController = TextEditingController();
      lastNameController = TextEditingController();
      roleController = TextEditingController();
      emailController = TextEditingController();
    } else {
      argUserListModel = Get.arguments['userList'];
      firstNameController =
          TextEditingController(text: argUserListModel.firstName);
      lastNameController =
          TextEditingController(text: argUserListModel.lastName);
      roleController = TextEditingController(text: argUserListModel.role);
      emailController = TextEditingController(text: argUserListModel.email);
    }
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    await getUserRoles();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    if (Get.arguments['pageType'] == 'edit') {
      selectedRole =
          roles!.firstWhere((role) => role.id == argUserListModel.roleId);
      roleController.text = argUserListModel.role ?? '';
      update();
    }
  }

  Future<void> onUpdatePassword() async {
    isLoading(true);
    if (passwordController.text != confirmPasswordController.text ||
        passwordController.text.length < 6) {
      Get.snackbar(
        'Something went wrong!',
        margin: const EdgeInsets.only(bottom: 25),
        'Passwords requirements not matched\n * At least 6 characters long. \n * Confirm password mismatched',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      await updatePassword();
    }
    isLoading(false);
  }

  Future<void> onSaveUserForm() async {
    if (userListFormKey.currentState!.validate()) {
      isLoading(true);
      if (Get.arguments['pageType'] == 'new') {
        await saveNewUser();
      } else {
        await editUser();
      }
      isLoading(false);
    }
  }

  Future<void> updatePassword() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "password": "${passwordController.text}",
  }''';

    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_USERS_LIST}/${argUserListModel.id}/password',
      RequestType.put,
      headers: headers,
      data: body,
      onSuccess: (response) async {
        Get.snackbar(
          'Success',
          'Password updated successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        passwordController.clear();
        confirmPasswordController.clear();
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data["message"] ?? e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> editUser() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "email": "${emailController.text}",
    "firstName": "${firstNameController.text}",
    "lastName": "${lastNameController.text}",
    "roleId": "${selectedRole?.id}",
    "id": "${argUserListModel.id}",
  }''';

    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_USERS_LIST}/${argUserListModel.id}',
      RequestType.put,
      headers: headers,
      data: body,
      onSuccess: (response) async {
        Get.snackbar(
          'Success',
          'User edited successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.USERS_LIST);
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data["message"] ?? e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> saveNewUser() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "email": "${emailController.text}",
    "firstName": "${firstNameController.text}",
    "lastName": "${lastNameController.text}",
    "roleId": "${selectedRole?.id}",
    "password": "${passwordController.text}",
    "confirmPassword": "${confirmPasswordController.text}",
  }''';

    return await BaseClient.safeApiCall(
      ApiConstants.GET_USERS_LIST,
      RequestType.post,
      headers: headers,
      data: body,
      onSuccess: (response) async {
        Get.snackbar(
          'Success',
          'New User added successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.USERS_LIST);
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data["message"] ?? e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void onRoleChange(RoleModel? selected) {
    selectedRole = selected;
    roleController.text = selected?.id.toString() ?? '';
    update();
  }

  Future<void> getUserRoles() async {
    return await BaseClient.safeApiCall(
      ApiConstants.GET_ROLES,
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        roles = RoleModel.listFromJson(response.data['data']);
        update();
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    lastNameController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    roleController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
