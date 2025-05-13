import '../../../exports/index.dart';

class AddRoleController extends GetxController {
  late final GlobalKey<FormState> addRoleFormKey;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late ApplicationPermissionsModel applicationPermissionsModel =
      ApplicationPermissionsModel();
  late Map<int, RxBool> checkListGates = {};

  late RoleModel argRoleModel;

  late RxBool isLoading;
  late RxBool onlyForUpdateState = false.obs;

  @override
  void onInit() async {
    addRoleFormKey = GlobalKey<FormState>();
    isLoading = true.obs;
    if (Get.arguments['pageType'] == 'new') {
      nameController = TextEditingController();
      descriptionController = TextEditingController();
    } else {
      argRoleModel = Get.arguments['role'];
      nameController = TextEditingController(text: argRoleModel.name);
      descriptionController =
          TextEditingController(text: argRoleModel.description);
    }
    await getApplicationPermissions();
    if (Get.arguments['pageType'] == 'new') {
      initializingCheckListGates([]);
    } else {
      initializingCheckListGates(argRoleModel.permissions ?? []);
    }
    isLoading(false);
    super.onInit();
  }

  List<int> getTrueKeys(Map<int, RxBool> map) {
    List<int> trueKeys = [];
    map.forEach((key, value) {
      if (value.value) {
        trueKeys.add(key);
      }
    });
    return trueKeys;
  }

  void initializingCheckListGates(List<int> keysToSetTrue) {
    checkListGates = {
      for (var i = 0; i < applicationPermissionsModel.permissions!.length; i++)
        if (keysToSetTrue
            .contains(applicationPermissionsModel.permissions![i].id ?? 0))
          applicationPermissionsModel.permissions![i].id ?? 0: true.obs
        else
          applicationPermissionsModel.permissions![i].id ?? 0: false.obs,
    };
  }

  void onOpenPermissionMainTile(int index, bool isExpanded) {}

  Future<void> onSaveRoleForm() async {
    if (addRoleFormKey.currentState!.validate()) {
      isLoading(true);
      if (Get.arguments['pageType'] == 'new') {
        await saveNewRole();
      } else {
        await editRole();
      }
      isLoading(false);
    }
  }

  Future<void> editRole() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "id": ${argRoleModel.id},
    "name": "${nameController.text}",
    "description": "${descriptionController.text}",
    "isCoreRole": ${false},
    "permissions": ${getTrueKeys(checkListGates)},
  }''';

    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_ROLES}/${argRoleModel.id}',
      RequestType.put,
      headers: headers,
      data: body,
      onSuccess: (response) async {
        Get.snackbar(
          'Success',
          'Role edited successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.ROLES_LIST);
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

  Future<void> saveNewRole() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "name": "${nameController.text}",
    "description": "${descriptionController.text}",
    "isCoreRole": ${false},
    "permissions": ${getTrueKeys(checkListGates)},
  }''';

    return await BaseClient.safeApiCall(
      ApiConstants.GET_ROLES,
      RequestType.post,
      headers: headers,
      data: body,
      onSuccess: (response) async {
        Get.snackbar(
          'Success',
          'New Role added successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.ROLES_LIST);
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

  Future<void> getApplicationPermissions() async {
    return await BaseClient.safeApiCall(
      ApiConstants.GET_ROLE_PERMISSIONS,
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        applicationPermissionsModel =
            ApplicationPermissionsModel.fromJson(response.data["data"][0]);
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
}
