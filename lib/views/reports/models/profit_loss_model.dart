class ProfitLossModel {
  double? amount;
  double? costOfGoodsSold;
  double? damagedExpense;
  double? expense;
  List? expenseDetails;
  double? grossProfit;
  double? grossProfitPercent;
  double? netProfit;
  double? netProfitPercent;

  ProfitLossModel({
    this.amount,
    this.costOfGoodsSold,
    this.damagedExpense,
    this.expense,
    this.expenseDetails,
    this.grossProfit,
    this.grossProfitPercent,
    this.netProfit,
    this.netProfitPercent,
  });

  ProfitLossModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] ?? 0.0;
    costOfGoodsSold = json['costOfGoodsSold'] ?? 0.0;
    expense = json['expense'] ?? 0.0;
    damagedExpense = json['damagedExpense'] ?? 0.0;
    expenseDetails = json['expenseDetails'] ?? [];
    grossProfit = amount! - costOfGoodsSold!;
    if (!((grossProfit! * 100) / amount!).isNaN) {
      grossProfitPercent = (grossProfit! * 100) / amount!;
    } else {
      grossProfitPercent = 0;
    }
    netProfit = grossProfit! - damagedExpense! - expense!;
    if (!((netProfit! * 100) / grossProfit!).isNaN) {
      netProfitPercent = (netProfit! * 100) / grossProfit!;
    } else {
      netProfitPercent = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['costOfGoodsSold'] = costOfGoodsSold;
    data['expense'] = expense;
    data['damagedExpense'] = damagedExpense;
    data['expenseDetails'] = expenseDetails;
    data['grossProfit'] = grossProfit;
    data['grossProfitPercent'] = grossProfitPercent;
    data['netProfit'] = netProfit;
    data['netProfitPercent'] = netProfitPercent;

    return data;
  }
}
