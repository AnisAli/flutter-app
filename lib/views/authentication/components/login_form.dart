import '../../../exports/index.dart';

class LoginForm extends GetView<LoginController> {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.PADDING_20),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              autofocus: false,
              controller: controller.emailController,
              isRequired: true,
              labelText: AppStrings.EMAIL,
              prefixIconData: Iconsax.sms,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.emailValidator,
            ),
            Obx(
              () => CustomTextFormField(
                autofocus: false,
                controller: controller.passwordController,
                isRequired: true,
                labelText: AppStrings.PASSWORD,
                obscureText: !controller.isPasswordVisible.value,
                prefixIconData: Iconsax.key,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: Validators.passwordValidator,
                suffixIconData: controller.isPasswordVisible.value
                    ? Iconsax.eye_slash
                    : Iconsax.eye,
                onSuffixTap: controller.togglePassword,
                onFieldSubmit: (s) => controller.loginByEmailPass(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.FORGOT_PASS),
                child: Text(
                  AppStrings.FORGOT_PASSWORD,
                  style: context.bodyText1.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SpaceH24(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: Sizes.PADDING_8),
              child: GetBuilder<LoginController>(
                builder: (_) {
                  return CustomButton(
                    buttonType: ButtonType.loading,
                    isLoading: controller.isLoading,
                    color: context.primaryColor,
                    textColor: context.buttonTextColor,
                    text: AppStrings.LOG_IN,
                    onPressed: controller.loginByEmailPass,
                    hasInfiniteWidth: true,
                    verticalMargin: 0,
                  );
                },
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: Sizes.PADDING_8),
            //   child: GetBuilder<LoginController>(
            //     builder: (_) {
            //       return CustomButton(
            //         buttonType: ButtonType.loading,
            //         isLoading: controller.isLoading,
            //         color: context.primaryColor,
            //         textColor: context.buttonTextColor,
            //         text: 'Sign Up',
            //         onPressed: () {
            //           Get.to(() => const InAppWebComponent());
            //         },
            //         hasInfiniteWidth: true,
            //         verticalMargin: 0,
            //       );
            //     },
            //   ),
            // ),
            // const SpaceH2(),
          ],
        ),
      ),
    );
  }
}
