import '../../../exports/index.dart';

class InvoiceCartModel {
  int? customerId;
  late RxBool isTaxable;
  late RxList<CategoryProductModel> items;
  late RxDouble total;
  late RxDouble taxedAmount;
  late RxDouble discountedAmount;

  InvoiceCartModel({this.customerId}) {
    items = <CategoryProductModel>[].obs;
    isTaxable = false.obs;
    total = 0.0.obs;
    taxedAmount = 0.0.obs;
    discountedAmount = 0.0.obs;
  }

  void calculateTotal() {
    total.value = 0.0;
    for (var item in items) {
      total.value += item.quantity * (item.price?.toDouble() ?? 0.0);
    }
  }

  void calculateVendorTotal() {
    total.value = 0.0;
    for (var item in items) {
        total.value += item.quantity * (item.cost?.toDouble() ?? 0.0);
      }
  }

  void calculateDiscount(String discountType, double value) {
    discountedAmount.value = 0.0;
    if (discountType == 'fixed') {
      discountedAmount.value = value;
    } else if (discountType == 'percent') {
      discountedAmount.value = (value / 100) * total.value;
    }
  }

  void calculateVendorTaxedAmount() {
    taxedAmount.value = 0.0;

    if (isTaxable.value) {
      for (var item in items) {
        if (item.isTaxable != null && item.isTaxable == true) {
          taxedAmount.value +=
              item.quantity * (0.0825 * (item.cost?.toDouble() ?? 0.0));
        }
      }
    }
  }

  void calculateTaxedAmount() {
    taxedAmount.value = 0.0;
    if (isTaxable.value) {
      for (var item in items) {
        if (item.isTaxable != null && item.isTaxable == true) {
          taxedAmount.value +=
              item.quantity * (0.0825 * (item.price?.toDouble() ?? 0.0));
        }
      }
    }
  }
}
