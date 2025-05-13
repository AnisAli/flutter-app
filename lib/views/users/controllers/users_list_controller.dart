import '../../../exports/index.dart';

class UsersListController extends GetxController {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  late RxBool isShimmerEffectLoading = true.obs;

  List<UserListModel> usersList = [];

  @override
  void onInit() async {
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.onInit();
    await getUsersList();
  }

  Future getUsersList() async {
    final headers = await BaseClient.generateHeaders();
    return await BaseClient.safeApiCall(
      ApiConstants.GET_USERS_LIST,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        usersList = parseUsersList(response.data["data"]);
        isShimmerEffectLoading(false);
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data ?? e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  List<UserListModel> parseUsersList(dynamic json) {
    List<UserListModel> usersList = [];
    if (json != null && json is List) {
      usersList = json.map<UserListModel>((categoryJson) {
        return UserListModel.fromJson(categoryJson);
      }).toList();
    }
    return usersList;
  }
}
