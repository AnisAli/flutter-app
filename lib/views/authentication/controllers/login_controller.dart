import '../../../exports/index.dart';

class LoginController extends GetxController {
  late GlobalKey<FormState>? formKey;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  User? user;

  bool isLoading = false;
  RxBool isPasswordVisible = false.obs;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleLoading({bool value = false}) {
    isLoading = value;
    update();
  }

  Future<void> loginByEmailPass() async {
    try {
      toggleLoading(value: true);
      if (formKey!.currentState!.validate()) {
        formKey!.currentState!.save();

        await AuthManager()
            .login(
              email: emailController.text.trim(),
              password: passwordController.text,
            )
            .then((value) => value);

        if (AuthManager.instance.isLoggedIn) {
          emailController.clear();
          passwordController.clear();
        }
      }
    } finally {
      toggleLoading();
    }
  }

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    formKey == null;

    super.dispose();
  }
}
