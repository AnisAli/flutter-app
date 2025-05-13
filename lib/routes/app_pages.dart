import '../exports/index.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      children: [
        GetPage(
          name: AppRoutes.FORGOT_PASS,
          page: () => const ForgotPassword(),
          binding: ForgotPassBinding(),
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: AppRoutes.CUSTOMERS,
      page: () => const Customers(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_CUSTOMER,
      page: () => const AddCustomer(),
      binding: AddCustomerBinding(),
    ),
    GetPage(
      name: AppRoutes.CUSTOMER_DETAIL,
      page: () => const CustomerDetail(),
      binding: CustomerDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.PAYMENT_RECEIVED,
      page: () => const PaymentReceived(),
      binding: PaymentReceivedBinding(),
    ),
    GetPage(
      name: AppRoutes.CUSTOMER_OPEN_BALANCE_REPORT,
      page: () => const CustomerOpenBalanceReport(),
      binding: CustomerOpenBalanceReportBinding(),
    ),
    GetPage(
      name: AppRoutes.VENDORS,
      page: () => const Vendors(),
      binding: VendorBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_VENDOR,
      page: () => const AddVendor(),
      binding: AddVendorBinding(),
    ),
    GetPage(
      name: AppRoutes.VENDOR_DETAIL,
      page: () => const VendorDetail(),
      binding: VendorDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.VENDOR_AGING,
      page: () => const VendorAging(),
      binding: VendorAgingBinding(),
    ),
    GetPage(
      name: AppRoutes.QUICK_INVOICE,
      page: () => const QuickInvoice(),
      binding: QuickInvoiceBinding(),
    ),
    GetPage(
      name: AppRoutes.INVOICE_VIEW,
      page: () => const InvoiceView(),
      binding: InvoiceViewBinding(),
    ),
    GetPage(
      name: AppRoutes.PRODUCTS,
      page: () => const Products(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_PRODUCT,
      page: () => const AddProduct(),
      binding: AddProductBinding(),
    ),
    GetPage(
      name: AppRoutes.ITEM_REPORT,
      page: () => const ItemReport(),
      binding: ItemReportBinding(),
    ),
    GetPage(
      name: AppRoutes.CATEGORIES,
      page: () => const Categories(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.CATEGORY_DETAIL,
      page: () => const CategoryDetail(),
      binding: CategoryDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_CATEGORY,
      page: () => const AddCategory(),
      binding: AddCategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFIT_LOSS_OVERVIEW,
      page: () => const ProfitLossOverview(),
      binding: ProfitLossOverviewBinding(),
    ),
    GetPage(
      name: AppRoutes.OPEN_BALANCE,
      page: () => const OpenBalance(),
      binding: OpenBalanceBinding(),
    ),
    GetPage(
      name: AppRoutes.SALES_BY_ITEM,
      page: () => const SalesByItem(),
      binding: SalesByItemBinding(),
    ),
    GetPage(
      name: AppRoutes.SALES_BY_CUSTOMER,
      page: () => const SalesByCustomer(),
      binding: SalesByCustomerBinding(),
    ),
    GetPage(
      name: AppRoutes.SALES_BY_INDIVIDUAL_ITEM,
      page: () => const SalesByIndividualItem(),
      binding: SalesByIndividualItemBinding(),
    ),
    GetPage(
      name: AppRoutes.COMPANY_PROFILE,
      page: () => const CompanyProfile(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: AppRoutes.USERS_LIST,
      page: () => const UsersList(),
      binding: UsersListBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_USER_LIST,
      page: () => const AddUserList(),
      binding: AddUserListBinding(),
    ),
    GetPage(
      name: AppRoutes.ROLES_LIST,
      page: () => const RolesList(),
      binding: RolesListBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_ROLE,
      page: () => const AddRole(),
      binding: AddRoleBinding(),
    ),
  ];
}
