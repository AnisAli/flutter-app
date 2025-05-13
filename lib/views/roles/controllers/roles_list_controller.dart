import '../../../exports/index.dart';

class RolesListController extends GetxController {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  late RxBool isShimmerEffectLoading = true.obs;

  List<RoleModel> rolesList = [];

  @override
  void onInit() async {
    scaffoldKey = GlobalKey<ScaffoldState>();
    await getRoles();
    isShimmerEffectLoading(false);
    super.onInit();
  }

  Future<void> getRoles() async {
    return await BaseClient.safeApiCall(
      ApiConstants.GET_ROLES,
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        rolesList = RoleModel.listFromJson(response.data['data']);
      },
      onError: (e) {
        log.e(e);
      },
    );
  }

  Future<void> deleteRole(int? roleId) async {
    return await BaseClient.safeApiCall(
      '${ApiConstants.GET_ROLES}/$roleId',
      RequestType.delete,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        Get.snackbar(
          'Success',
          'Role deleted successfully!',
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
}
