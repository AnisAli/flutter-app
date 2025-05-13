import '../../../exports/index.dart';

class AddVendorController extends GetxController {
  late final VendorModel? argsVendor = Get.arguments;

  late final GlobalKey<FormState> vendorFormKey;

  late RxBool isTaxable = false.obs;
  late RxBool isLoading = false.obs;
  late bool isCompanyNameFilled;

  String? selectedState;

  late TextEditingController vendorNameController;
  late TextEditingController companyNameController;
  late TextEditingController emailAddressController;
  late TextEditingController phoneNumberController;
  late TextEditingController streetAddressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipCodeController;

  @override
  void onInit() async {
    vendorFormKey = GlobalKey<FormState>();
    final argsVendor = this.argsVendor;
    if (argsVendor != null) {
      onEditInitialization();
    } else {
      isCompanyNameFilled = false;
      vendorNameController = TextEditingController();
      companyNameController = TextEditingController();
      emailAddressController = TextEditingController();
      phoneNumberController = TextEditingController();
      streetAddressController = TextEditingController();
      cityController = TextEditingController();
      stateController = TextEditingController();
      zipCodeController = TextEditingController();
    }
    super.onInit();
  }

  void onEditInitialization() {
    vendorNameController = TextEditingController(text: argsVendor?.vendorName);
    companyNameController =
        TextEditingController(text: argsVendor?.companyName);
    emailAddressController = TextEditingController(text: argsVendor?.email);
    phoneNumberController = TextEditingController(text: argsVendor?.phoneNo);
    streetAddressController = TextEditingController(text: argsVendor?.address1);
    cityController = TextEditingController(text: argsVendor?.city);
    stateController = TextEditingController(text: argsVendor?.state);
    selectedState = argsVendor?.state;
    zipCodeController = TextEditingController(text: argsVendor?.postalCode);
    isTaxable.value = argsVendor?.isTaxable ?? false;
    if (companyNameController.text.isEmpty) {
      isCompanyNameFilled = false;
    } else {
      isCompanyNameFilled = true;
    }
  }

  Future<void> onSaveVendorForm() async {
    if (vendorFormKey.currentState!.validate()) {
      isLoading(true);
      if (argsVendor == null) {
        await saveVendor();
      } else {
        await editVendor();
      }
      isLoading(false);
    }
  }

  Future<void> editVendor() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
        "vendorId": "${argsVendor?.vendorId}",
      "vendorName": "${vendorNameController.text}",
      "companyName": "${(companyNameController.text.isEmpty) ? vendorNameController.text : companyNameController.text}",
      "email": "${emailAddressController.text}",
      "address1": "${streetAddressController.text}",
      "phoneNo": "${phoneNumberController.text}",
      "city": "${cityController.text}",
      "state": "$selectedState",
      "postalCode": "${zipCodeController.text}",
      "isActive": ${argsVendor?.isActive},
      "isQBVendor": true,
      "isTaxable": ${isTaxable.value},    
   }''';

    return await BaseClient.safeApiCall(
      "${ApiConstants.POST_PUT_ADD_VENDOR}${argsVendor?.vendorId}",
      RequestType.put,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        Get.snackbar(
          'Success',
          'Vendor edited successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.VENDORS);
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

  Future<void> saveVendor() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
      "vendorName": "${vendorNameController.text}",
      "companyName": "${(companyNameController.text.isEmpty) ? vendorNameController.text : companyNameController.text}",
      "firstName": null,
      "lastName": null,
      "email": "${emailAddressController.text}",
      "address1": "${streetAddressController.text}",
      "phoneNo": "${phoneNumberController.text}",
      "faxNo": null,
      "city": "${cityController.text}",
      "state": "$selectedState",
      "postalCode": "${zipCodeController.text}",
      "notes": null,
      "isActive": true,
      "isQBVendor": true,
      "isTaxable": ${isTaxable.value},
   }''';

    return await BaseClient.safeApiCall(
      ApiConstants.POST_PUT_ADD_VENDOR,
      RequestType.post,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        Get.snackbar(
          'Success',
          'Vendor added successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.VENDORS);
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

  void onCustomerNameChange(String value) {
    try {
      if (!isCompanyNameFilled) {
        companyNameController.text = value;
      }
    } catch (e) {
      log.e(e);
    }
  }

  void onCompanyNameChange(String value) {
    if (value.isEmpty) {
      isCompanyNameFilled = false;
    } else {
      isCompanyNameFilled = true;
    }
  }

  void onStateChange(String? state) {
    selectedState = state;
  }

  @override
  void dispose() {
    vendorNameController.dispose();
    companyNameController.dispose();
    emailAddressController.dispose();
    phoneNumberController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }
}
