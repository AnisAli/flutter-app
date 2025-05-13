import 'package:flutter/cupertino.dart';
import '../../services/api/api_call_status.dart';

// switch between different widgets with animation
// depending on api call status
class MyWidgetsAnimator extends StatelessWidget {
  final ApiCallStatus apiCallStatus;
  final Widget Function() loadingWidget;
  final Widget Function() successWidget;
  final Widget Function() errorWidget;
  final Widget Function()? emptyWidget;
  final Widget Function()? holdingWidget;
  final Widget Function()? refreshWidget;
  final Duration? animationDuration;
  final Widget Function(Widget, Animation)? transitionBuilder;
  // this will be used to not hide the success widget when refresh
  // if its true success widget will still be shown
  // if false refresh widget will be shown or empty box if passed (refreshWidget) is null
  final bool hideSuccessWidgetWhileRefreshing;

  const MyWidgetsAnimator({
    Key? key,
    required this.apiCallStatus,
    required this.loadingWidget,
    required this.errorWidget,
    required this.successWidget,
    this.holdingWidget,
    this.emptyWidget,
    this.refreshWidget,
    this.animationDuration,
    this.transitionBuilder,
    this.hideSuccessWidgetWhileRefreshing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration ?? const Duration(milliseconds: 300),
      child: _getChild()(),
      transitionBuilder: transitionBuilder ??
          (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
    );
  }

  _getChild() {
    if (apiCallStatus == ApiCallStatus.success) {
      return successWidget;
    } else if (apiCallStatus == ApiCallStatus.error) {
      return errorWidget;
    } else if (apiCallStatus == ApiCallStatus.holding) {
      return holdingWidget ??
          () {
            return const SizedBox();
          };
    } else if (apiCallStatus == ApiCallStatus.loading) {
      return loadingWidget;
    } else if (apiCallStatus == ApiCallStatus.empty) {
      return emptyWidget ??
          () {
            return const SizedBox();
          };
    } else if (apiCallStatus == ApiCallStatus.refresh) {
      return refreshWidget ??
          (hideSuccessWidgetWhileRefreshing
              ? successWidget
              : () {
                  return const SizedBox();
                });
    } else {
      return successWidget;
    }
  }
}

// // hold data coming from api
// List<ProductModel>? data;
// // api call status
// ApiCallStatus apiCallStatus = ApiCallStatus.holding;
//
// // getting data from api
// getData() async {
//   // *) perform api call
//   await BaseClient.safeApiCall(
//     ApiConstants.GET_PRODUCT_LIST, // url
//     RequestType.get, // request type (get,post,delete,put)
//     headers: await BaseClient.generateHeaders(),
//     onLoading: () {
//       // *) indicate loading state
//       apiCallStatus = ApiCallStatus.loading;
//       update();
//     },
//     onSuccess: (response) {
//       // api done successfully
//       data = ProductResponseModel.fromJson(response.data).products;
//       // *) indicate success state
//       apiCallStatus = ApiCallStatus.success;
//       update();
//     },
//     // if you don't pass this method base client
//     // will automatically handle error and show message to user
//     onError: (error) {
//       // show error message to user
//       BaseClient.handleApiError(error);
//       // *) indicate error status
//       apiCallStatus = ApiCallStatus.error;
//       update();
//     },
//   );
// }

// Widget _buildProductList() {
//   return GetBuilder<ProductController>(
//     builder: (_) {
//       return MyWidgetsAnimator(
//         apiCallStatus: controller.apiCallStatus,
//         loadingWidget: () => const Center(
//           child: CircularProgressIndicator(),
//         ),
//         errorWidget: () => const Center(
//           child: Text('Something went wrong !'),
//         ),
//         successWidget: () => ListView.separated(
//           padding: const EdgeInsets.symmetric(vertical: Sizes.PADDING_8),
//           shrinkWrap: true,
//           itemCount: controller.data!.length,
//           physics: const NeverScrollableScrollPhysics(),
//           separatorBuilder: (_, __) => const SpaceH8(),
//           itemBuilder: (ctx, index) =>
//               ProductCard(product: controller.data![index]),
//         ),
//       );
//     },
//   );
// }
