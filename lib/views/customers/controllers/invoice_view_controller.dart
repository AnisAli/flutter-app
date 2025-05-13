import 'package:dio/dio.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart' as utils_pos;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:otrack/views/customers/components/bluetooth_printer_sheet_card.dart';
import 'package:otrack/views/customers/components/pdf_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zefyrka/zefyrka.dart';
import 'dart:io';
import '../../../exports/index.dart';

class InvoiceViewController extends GetxController {
  late Rx<UserData?> _userData;
  late InvoiceCartModel invoiceCart;
  TransactionSummaryModel transactionSummaryModel =
      Get.arguments['transactionSummaryModel'];
  late RxString invoiceByName = ''.obs;
  late RxString transactionDate = '2023-03-09'.obs;
  late RxString transactionNumber = ''.obs;
  late RxDouble invoiceRetail = 0.0.obs;
  late RxDouble invoiceNetTotal = 0.0.obs;
  late RxDouble openBalance = 0.0.obs;
  late RxString memo = ''.obs;

  late RxBool isShowBarcode = true.obs;
  late RxInt salesOrderId = 0.obs;
  late RxBool isLoading = false.obs;

  late bool isVendorThere = false;

  //for payment view only//
  ///Todo: to do for list of payments (invoices) ///
  late RxDouble totalPaymentInvoiceAmount = 0.00.obs;
  late RxString paymentInvoiceId = ''.obs;
  late RxString paymentMethod = ''.obs;
  //--------------//

  late Rx<CustomerModel> argsCustomer = CustomerModel().obs;

  //Send Email Invoice //
  late Rx<TextEditingController> fromEmailController =
      TextEditingController().obs;
  late TextEditingController toEmailController;
  late TextEditingController ccEmailController;
  late TextEditingController bccEmailController;
  late ZefyrController notesController;

  late String printerUuid = '';

  //for bluetooth connectivity //
  FlutterBluePlus bluetoothPrint = FlutterBluePlus();
  late RxBool isBluetoothConnected = false.obs;
  BluetoothDevice? bluetoothDevice;
  late RxBool isPrinterLoading = true.obs;
  RxString tips = 'No Connection'.obs;

  //for POS/ESC Utils ///
  late Generator generator;

  //for pdf viewer//

  @override
  void onInit() async {
    super.onInit();
    invoiceCart = InvoiceCartModel();
    _userData = UserData().obs;
    var data;
    if (Get.arguments['vendor'] == true) {
      isVendorThere = true;
      data = await getVendorOrder(
          transactionSummaryModel.transaction ?? 'Purchase Order',
          "${transactionSummaryModel.id}");
    } else {
      data = await getOrder(
          transactionSummaryModel.transaction ?? 'Sales Order',
          "${transactionSummaryModel.id}");
    }
    if (data != null) {
      if (transactionSummaryModel.transactionType == 3) {
        paymentDataInitialization(data);
      } else if (transactionSummaryModel.transactionType == 8) {
        paymentBillInitialization(data);
      } else {
        invoiceDataInitialization(data);
      }

      memo.value = data['memo'] ?? '';
      customerInitialization(data);
    }
    //Send Email Initialization//
    invoiceCart.customerId = argsCustomer.value.customerId;
    toEmailController = TextEditingController(text: argsCustomer.value.email);
    ccEmailController = TextEditingController();
    bccEmailController = TextEditingController();
    notesController = ZefyrController(NotusDocument());
    await getUserDetails();
    notesController.replaceText(0, 0,
        " Hi ${argsCustomer.value.customerName ?? ''},\nPlease find the attached receipt for your ${transactionSummaryModel.transaction}. \n\nThank you");
    //bluetooth printer related //
    isPrinterLoading.value = true;
    final profile = await CapabilityProfile.load();
    generator = Generator(PaperSize.mm80, profile);
    await initBluetooth();
    isPrinterLoading.value = false;
  }

  void onPressDownloadPDF() async {
    isLoading.value = true;
    String path = await getDownloadPdf();
    if (path.isNotEmpty) {
      Get.to(() => PDFScreen(
            path: path,
          ));
    }
    isLoading.value = false;
  }

  Future getDownloadPdf() async {
    final headers = await BaseClient.generateHeaders();
    Dio dioWithHeaders = Dio(BaseOptions(
        receiveTimeout: 999999, sendTimeout: 999999, headers: headers));
    String apiString = '';

    if (transactionSummaryModel.transactionType == 6) {
      apiString =
          "${ApiConstants.POST_NEW_PURCHASE_ORDER}/${transactionSummaryModel.id}/export?format=1&ShowBarcode=${isShowBarcode.value}";
    } else if (transactionSummaryModel.transactionType == 5) {
      apiString =
          "${ApiConstants.GET_BILL}${transactionSummaryModel.id}/export?format=1&ShowBarcode=${isShowBarcode.value}";
    } else if (transactionSummaryModel.transactionType == 7) {
      apiString =
          "${ApiConstants.POST_NEW_PURCHASE_CREDIT_MEMO}/${transactionSummaryModel.id}/export?format=1&ShowBarcode=${isShowBarcode.value}";
    } else if (transactionSummaryModel.transactionType == 4) {
      apiString =
          "${ApiConstants.GET_EDIT_SALES_ORDER}${transactionSummaryModel.id}/export?format=1&ShowBarcode=${isShowBarcode.value}";
    } else if (transactionSummaryModel.transactionType == 1 ||
        transactionSummaryModel.transactionType == 2) {
      apiString =
          "${ApiConstants.GET_EDIT_INVOICE}${transactionSummaryModel.id}/export?format=1&ShowBarcode=${isShowBarcode.value}";
    }

    var dir = await getApplicationDocumentsDirectory();

    String path = "${dir.path}/Invoice.pdf";
    await dioWithHeaders.download(
      apiString,
      (Headers headers) {
        headers.map.values;
        return path;
      },
    );

    return path;
  }

  void moveBackToInitialPage() async {
    if (Get.arguments['vendor'] != null) {
      if (Get.routing.isBottomSheet ?? false) {
        final vendorDetailController = Get.find<VendorDetailController>();
        vendorDetailController.isLoading(true);
        await vendorDetailController.getOpenBills();
        await vendorDetailController.getVendorDetail();
        vendorDetailController.transactionsPaginationKey.refresh();
        vendorDetailController.isLoading(false);
      }
      Get.until((route) => Get.currentRoute == AppRoutes.VENDOR_DETAIL);
    } else {
      // if comes after creating invoice //
      if (Get.routing.isBottomSheet ?? false) {
        final customerDetailController = Get.find<CustomerDetailController>();
        customerDetailController.isLoading(true);
        if ((Get.routing.route?.settings.arguments as Map).length >= 2) {
          await customerDetailController.getCustomerDetail();
          await customerDetailController.getOpenInvoices();
        }
        customerDetailController.transactionsPaginationKey.refresh();
        customerDetailController.isLoading(false);
      }
      //else if comes directly to view screen.//
      //no need to call any api//
      Get.until((route) => Get.currentRoute == AppRoutes.CUSTOMER_DETAIL);
    }
  }

  void customerInitialization(data) {
    if (Get.arguments['customer'] != null) {
      argsCustomer.value = Get.arguments['customer'];
    } else {
      argsCustomer.value = CustomerModel(
        customerId: data['customerId'] is String
            ? int.parse(data['customerId'])
            : data['customerId'],
        customerName: data['customerName'],
        companyName: data['companyName'],
        isQBCustomer: data['isQBCustomer'],
        email: data['customerEmail'],
        phoneNo: data['customerPhoneNo'],
        openBalance: data['customerOpenBalance'],
        address1: data['customerAddress'],
        city: data['customerCity'],
        state: data['customerState'],
        postalCode: data['customerPostalCode'],
      );
    }
  }

  String formatString(String firstString, String secondString,
      {int maxLength = 48}) {
    final firstPart = firstString.padRight(maxLength - secondString.length);
    final lastPart = secondString.padLeft(maxLength - firstPart.length);
    return firstPart + lastPart;
  }

  String formatStringSplit(String firstString, String secondString,
      {int maxLength = 48}) {
    if (firstString.length > 25) {
      final firstPart = '${firstString.substring(0, 25)}\n';
      final remainingPart = firstString.substring(25);
      final firstPartFormatted =
          remainingPart.padRight(maxLength - secondString.length);
      final lastPart =
          secondString.padLeft(maxLength - firstPartFormatted.length);
      return firstPart + firstPartFormatted + lastPart;
    } else {
      final firstPart = firstString.padRight(maxLength - secondString.length);
      final lastPart = secondString.padLeft(maxLength - firstPart.length);
      return firstPart + lastPart;
    }
  }

  void printReceiptContent() async {
    //info each line has 48 characters //
    List<int> bytes = [];
    bytes += printCompanyInfo();
    bytes += printInvoiceInfo();
    bytes += printBillToInfo();

    if (transactionSummaryModel.transactionType != 3 &&
        transactionSummaryModel.transactionType != 8) {
      bytes += printProductDataTable();
      bytes += printTotalInfo();
    } else {
      bytes += printPaymentDataTable();
    }

    bytes += printFooter();

    if (Platform.isAndroid) {
      await bluetoothDevice?.requestMtu(185);
    }

    // Printing Request for a specific service //
    List<BluetoothService>? services =
        await bluetoothDevice?.discoverServices();

    for (BluetoothService service in services ?? []) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write && c.properties.writeWithoutResponse) {
          c.writeLarge(bytes, 185);
          return;
        }
      }
    }
    // If no printing services found! //
    Get.snackbar(
      'Print service not found!',
      'Try connecting with printer again!',
      margin: const EdgeInsets.only(bottom: 25),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  List<int> printFooter() {
    List<int> bytes = [];

    if (transactionSummaryModel.transactionType == 1 ||
        transactionSummaryModel.transactionType == 2) {
      bytes += generator.emptyLines(2);
      bytes += generator.text(
          'Customer Total Open Balance: \$${openBalance.value}',
          styles: const PosStyles(align: PosAlign.center));
    }

    if (memo.isNotEmpty) {
      bytes += generator.emptyLines(2);
      bytes += generator.text('Notes: ${memo.value}');
    }

    if (_userData.value?.company?.disclaimer?.isNotEmpty ?? false) {
      bytes += generator.emptyLines(3);
      bytes +=
          generator.text('Disclaimer: ${_userData.value?.company?.disclaimer}');
    }

    bytes += generator.emptyLines(4);

    bytes += generator.text('powered by otrack.io',
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.cut();

    return bytes;
  }

  List<int> printCompanyInfo() {
    List<int> bytes = [];
    bytes += generator.emptyLines(1);
    bytes += generator.text(user.value?.company?.name ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(user.value?.company?.address ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(user.value?.email ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
      user.value?.company?.phoneNo ?? '',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.emptyLines(1);

    return bytes;
  }

  List<int> printInvoiceInfo() {
    List<int> bytes = [];
    String title = '';
    if (transactionSummaryModel.transactionType == 1) {
      title = 'INVOICE#';
    } else if (transactionSummaryModel.transactionType == 2) {
      title = 'Credit Memo#';
    } else if (transactionSummaryModel.transactionType == 3) {
      title = 'PAY#';
    } else if (transactionSummaryModel.transactionType == 4) {
      title = 'SO#';
    } else if (transactionSummaryModel.transactionType == 5) {
      title = 'BILL#';
    } else if (transactionSummaryModel.transactionType == 6) {
      title = 'Purchase Order#';
    } else if (transactionSummaryModel.transactionType == 7) {
      title = 'BILL Credit Memo#';
    } else if (transactionSummaryModel.transactionType == 8) {
      title = 'BILL PAY#';
    }

    bytes += generator.text("$title ${transactionNumber ?? ''}",
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text(
        'Date: ${formatDate(transactionSummaryModel.date ?? '2023-03-09')}',
        styles: const PosStyles(align: PosAlign.center));
    if (transactionSummaryModel.transactionType == 1) {
      if (salesOrderId.value != 0) {
        bytes += generator.text('SO # ${salesOrderId.value}',
            styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
      }
    }
    bytes += generator.emptyLines(1);
    return bytes;
  }

  List<int> printBillToInfo() {
    var argCustomer = argsCustomer.value;
    List<int> bytes = [];
    String byString = AppStrings.INVOICE_BY;
    String totalString = AppStrings.INVOICE_TOTAL;
    String retailString = AppStrings.INVOICE_RETAIL;

    String invoiceTotalValue =
        '${(invoiceNetTotal.value != 0.0 && (transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${invoiceNetTotal.value}';
    String retailValue =
        '${(invoiceRetail.value != 0.0 && (transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${invoiceRetail.value.toStringAsFixed(2)}';

    if (transactionSummaryModel.transactionType == 1) {
      byString = AppStrings.INVOICE_BY;
      totalString = AppStrings.INVOICE_TOTAL;
      retailString = AppStrings.INVOICE_RETAIL;
    } else if (transactionSummaryModel.transactionType == 4) {
      byString = AppStrings.ORDER_BY;
      totalString = AppStrings.ORDER_TOTAL;
      retailString = AppStrings.ORDER_RETAIL;
    } else if (transactionSummaryModel.transactionType == 2) {
      byString = AppStrings.CREDIT_MEMO_BY;
      totalString = AppStrings.CREDIT_MEMO_TOTAL;
      retailString = AppStrings.CREDIT_MEMO_RETAIL;
    } else if (transactionSummaryModel.transactionType == 3) {
      byString = AppStrings.PAYMENT_BY;
      totalString = AppStrings.PAYMENT_AMOUNT;
      retailString = AppStrings.PAYMENT_METHOD;
      retailValue = '$paymentMethod';
    }

    bytes += generator.text(formatString(AppStrings.BILL_TO, byString),
        styles: const PosStyles(bold: true));
    bytes += generator.text(
        formatString(argCustomer.customerName ?? '', invoiceByName.value));
    bytes += generator
        .text(formatStringSplit(argCustomer.address1 ?? '', totalString));
    bytes += generator.text(formatString(
        '${argCustomer.city ?? ''} ${argCustomer.state ?? ''} ${argCustomer.postalCode ?? ''} ',
        invoiceTotalValue));

    if (transactionSummaryModel.transactionType == 3) {
      bytes +=
          generator.text(formatString(argCustomer.email ?? '', retailString));
      bytes +=
          generator.text(formatString(argCustomer.phoneNo ?? '', retailValue));
    } else if (invoiceRetail.value > 0) {
      bytes +=
          generator.text(formatString(argCustomer.email ?? '', retailString));
      bytes +=
          generator.text(formatString(argCustomer.phoneNo ?? '', retailValue));
    } else {
      bytes += generator.text(argCustomer.phoneNo ?? '');
    }

    bytes += generator.emptyLines(1);
    return bytes;
  }

  List<int> printProductDataTable() {
    List<int> bytes = [];

    if (invoiceRetail.value > 0) {
      bytes += generator.row([
        PosColumn(
          text: 'DESCRIPTION\nQty',
          width: 4,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'SRP',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'RETAIL',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'PRICE',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'TOTAL',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]);
    } else {
      bytes += generator.row([
        PosColumn(
          text: 'DESCRIPTION\nQty',
          width: 5,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'RETAIL',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'PRICE',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'TOTAL',
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]);
    }

    bytes += generator.text('-----------------------------------------------',
        styles: const PosStyles(bold: true));

    String totalValue = '';
    for (var i = 0; i < invoiceCart.items.length; i++) {
      totalValue =
          '${(invoiceNetTotal.value != 0.0 && (transactionSummaryModel.transactionType == 2)) ? '-' : ''}${(invoiceCart.items[i].price! * invoiceCart.items[i].quantity).toStringAsFixed(2)}';

      bytes += generator.text(invoiceCart.items[i].productName ?? '');

      if (invoiceRetail.value > 0) {
        bytes += generator.row([
          PosColumn(
            text: 'Qty ${invoiceCart.items[i].quantity}',
            width: 4,
          ),
          PosColumn(
            text:
                '${invoiceCart.items[i].suggestedRetailPrice?.toStringAsFixed(2)}',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: ((invoiceCart.items[i].suggestedRetailPrice! *
                    invoiceCart.items[i].quantity)
                .toStringAsFixed(2)),
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: '${invoiceCart.items[i].price}',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: totalValue,
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
        ]);
      } else {
        bytes += generator.row([
          PosColumn(
            text: 'Qty ${invoiceCart.items[i].quantity}',
            width: 5,
          ),
          PosColumn(
            text: ((invoiceCart.items[i].suggestedRetailPrice! *
                    invoiceCart.items[i].quantity)
                .toStringAsFixed(2)),
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: '${invoiceCart.items[i].price}',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: totalValue,
            width: 3,
            styles: const PosStyles(align: PosAlign.center),
          ),
        ]);
      }

      if (isShowBarcode.value && (invoiceCart.items[i].barCode != null)) {
        if (invoiceCart.items[i].barCode?.isNotEmpty ?? false) {
          final List<dynamic> barcdA =
              "{B${invoiceCart.items[i].barCode ?? ''}".split("");
          try {
            bytes += generator.barcode(utils_pos.Barcode.code128(barcdA),
                height: 35,
                textPos: BarcodeText.none,
                align: PosAlign.left,
                font: BarcodeFont.specialA);
          } on Exception catch (e) {
            Get.snackbar(
              "${invoiceCart.items[i].productName ?? ''} barcode is invalid!",
              margin: const EdgeInsets.only(bottom: 25),
              e.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blueAccent,
              colorText: Colors.white,
            );
          }
        }
      }
      bytes += generator.text('-----------------------------------------------',
          styles: const PosStyles(
            bold: true,
          ));
    }
    bytes += generator.emptyLines(1);
    return bytes;
  }

  List<int> printPaymentDataTable() {
    List<int> bytes = [];

    bytes += generator.text('INVOICE   INVOICE     APPLIED       APPLIED DATE',
        styles: const PosStyles(bold: true));
    bytes += generator.text('           TOTAL       AMOUNT            ',
        styles: const PosStyles(bold: true));

    bytes += generator.text('-----------------------------------------------',
        styles: const PosStyles(bold: true));

    bytes += generator.row([
      PosColumn(
        text: paymentInvoiceId.value,
        width: 2,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "${totalPaymentInvoiceAmount.value}",
        width: 3,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: " ${invoiceNetTotal.value}",
        width: 3,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: formatDate(transactionSummaryModel.date ?? '09-07-2023'),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.text('-----------------------------------------------',
        styles: const PosStyles(bold: true));
    return bytes;
  }

  List<int> printTotalInfo() {
    List<int> bytes = [];
    String totalValue =
        '${(invoiceCart.total.value != 0.0 && (transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${invoiceCart.total.value.toStringAsFixed(2)}';
    String discountValue =
        '${(invoiceCart.discountedAmount.value != 0.0 && (transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${invoiceCart.discountedAmount.value.toStringAsFixed(2)}';
    String saleTaxValue =
        '${(invoiceCart.taxedAmount.value != 0.0 && (transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${invoiceCart.taxedAmount.value.toStringAsFixed(2)}';
    String netTotalValue =
        '${(invoiceNetTotal.value != 0.0 && (transactionSummaryModel.transactionType == 2)) ? '-' : ''}\$${invoiceNetTotal.value}';

    bytes += generator.row([
      PosColumn(text: 'Total:', width: 6),
      PosColumn(
        text: totalValue,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      )
    ]);
    bytes += generator.row([
      PosColumn(text: 'Discount:', width: 6),
      PosColumn(
        text: discountValue,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      )
    ]);

    bytes += generator.row([
      PosColumn(text: 'Sales Tax:', width: 6),
      PosColumn(
        text: saleTaxValue,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      )
    ]);
    bytes += generator.row([
      PosColumn(text: 'Net Total:', width: 6),
      PosColumn(
        text: netTotalValue,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      )
    ]);

    return bytes;
  }

  Future<void> initBluetooth() async {
    FlutterBluePlus.systemDevices.then((devices) => {
          devices.isNotEmpty
              ? {
                  bluetoothDevice = devices.first,
                  isBluetoothConnected.value = true,
                  tips.value =
                      'Connected Device: ${bluetoothDevice?.platformName}'
                }
              : {}
        });
  }

  Future<void> sendEmailInvoice() async {
    //for transactionType == 1
    String url = '${ApiConstants.SEND_EMAIL}invoice';
    if (transactionSummaryModel.transactionType == 4) {
      url = '${ApiConstants.SEND_EMAIL}SalesOrder';
    } else if (transactionSummaryModel.transactionType == 2) {
      url = '${ApiConstants.SEND_EMAIL}CreditMemo';
    } else if (transactionSummaryModel.transactionType == 5) {
      url = '${ApiConstants.SEND_EMAIL}bill';
    } else if (transactionSummaryModel.transactionType == 6) {
      url = '${ApiConstants.SEND_EMAIL}PurchaseOrder';
    } else if (transactionSummaryModel.transactionType == 7) {
      url = '${ApiConstants.SEND_EMAIL}none';
    }
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      headers: await BaseClient.generateHeaders(),
      data: {
        "bccEmail": bccEmailController.text,
        "ccEmail": ccEmailController.text,
        "id": transactionSummaryModel.id,
        "message": notesController.plainTextEditingValue.text,
        "toEmail": [toEmailController.text]
      },
      onSuccess: (response) {
        Get.back();
        Get.snackbar(
          'Success',
          'Email Sent!',
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
            e.response?.data['message'] ?? e.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5));
      },
    );
  }

  void paymentBillInitialization(var data) {
    transactionDate.value = data['paymentDate'];
    transactionNumber.value = data['paymentNumber'];
    paymentMethod.value = data['paymentMethod'];
    totalPaymentInvoiceAmount.value = data['creditAmount'];
    paymentInvoiceId.value = data['paymentId'].toString();
    invoiceByName.value = data['paymentBy'];
    invoiceNetTotal.value = data['totalAmount'];
  }

  void paymentDataInitialization(var data) {
    transactionDate.value = data['paymentDate'];
    transactionNumber.value = data['paymentNumber'];
    paymentMethod.value = data['paymentMethod'];
    totalPaymentInvoiceAmount.value = data['paidInvoices'][0]['totalAmount'];
    paymentInvoiceId.value = data['paidInvoices'][0]['invoiceNumber'];
    invoiceByName.value = data['paymentBy'];
    invoiceNetTotal.value = data['totalAmount'];
  }

  void invoiceDataInitialization(var data) {
    if (transactionSummaryModel.transactionType != 4) {
      transactionDate.value = data['invoiceDate'];
      transactionNumber.value = data['invoiceNumber'];
    } else if (transactionSummaryModel.transactionType == 4) {
      transactionDate.value = data['orderDate'];
      transactionNumber.value = data['salesOrderId'].toString();
    }
    //storing taxable and customerId
    invoiceCart.isTaxable.value =
        data['isTaxable'] ?? (data['totalTax'] != 0) ? true : false;
    invoiceCart.customerId = data['customerId'];

    //storing tax //
    invoiceCart.taxedAmount.value = data['totalTax'];
    //storing sales order id//
    salesOrderId.value = data['salesOrderId'];
    //storing invoice by name//
    if (transactionSummaryModel.transactionType == 4) {
      invoiceByName.value = data['orderBy'];
    } else {
      invoiceByName.value = data['invoiceBy'];
      //storing open balance //
      openBalance.value = data['openBalance'];
    }

    // double discountVal = data['discountValue'] ?? 0.0;
    // String discountType = data['discountType'];

    //adding items to cart //
    for (var i = 0; i < data['items'].length; i++) {
      CategoryProductModel prod =
          CategoryProductModel.fromEditOrderJson(data['items'][i]);
      invoiceCart.items.add(prod);
    }
    if (invoiceCart.items.isNotEmpty) {
      isVendorThere
          ? invoiceCart.calculateVendorTotal()
          : invoiceCart.calculateTotal();

      //storing discount//
      invoiceCart.calculateDiscount(
          data['discountType'] ?? 'fixed', data['discountValue'] ?? 0.0);

      invoiceNetTotal.value = (invoiceCart.total.value -
              invoiceCart.discountedAmount.value +
              invoiceCart.taxedAmount.value)
          .toPrecision(2);
      calculateInvoiceRetail();
    }
  }

  void calculateInvoiceRetail() {
    double totalRetail = 0.0;
    for (var i = 0; i < invoiceCart.items.length; i++) {
      totalRetail += (invoiceCart.items[i].quantity *
          invoiceCart.items[i].suggestedRetailPrice!);
    }
    invoiceRetail.value = totalRetail;
  }

  void onPressHideBarCode() => isShowBarcode.value = !isShowBarcode.value;

  String formatDate(String dateString) {
    // Parse the input string to a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Create a DateFormat object with the desired output format
    DateFormat formatter = DateFormat('MMMM dd, yyyy');

    // Format the DateTime object using the formatter
    String formattedDate = formatter.format(date);

    return formattedDate;
  }

  Rx<UserData?> get user => _userData;

  Future<void> getUserDetails() async {
    await BaseClient.safeApiCall(
      ApiConstants.GET_USER_DATA,
      RequestType.get,
      headers: await BaseClient.generateHeaders(),
      onSuccess: (response) {
        _userData.value = UserData.fromJson(response.data);
        fromEmailController.value.text = user.value?.email ?? '';
      },
      onError: (e) {},
    );
  }

  // Get already generated ORDERS, INVOICES details (edit,view)//
  Future getOrder(String type, String transactionId) async {
    final headers = await BaseClient.generateHeaders();
    String apiString = '';
    if (type == 'Sales Order') {
      apiString = ApiConstants.GET_EDIT_SALES_ORDER + transactionId;
    } else if (type == 'Payment') {
      apiString = ApiConstants.GET_PAYMENT_INVOICE + transactionId;
    } else {
      apiString = ApiConstants.GET_EDIT_INVOICE + transactionId;
    }
    return await BaseClient.safeApiCall(
      apiString,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        return response.data;
      },
      onError: (e) {
        Get.snackbar(
          'Something went wrong!',
          margin: const EdgeInsets.only(bottom: 25),
          e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  // Get already generated ORDERS, INVOICES details (edit,view)//
  Future getVendorOrder(String type, String transactionId) async {
    final headers = await BaseClient.generateHeaders();
    String apiString = '';
    if (type == 'Purchase Bill' ||
        type == 'Bill Credit Memo' ||
        type == 'Purchase Credit Memo') {
      apiString = ApiConstants.GET_BILL + transactionId;
    } else if (type == 'Purchase Order') {
      apiString = '${ApiConstants.GET_BILL}purchaseorder/$transactionId';
    } else {
      apiString = ApiConstants.GET_PAYMENT_BILL + transactionId;
    }
    return await BaseClient.safeApiCall(
      apiString,
      RequestType.get,
      headers: headers,
      data: {},
      onSuccess: (response) async {
        return response.data;
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

  @override
  void dispose() async {
    fromEmailController.value.dispose();
    toEmailController.dispose();
    ccEmailController.dispose();
    bccEmailController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
