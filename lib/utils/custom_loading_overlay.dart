import '../exports/index.dart';

/// this method will show black overlay which look like dialog
/// and it will have loading animation inside of it
/// this will make sure user cant interact with ui until
/// any (async) method is executing cuz it will wait for async function
/// to end and then it will dismiss the overlay
class CustomLoading {
  Future<void> showLoadingOverLay({
    required Future<dynamic> Function() asyncFunction,
    String? title = AppStrings.APP_NAME,
    String? msg = AppStrings.LOADING,
    bool showTitle = false,
    bool showMsg = false,
  }) async {
    await Get.showOverlay(
      asyncFunction: () async {
        try {
          await asyncFunction();
        } catch (error) {
          log.e(error);
          log.e(StackTrace.current);
        }
      },
      loadingWidget: Center(
        child: _getLoadingIndicator(
          msg: msg,
          title: title!,
          showTitle: showTitle,
          showMsg: showMsg,
        ),
      ),
      opacity: 0.7,
      opacityColor: Colors.black,
    );
  }

  Widget _getLoadingIndicator({
    required String title,
    String? msg,
    bool showTitle = false,
    bool showMsg = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.PADDING_32,
        vertical: Sizes.PADDING_20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
        color: Get.theme.scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomLoader(),
          if (showTitle) ...[
            const SpaceH16(),
            Text(
              title,
              style: Get.theme.textTheme.headline4!.copyWith(
                color: Get.theme.primaryColor,
                fontFamily: AppStrings.MONTSERRAT,
              ),
            ),
          ],
          const SpaceH16(),
          CupertinoActivityIndicator(color: Get.theme.iconTheme.color),
          if (showMsg) ...[
            const SpaceH16(),
            Text(
              msg ?? AppStrings.LOADING,
              style: Get.theme.textTheme.bodyText1,
            ),
          ],
        ],
      ),
    );
  }

  static SpinKitThreeBounce get spinKitThreeBounceDark => SpinKitThreeBounce(
        color: Get.theme.primaryColor,
        size: Sizes.HEIGHT_20,
      );

  static SpinKitThreeBounce get spinKitThreeBounceLight => SpinKitThreeBounce(
        color: Get.theme.primaryColor,
        size: Sizes.HEIGHT_20,
      );

  static CupertinoActivityIndicator get cupertinoIndicatorLarge =>
      const CupertinoActivityIndicator(
        radius: Sizes.ICON_SIZE_20,
      );

  static CupertinoActivityIndicator get cupertinoIndicatorMedium =>
      const CupertinoActivityIndicator(
        radius: Sizes.ICON_SIZE_14,
      );

  static CupertinoActivityIndicator get cupertinoIndicatorSmall =>
      const CupertinoActivityIndicator(
        radius: Sizes.ICON_SIZE_10,
      );
}
