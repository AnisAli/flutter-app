import '../../../exports/index.dart';

class ForgotPassController extends GetxController {
  late GlobalKey<FormState>? formKey;

  late TextEditingController emailController;

  User? user;

  bool isLoading = false;

  void toggleLoading({bool value = false}) {
    isLoading = value;
    update();
  }

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    super.onInit();
  }

  Future<void> sendForgotPassRequest() async {
    try {
      toggleLoading(value: true);
      if (formKey!.currentState!.validate()) {
        formKey!.currentState!.save();

        await AuthManager().forgotPassword(email: emailController.text.trim());
        // emailController.clear();
      }
    } finally {
      toggleLoading();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    formKey == null;

    super.dispose();
  }
}
