import '../../../exports/index.dart';

class ForgotPassForm extends GetView<ForgotPassController> {
  const ForgotPassForm({Key? key}) : super(key: key);

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
              prefixIconData: Iconsax.sms5,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.emailValidator,
              onFieldSubmit: (s) => controller.sendForgotPassRequest(),
            ),
            const SpaceH48(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: Sizes.PADDING_8),
              child: GetBuilder<ForgotPassController>(
                builder: (_) {
                  return CustomButton(
                    buttonType: ButtonType.loading,
                    isLoading: controller.isLoading,
                    color: context.primaryColor,
                    textColor: context.buttonTextColor,
                    text: AppStrings.SEND_RESET_LINK,
                    onPressed: controller.sendForgotPassRequest,
                    hasInfiniteWidth: true,
                    verticalMargin: 0,
                  );
                },
              ),
            ),
            const SpaceH2(),
          ],
        ),
      ),
    );
  }
}
