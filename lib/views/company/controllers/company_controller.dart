import 'package:otrack/views/company/models/company_model.dart';

import '../../../exports/index.dart';

class CompanyController extends GetxController {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  late final GlobalKey<FormState> companyFormKey;

  String? selectedState;

  late TextEditingController companyNameController;
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailAddressController;
  late TextEditingController cityController;
  late TextEditingController zipCodeController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController urlController;

  late RxBool isLoading = false.obs;
  late RxBool isShimmerEffect = true.obs;

  CompanyModel? currentCompany;

  @override
  void onInit() async {
    super.onInit();
    scaffoldKey = GlobalKey<ScaffoldState>();
    companyFormKey = GlobalKey<FormState>();
    companyNameController = TextEditingController();
    emailAddressController = TextEditingController();
    phoneNumberController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    zipCodeController = TextEditingController();
    countryController = TextEditingController();
    urlController = TextEditingController();

    await getCompanyDetails();
  }

  void onStateChange(String? state) {
    selectedState = state;
  }

  Future getCompanyDetails() async {
    final headers = await BaseClient.generateHeaders();
    return await BaseClient.safeApiCall(
      ApiConstants.GET_COMPANY_DETAILS,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        initializeFields(response.data);
        currentCompany = CompanyModel.fromJson(response.data);
        isShimmerEffect(false);
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data ?? e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> onSaveCompanyInfo() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
    "companyId": ${currentCompany?.companyId},
    "name": "${companyNameController.text}",
    "address": "${addressController.text}",
    "PhoneNo" :"${phoneNumberController.text}",
    "city": "${cityController.text}",
    "state": "${selectedState ?? ''}",
    "postalCode": "${zipCodeController.text}",
    "replyToEmail": "${emailAddressController.text}",
    "country": "${countryController.text}",
    "isSetupCompleted": ${currentCompany?.isSetupCompleted},
}''';

    return await BaseClient.safeApiCall(
      ApiConstants.GET_COMPANY_DETAILS,
      RequestType.put,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        Get.snackbar(
          'Success',
          'Company edited successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.response?.data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void initializeFields(data) {
    companyNameController.text = data["name"] ?? '';
    emailAddressController.text = data["replyToEmail"] ?? '';
    stateController.text = data["state"] ?? '';
    selectedState = stateController.text;
    phoneNumberController.text = data["phoneNo"] ?? '';
    addressController.text = data["address"] ?? '';
    countryController.text = data["country"] ?? '';
    cityController.text = data["city"] ?? '';
    zipCodeController.text = data["postalCode"] ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    companyNameController.dispose();
    emailAddressController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    urlController.dispose();
  }
}
