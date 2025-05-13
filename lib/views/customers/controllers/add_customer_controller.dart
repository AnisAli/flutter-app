import '../../../exports/index.dart';

class AddCustomerController extends GetxController {
  late final CustomerModel? argsCustomer = Get.arguments;

  late final GlobalKey<FormState> customerFormKey;
  late TextEditingController customerNameController;
  late TextEditingController companyNameController;
  late TextEditingController emailAddressController;
  late TextEditingController phoneNumberController;
  late TextEditingController streetAddressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipCodeController;
  late TextEditingController saleTaxIdController;

  String? selectedState;

  late RxBool isTaxable = false.obs;
  late RxBool isLoading = false.obs;
  late bool isCompanyNameFilled;

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

  Future<void> editCustomer() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
        "customerId": "${argsCustomer?.customerId}",
      "customerName": "${customerNameController.text}",
      "companyName": "${(companyNameController.text.isEmpty) ? customerNameController.text : companyNameController.text}",
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
      "isQBCustomer": true,
      "isTaxable": ${isTaxable.value},
      "priceTierId": null,
      "salesTaxId": "${saleTaxIdController.text}",
      "tobaccoPermitId": null,
      "deliveryCertificateNumber": null,
      "tabcId": null,
      "salesTaxIdExpiryDate": null,
      "tobaccoPermitIdExpiryDate": null,
      "deliveryCertificateNumberExpiryDate": null,
      "tabcIdExpiryDate": null
   }''';

    return await BaseClient.safeApiCall(
      ApiConstants.POST_EDIT_CUSTOMER,
      RequestType.post,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        Get.snackbar(
          'Success',
          'Customer edited successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.CUSTOMERS);
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

  Future<void> onSaveCustomerForm() async {
    if (customerFormKey.currentState!.validate()) {
      isLoading(true);
      if (argsCustomer == null) {
        await saveCustomer();
      } else {
        await editCustomer();
      }
      isLoading(false);
    }
  }

  Future<void> saveCustomer() async {
    final headers = await BaseClient.generateHeaders();
    final body = '''{
      "customerName": "${customerNameController.text}",
      "companyName": "${(companyNameController.text.isEmpty) ? customerNameController.text : companyNameController.text}",
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
      "isQBCustomer": true,
      "isTaxable": ${isTaxable.value},
      "priceTierId": null,
      "salesTaxId": "${saleTaxIdController.text}",
      "tobaccoPermitId": null,
      "deliveryCertificateNumber": null,
      "tabcId": null,
      "salesTaxIdExpiryDate": null,
      "tobaccoPermitIdExpiryDate": null,
      "deliveryCertificateNumberExpiryDate": null,
      "tabcIdExpiryDate": null
   }''';

    return await BaseClient.safeApiCall(
      ApiConstants.POST_ADD_CUSTOMER,
      RequestType.post,
      headers: headers,
      data: body,
      onLoading: () {},
      onSuccess: (response) async {
        // Handle success response
        Get.snackbar(
          'Success',
          'Customer added successfully!',
          margin: const EdgeInsets.only(bottom: 25),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.CUSTOMERS);
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

  void onStateChange(String? state) {
    selectedState = state;
  }

  @override
  void onInit() async {
    customerFormKey = GlobalKey<FormState>();
    final argsCustomer = this.argsCustomer;
    if (argsCustomer != null) {
      onEditInitialization();
    } else {
      isCompanyNameFilled = false;
      customerNameController = TextEditingController();
      companyNameController = TextEditingController();
      emailAddressController = TextEditingController();
      phoneNumberController = TextEditingController();
      streetAddressController = TextEditingController();
      cityController = TextEditingController();
      stateController = TextEditingController();
      zipCodeController = TextEditingController();
      saleTaxIdController = TextEditingController();
    }
    super.onInit();
  }

  void onEditInitialization() {
    customerNameController =
        TextEditingController(text: argsCustomer?.customerName);
    companyNameController =
        TextEditingController(text: argsCustomer?.companyName);
    emailAddressController = TextEditingController(text: argsCustomer?.email);
    phoneNumberController = TextEditingController(text: argsCustomer?.phoneNo);
    streetAddressController =
        TextEditingController(text: argsCustomer?.address1);
    cityController = TextEditingController(text: argsCustomer?.city);
    stateController = TextEditingController(text: argsCustomer?.state);
    selectedState = argsCustomer?.state;
    zipCodeController = TextEditingController(text: argsCustomer?.postalCode);
    saleTaxIdController = TextEditingController(text: argsCustomer?.salesTaxId);
    isTaxable.value = argsCustomer?.isTaxable ?? false;
    if (companyNameController.text.isEmpty) {
      isCompanyNameFilled = false;
    } else {
      isCompanyNameFilled = true;
    }
  }

  @override
  void dispose() {
    customerNameController.dispose();
    companyNameController.dispose();
    emailAddressController.dispose();
    phoneNumberController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    saleTaxIdController.dispose();
    super.dispose();
  }
}
