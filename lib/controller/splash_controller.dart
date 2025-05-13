import '../exports/index.dart';
import '../routes/routes.dart';

class SplashController extends GetxController {
  // final AuthManager authManager = Get.find();
  //
  // Future<bool> initializeAuthentication() async {
  //   // TODO: API call to get app configurations
  //
  //   return authManager.checkLoginStatus(appConfig: appConfig!);
  // }
  //
  // late RxBool isConnected = false.obs;
  // late StreamSubscription<ConnectivityResult> _streamSubscription;
  //
  // @override
  // void onInit() async {
  //   super.onInit();
  //   initializeAuthentication();
  //
  //   initializeConnectivity();
  //   checkConnectivityStream();
  // }
  //
  // void checkConnectivityStream() async {
  //   _streamSubscription = Connectivity().onConnectivityChanged.listen(
  //     (status) {
  //       switch (status) {
  //         case ConnectivityResult.ethernet:
  //         case ConnectivityResult.mobile:
  //         case ConnectivityResult.wifi:
  //           if (!isConnected.value) {
  //             if (authManager.isLoggedIn.value == false) {
  //               authManager.checkLoginStatus(appConfig: appConfig!);
  //             }
  //             isConnected.value = true;
  //             if (WidgetsFlutterBinding.ensureInitialized()
  //                 .firstFrameRasterized) {
  //               Get.back();
  //             }
  //           }
  //           break;
  //         default:
  //           isConnected.value = false;
  //           if (WidgetsFlutterBinding.ensureInitialized()
  //               .firstFrameRasterized) {
  //             Get.toNamed(AppRoutes.offline);
  //           }
  //           break;
  //       }
  //     },
  //   );
  // }
  //
  // Future<void> initializeConnectivity() async {
  //   ConnectivityResult connectionStatus =
  //       await Connectivity().checkConnectivity();
  //
  //   switch (connectionStatus) {
  //     case ConnectivityResult.ethernet:
  //     case ConnectivityResult.mobile:
  //     case ConnectivityResult.wifi:
  //       isConnected = true.obs;
  //       break;
  //     default:
  //       isConnected = false.obs;
  //       break;
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   _streamSubscription.cancel();
  //   super.dispose();
  // }
}
