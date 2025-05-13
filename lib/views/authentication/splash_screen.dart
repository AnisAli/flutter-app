import '../../exports/index.dart';

class SplashScreen extends StatelessWidget with PortraitModeMixin {
  static const String routeName = '/splashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: _buildSplashContent(context),
      splashIconSize: Sizes.HEIGHT_240,
      centered: true,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: context.scaffoldBackgroundColor,
      screenFunction: () async {
        try {
          await AuthManager.instance.getUserDetails();
          return AuthManager.instance.isLoggedIn
              ? HomePage()
              : const LoginScreen();
        } catch (e) {
          return const GenericErrorIndicator();
        }
      },
    );
  }

  Column _buildSplashContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const CustomLoader(),
        const SpaceH16(),
        Text(
          AppStrings.APP_NAME,
          style: context.headline4.copyWith(
            color: context.primaryColor,
            fontFamily: AppStrings.MONTSERRAT,
          ),
        ),
        const SpaceH16(),
        CupertinoActivityIndicator(color: context.iconColor1)
      ],
    );
  }
}
