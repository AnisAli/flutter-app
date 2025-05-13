import '../../../exports/index.dart';

class ForgotPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPassController());
  }
}
