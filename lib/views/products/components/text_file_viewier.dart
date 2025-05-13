import 'dart:io';
import 'package:otrack/exports/index.dart';
import 'package:share_plus/share_plus.dart';

class TextFileViewer extends StatelessWidget {
  final String filePath;

  const TextFileViewer({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'File Viewer',
          style: context.titleLarge,
        ),
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
              await shareFile(filePath);
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _readTextFile(filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error loading file',
              style: context.titleMedium,
            ));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data ?? 'No content'),
            );
          }
        },
      ),
    );
  }

  // Function to read the text file
  Future<String> _readTextFile(String filePath) async {
    try {
      File file = File(filePath);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      Get.snackbar(
        'Error reading file!',
        '$e',
        margin: const EdgeInsets.only(bottom: 25),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return 'Error reading file';
    }
  }

  Future shareFile(String path) async {
    XFile pdf = XFile(path);
    try {
      final result = await Share.shareXFiles([pdf]);
      if (result.status == ShareResultStatus.success) {
        Get.snackbar(
          'Success',
          'File has been shared successfully!',
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
