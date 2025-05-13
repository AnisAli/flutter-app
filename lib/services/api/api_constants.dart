// ignore_for_file: constant_identifier_names

class ApiConstants {
  static const int ITEM_COUNT = 12;

  //for prod env //
  static const String BASE_URL = 'https://api.otrack.io/v1/';

  //for dev env///
  //static const String BASE_URL =  'https://api.pinonclick.com/v1/';

  static const String GET_USER_DATA = '${BASE_URL}user';
  static const String GET_USER_PERMISSIONS = '${BASE_URL}users/permissions';
  static const String GET_ROLES = '${BASE_URL}roles';
  static const String GET_ROLE_PERMISSIONS = '${BASE_URL}permissions';

  static const String GET_COMPANY_DETAILS = '${BASE_URL}company';

  static const String GET_PRODUCT_LIST = '${BASE_URL}odata/Products/List';
  static const String GET_CUSTOMER_BASED_PRODUCT_LIST =
      '${BASE_URL}odata/Products/ForCustomer';
  static const String GET_PRODUCT_CATEGORIES = '${BASE_URL}categories/';
  static const String POST_ADD_PRODUCT = '${BASE_URL}Products';
  static const String GET_PRODUCT = '${BASE_URL}Products/';
  static const String POST_PRODUCT_TOGGLE = '${BASE_URL}products';
  static const String POST_ITEM_SALE_REPORT =
      '${BASE_URL}reports/orderitemdetail/';
  static const String POST_ITEM_PURCHASE_REPORT =
      '${BASE_URL}reports/purchases/products/';

  static const String GET_CUSTOMER_LIST =
      '${BASE_URL}odata/Customers/CustomerList';
  static const String GET_SINGLE_CUSTOMER = '${BASE_URL}customers/';
  static const String POST_ADD_CUSTOMER = '${BASE_URL}customers/add';
  static const String POST_EDIT_CUSTOMER = '${BASE_URL}customers/edit';

  static const String GET_VENDOR_LIST = '${BASE_URL}odata/vendors/VendorList';
  static const String POST_PUT_ADD_VENDOR = '${BASE_URL}vendors/';
  static const String POST_NEW_PURCHASE_ORDER =
      '${BASE_URL}bills/purchaseorder';
  static const String POST_NEW_PURCHASE_CREDIT_MEMO =
      '${BASE_URL}bills/creditmemo';
  static const String POST_NEW_BILL = '${BASE_URL}bills';
  static const String GET_BILL = '${BASE_URL}bills/';
  static const String POST_APPLY_BILL = '${BASE_URL}billpayments';
  static const String GET_PAYMENT_BILL = '${BASE_URL}billpayments/';
  static const String POST_VENDOR_AGING =
      '${BASE_URL}reports/vendoragingdetail/';

  static const String GET_ROOT_CATEGORIES = '${BASE_URL}categories/tree';
  static const String DELETE_ROOT_SUB_CATEGORIES = '${BASE_URL}categories/';
  static const String POST_ADD_CATEGORIES = '${BASE_URL}categories';
  static const String GET_ROOT_CATEGORIES_PRODUCTS =
      '${BASE_URL}Products/ProductCategories?categoryId=';

  static const String GET_USERS_LIST = '${BASE_URL}users';

  static const String GET_CUSTOMER_SUMMARY = '${BASE_URL}customers/summary/';
  static const String POST_APPLY_PAYMENT = '${BASE_URL}payments';
  static const String POST_CUSTOMER_TRANSACTION_SUMMARY =
      '${BASE_URL}reports/transactionsummary/paginated';
  static const String POST_CUSTOMER_OPEN_BALANCE_REPORT =
      '${BASE_URL}reports/transactionsummary';

  // Quick Invoice //
  static const String GET_CATEGORY_PRODUCT_LIST =
      '${BASE_URL}orders/preferred/';
  static const String GET_SUGGESTED_PRODUCT_LIST =
      '${BASE_URL}odata/Products/Names?';
  static const String GET_PRODUCT_DETAIL =
      '${BASE_URL}odata/Products/ForCustomer(CustomerId = ';
  static const String GET_ORDER_HISTORY = '${BASE_URL}customers/product/';
  static const String POST_NEW_SALES_ORDER = '${BASE_URL}salesorders/add';
  static const String POST_EDIT_SALES_ORDER = '${BASE_URL}salesorders/edit';
  static const String GET_EDIT_SALES_ORDER = '${BASE_URL}salesorders/';
  static const String POST_CONVERT_TO_INVOICE = '${BASE_URL}salesorders/';
  static const String GET_EDIT_INVOICE = '${BASE_URL}orders/';
  static const String GET_UNPAID_INVOICE = '${BASE_URL}orders/unpaid/';
  static const String GET_PAYMENT_INVOICE = '${BASE_URL}payments/';
  static const String GET_CREDIT_MEMO_INVOICE = '${BASE_URL}CreditMemo/';
  static const String POST_PUT_NEW_ORDER_INVOICE = '${BASE_URL}orders';

  static const String SEND_EMAIL = '${BASE_URL}email/';
  static const String GET_PRODUCT_DETAIL_BARCODE = '${BASE_URL}customers/';

  //Reports
  static const String CUSTOMER_ITEM_SUMMARY =
      '${BASE_URL}reports/customeritemsummary';
  static const String ORDER_ITEM_SUMMARY =
      '${BASE_URL}reports/orderitemsummary';
  static const String ORDER_ITEM_DETAIL = '${BASE_URL}reports/orderitemdetail';
  static const String PROFIT_LOSS = '${BASE_URL}reports/profitloss';

  static const String APP_TOKEN = "";

  // Combined PDI API //
  static const String COMBINED_PDI_DOWNLOAD =
      '${BASE_URL}products/extractCombinedPDI?createdDate=';
}
