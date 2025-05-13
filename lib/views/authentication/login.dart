import '../../exports/index.dart';

import 'components/login_form.dart';

class LoginScreen extends StatelessWidget with PortraitModeMixin {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageTemplate(
      overscroll: false,
      showMenuButton: false,
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
                fontFamily: AppStrings.MONTSERRAT,
              ),
            ),
            const SpaceH20(),
            Text(
              AppStrings.LOG_IN_EX,
              style: context.headline6.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: AppStrings.WORK_SANS,
              ),
            ),
            const SpaceH20(),
            Image.asset(
              AppAssets.ACCENT_LINE,
              color: context.primaryColor.withOpacity(.9),
              width: 100,
            ),
            const SpaceH48(),
            const LoginForm().addConstrainedBox(),
          ],
        ).sliverToBoxAdapter,
      ],
    ).scaffold();
  }
}
