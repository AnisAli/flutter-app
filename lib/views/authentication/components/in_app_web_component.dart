import 'dart:convert';
import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:otrack/exports/index.dart';

class InAppWebComponent extends StatefulWidget {
  const InAppWebComponent({Key? key}) : super(key: key);

  @override
  State<InAppWebComponent> createState() => _InAppWebComponentState();
}

class _InAppWebComponentState extends State<InAppWebComponent> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        supportZoom: false,
        cacheEnabled: false,
        clearCache: true,
        useShouldInterceptFetchRequest: true,
        useShouldInterceptAjaxRequest: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  RxString url = "".obs;
  RxDouble progress = 0.0.obs;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: context.scaffoldBackgroundColor,
            iconTheme: IconThemeData(
              color: context.iconColor1, //change your color here
            ),
            title: Text(
              "Otrack Invoice",
              style: context.titleLarge,
            )),
        body: SafeArea(
            child: Column(children: [
          Flexible(
              flex: 1,
              child: Obx(
                () => Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                          url: Uri.parse("https://app.otrack.io/register")),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      gestureRecognizers: null,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        this.url.value = url.toString();
                        if (url.toString() == 'https://app.otrack.io/#') {
                          Get.back();
                        }
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunch(url.value)) {
                            // Launch the App
                            await launch(
                              url.value,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        this.url.value = url.toString();
                      },
                      shouldInterceptAjaxRequest: (controller, request) {
                        if (request.url.toString() ==
                            'https://api.otrack.io/v1/company') {
                          if (request.data != null) {
                            // Parse the JSON response
                            Map<String, dynamic> responseMap =
                                json.decode(request.data);
                            bool? isSetupCompleted =
                                responseMap['isSetupCompleted'];
                            if (isSetupCompleted != null && isSetupCompleted) {
                              Get.back();
                            }
                          }
                        }
                        return Future.value(null);
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        this.progress.value = progress / 100;
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        this.url.value = url.toString();
                      },
                      onConsoleMessage: (controller, consoleMessage) {},
                    ),
                    progress.value < 1.0
                        ? LinearProgressIndicator(value: progress.value)
                        : Container(),
                  ],
                ),
              )),
        ])));
  }

  Widget customIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                context.scaffoldBackgroundColor),
          ),
          onPressed: onPressed,
          child: Icon(
            icon,
            color: context.iconColor1,
          )),
    );
  }
}
