import 'package:otrack/views/customers/components/customer_info_form.dart';

import '../../../exports/index.dart';

class AddCustomer extends GetView<AddCustomerController> {
  static const String routeName = '/addCustomer';

  const AddCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      overscroll: false,
      appBarTitle: (controller.argsCustomer==null)?AppStrings.ADD_CUSTOMER:AppStrings.EDIT_CUSTOMER,
      children: [
        Column(
          children: const [
            CustomerInfoForm(),
          ],
        ).sliverToBoxAdapter,
      ],
    ).scaffold();
  }
}
