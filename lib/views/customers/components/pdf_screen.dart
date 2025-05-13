import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import '../../../exports/index.dart';
import 'package:share_plus/share_plus.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({Key? key, this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  RxInt currentPage = 0.obs;
  RxBool isReady = false.obs;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDF File",
          style: context.titleMedium.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Platform.isAndroid
                ? Icon(
                    Icons.share,
                    color: context.iconColor1,
                  )
                : const Icon(
                    CupertinoIcons.share,
                    color: Colors.black,
                  ),
            onPressed: () async {
              await shareFile(widget.path ?? '');
            },
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: <Widget>[
            PDFView(
              filePath: widget.path,
              enableSwipe: true,
              autoSpacing: false,
              nightMode: context.isDark,
              defaultPage: currentPage.value,
              fitPolicy: FitPolicy.BOTH,
              onRender: (pages) {
                isReady.value = true;
              },
              onError: (error) {
                Get.snackbar(
                  'Something went wrong!',
                  margin: const EdgeInsets.only(bottom: 25),
                  error.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              },
              onPageError: (page, error) {
                errorMessage = '$page: ${error.toString()}';
                Get.snackbar(
                  'Something went wrong!',
                  margin: const EdgeInsets.only(bottom: 25),
                  errorMessage,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {},
              onPageChanged: (int? page, int? total) {
                currentPage.value = page ?? 0;
              },
            ),
            errorMessage.isEmpty
                ? !isReady.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()
                : Center(
                    child: Text(errorMessage),
                  )
          ],
        ),
      ),
    );
  }

  Future shareFile(String path) async {
    XFile pdf = XFile(path);
    try {
      final result = await Share.shareXFiles([pdf]);
      if (result.status == ShareResultStatus.success) {
        Get.snackbar(
          'Success',
          'PDF has been shared successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on Exception catch (e) {
      Get.snackbar(
        'Error occurred!',
        '$e',
        margin: const EdgeInsets.only(bottom: 25),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
