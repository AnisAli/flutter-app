import '../exports/index.dart';

class AuthManager extends GetxController {
  static AuthManager instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserData? _userData;
  PermissionsModel? _userPermissions;
  bool get isLoggedIn => _firebaseUser.value != null;

  late Rx<User?> _firebaseUser;
  Rx<UserData?> get user => _userData.obs;
  PermissionsModel get userPermissions => _userPermissions!;
  Future<String?> get token async => await _firebaseUser.value!.getIdToken();

  @override
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  bool hasAccessTo(String permission) {
    final permissions = _userPermissions?.data?.permissions;
    if (permissions != null) {
      return permissions.contains(permission);
    }
    return false;
  }

  Future<void> getUserDetails() async {
    if (isLoggedIn) {
      await BaseClient.safeApiCall(
        ApiConstants.GET_USER_DATA,
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        onSuccess: (response) {
          _userData = UserData.fromJson(response.data);
          // *) indicate success state
          // apiCallStatus = ApiCallStatus.success;
          update();
        },
        onError: (e) {},
      );
      await BaseClient.safeApiCall(
        ApiConstants.GET_USER_PERMISSIONS,
        RequestType.get,
        headers: await BaseClient.generateHeaders(),
        onSuccess: (response) {
          _userPermissions = PermissionsModel.fromJson(response.data);
          // *) indicate success state
          // apiCallStatus = ApiCallStatus.success;
          update();
        },
        onError: (e) {},
      );
      Get.find<MyDrawerController>().resetIndex();
    }
  }

  void _setInitialScreen(User? user) async {
    if (WidgetsFlutterBinding.ensureInitialized().firstFrameRasterized) {
      if (user == null) {
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        await CustomLoading().showLoadingOverLay(
          asyncFunction: () => getUserDetails(),
        );
        Get.offAllNamed(AppRoutes.HOME);
      }
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      AppException.firebase(error);
    }
  }

  Future<void> test() async {
    try {
      await CustomLoading().showLoadingOverLay(
        asyncFunction: () => Future.delayed(
          const Duration(seconds: 2),
          () async => log.i(
            await _auth.currentUser!.getIdToken(),
          ),
        ),
      );
    } on FirebaseAuthException catch (error) {
      AppException.firebase(error);
    }
  }

  Future<void> logout() async {
    try {
      return _auth.signOut();
    } on FirebaseAuthException catch (error) {
      AppException.firebase(error);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      AppException.firebase(error);
    }
  }
}
