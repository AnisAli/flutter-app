// ignore_for_file: constant_identifier_names
import '../exports/index.dart';

class AppRoutes {
  static const String SPLASH = SplashScreen.routeName;
  static const String LOGIN = LoginScreen.routeName;
  static const String FORGOT_PASS = LOGIN + ForgotPassword.routeName;

  static const String HOME = HomePage.routeName;
  static const String PRODUCTS = Products.routeName;
  static const String ADD_PRODUCT = PRODUCTS + AddProduct.routeName;
  static const String ITEM_REPORT = PRODUCTS + ItemReport.routeName;

  static const String CUSTOMERS = Customers.routeName;
  static const String CUSTOMER_DETAIL =
      Customers.routeName + CustomerDetail.routeName;
  static const String ADD_CUSTOMER = CUSTOMERS + AddCustomer.routeName;
  static const String QUICK_INVOICE = CUSTOMER_DETAIL + QuickInvoice.routeName;
  static const String CUSTOMER_OPEN_BALANCE_REPORT =
      CUSTOMER_DETAIL + CustomerOpenBalanceReport.routeName;
  static const String INVOICE_VIEW = CUSTOMER_DETAIL + InvoiceView.routeName;
  static const String PAYMENT_RECEIVED = PaymentReceived.routeName;

  static const String VENDORS = Vendors.routeName;
  static const String ADD_VENDOR = VENDORS + AddVendor.routeName;
  static const String VENDOR_DETAIL = VENDORS + VendorDetail.routeName;
  static const String VENDOR_AGING = VENDORS + VendorAging.routeName;

  static const String CATEGORIES = Categories.routeName;
  static const String ADD_CATEGORY = CATEGORIES + AddCategory.routeName;
  static const String CATEGORY_DETAIL = CATEGORIES + CategoryDetail.routeName;

  static const String PROFIT_LOSS_OVERVIEW = ProfitLossOverview.routeName;
  static const String SALES_BY_ITEM = SalesByItem.routeName;
  static const String SALES_BY_CUSTOMER = SalesByCustomer.routeName;
  static const String SALES_BY_INDIVIDUAL_ITEM = SalesByIndividualItem.routeName;
  static const String OPEN_BALANCE = OpenBalance.routeName;

  static const String COMPANY_PROFILE = CompanyProfile.routeName;

  static const String USERS_LIST = UsersList.routeName;
  static const String ADD_USER_LIST = AddUserList.routeName;

  static const String ROLES_LIST = RolesList.routeName;
  static const String ADD_ROLE = AddRole.routeName;

  String getInitialRoute() {
    if (AuthManager.instance.isLoggedIn) {
      return HOME;
    } else {
      return LOGIN;
    }
  }
}
