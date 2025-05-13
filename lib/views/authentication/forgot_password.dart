import '../../../exports/index.dart';
import 'components/forgot_pass_form.dart';

class ForgotPassword extends StatelessWidget {
  static const String routeName = '/resetPassword';

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      showBackButton: true,
      overscroll: false,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogo(size: 80),
            const SpaceH12(),
            Text(
              AppStrings.APP_NAME,
              style: context.headline3.copyWith(
                color: context.primaryColor,
                fontFamily: 'Montserrat',
              ),
            ),
            const SpaceH20(),
            Text(
              AppStrings.FORGOT_PASSWORD_EX,
              style: context.headline6.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SpaceH20(),
            Image.asset(
              AppAssets.ACCENT_LINE,
              color: context.primaryColor.withOpacity(.9),
              width: 100,
            ),
            const SpaceH48(),
            const ForgotPassForm().addConstrainedBox(),
          ],
        ).sliverToBoxAdapter,
      ],
    ).scaffold();
  }
}
