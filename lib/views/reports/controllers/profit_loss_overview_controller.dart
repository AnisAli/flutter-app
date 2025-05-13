import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../exports/index.dart';
import '../../customers/components/pdf_screen.dart';

class ProfitLossOverviewController extends GetxController {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  //Date
  late TextEditingController dateController;

  //Date Range
  late TextEditingController fromDatePickerController;
  late TextEditingController toDatePickerController;

  ProfitLossModel reportData = ProfitLossModel(
    amount: 0.0,
    costOfGoodsSold: 0.0,
    damagedExpense: 0.0,
    expense: 0.0,
    grossProfit: 0.0,
    grossProfitPercent: 0.0,
    netProfit: 0.0,
    netProfitPercent: 0.0,
    expenseDetails: [],
  );

  String? date;

  onDateChange(String? selected) {
    if (selected == null) return 'Invalid option';
    date = selected;
    dateController.text = selected;
    fromDatePickerController.clear();
    toDatePickerController.clear();
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;
    int index = AppStrings.DATES.indexOf(selected);
    switch (index) {
      case 0: // 'Today'
        startDate = now;
        endDate = now;
        break;
      case 1: // 'Yesterday'
        startDate = now.subtract(const Duration(days: 1));
        endDate = startDate;
        break;
      case 2: // 'This Week'
        startDate = DateTime(now.year, now.month, now.day - now.weekday + 1);
        endDate = DateTime(now.year, now.month, now.day + (7 - now.weekday));
        break;
      case 3: // 'This Month'
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 4: // 'This Quarter'
        startDate = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
        endDate = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 4, 1)
            .subtract(const Duration(days: 1));
        break;
      case 5: // 'This Year'
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      case 6: // 'Last Three Days'
        startDate = now.subtract(const Duration(days: 3));
        endDate = now;
        break;
      case 7: // 'Last Week'
        startDate = now.subtract(Duration(days: now.weekday + 6));
        endDate = now.subtract(Duration(days: now.weekday));
        break;
      case 8: // 'Last Month'
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0);
        break;
      case 9: // 'Last Year'
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31);
        break;
      case 10: // 'Last 100 Days'
        startDate = now.subtract(const Duration(days: 100));
        endDate = now;
        break;
      case 11: // 'Last 365 Days'
        startDate = now.subtract(const Duration(days: 365));
        endDate = now;
        break;
      default:
        return 'Invalid option';
    }

    fromDatePickerController.text = DateFormat('yyyy-MM-dd').format(startDate);
    toDatePickerController.text = DateFormat('yyyy-MM-dd').format(endDate);

    getProfitLossReport();
  }

  Future<void> getProfitLossReport() async {
    reportData.netProfitPercent = 0.0;
    reportData.netProfit = 0.0;
    reportData.grossProfit = 0.0;
    reportData.grossProfitPercent = 0.0;
    reportData.costOfGoodsSold = 0.0;
    reportData.amount = 0.0;
    reportData.expense = 0.0;
    reportData.damagedExpense = 0.0;
    reportData.expenseDetails = [];

    try {
      reportData = await BaseClient.safeApiCall(
        ApiConstants.PROFIT_LOSS,
        RequestType.post,
        headers: await BaseClient.generateHeaders(),
        data: {
          'fromDate': fromDatePickerController.text,
          'toDate': toDatePickerController.text,
        },
        onSuccess: (json) {
          ProfitLossModel data = ProfitLossModel();
          if (json.data != null) {
            data = ProfitLossModel.fromJson(json.data['data']);
          }
          return data;
        },
      );
      update(['reportData']);
    }
    catch(e){
      Get.snackbar(
        'Error',
        'Something went wrong, Please try again later',
        margin: const EdgeInsets.only(bottom: 25),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

  }

  @override
  void onInit() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    dateController = TextEditingController();
    date = AppStrings.DATES[3];
    fromDatePickerController = TextEditingController();
    toDatePickerController = TextEditingController();
    DateTime now = DateTime.now();
    fromDatePickerController.text =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    toDatePickerController.text =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));

    getProfitLossReport();
    super.onInit();
  }

  @override
  void dispose() {
    toDatePickerController.dispose();
    fromDatePickerController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
