import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';
import 'exports/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization();

  setPathUrlStrategy();

  Logger.configure();
  log.i(Flavor.environment);

  runApp(const MyApp());
}

Future initialization() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Poppins/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/fonts/Work_Sans/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await Future.wait([
   Firebase.initializeApp(),
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]),
  ]);

  await GetStorage.init(AppStrings.THEME_BOX_KEY);
  await GetStorage.init(AppStrings.PRODUCT_CONTAINER);
  await GetStorage.init(AppStrings.CUSTOMER_DETAIL_CONTAINER);
  await GetStorage.init().then((value) async {
    Get.lazyPut(() => ThemeController(), fenix: true);
    await Get.putAsync(() async => AuthManager(), permanent: true);
    Get.putAsync(() async => MyDrawerController(), permanent: true);
    // await Get.putAsync(() async => SplashController(), permanent: true);
  });
}

class MyApp extends GetView<ThemeController> {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: GetMaterialApp(
        navigatorKey: Get.key,
        debugShowCheckedModeBanner: false,
        title: AppStrings.APP_NAME,
        themeMode: ThemeMode.system,
        builder: (context, widget) {
          return AnimatedTheme(
            data: controller.getTheme,
            child: ResponsiveWrapper.builder(
              MediaQuery(
                // prevent font from scaling (some people use big/small device fonts)
                // but we want our app font to still the same and dont get affected
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: BouncingScrollWrapper.builder(context, widget!),
              ),
              defaultScale: true,
              breakpoints: const [
                ResponsiveBreakpoint.resize(450, name: MOBILE),
                ResponsiveBreakpoint.resize(800, name: TABLET),
                ResponsiveBreakpoint.resize(1000, name: TABLET),
                ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
            ),
          );
        },
        initialRoute: AppRoutes.SPLASH,
        getPages: AppPages.pages,
        defaultTransition: Transition.cupertino,
        smartManagement: SmartManagement.full,
      ),
    );
  }
}