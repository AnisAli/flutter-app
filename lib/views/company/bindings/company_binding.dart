import '../../../exports/index.dart';

class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyController());
  }
}
