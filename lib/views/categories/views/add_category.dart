import 'package:otrack/views/categories/components/category_info_form.dart';
import 'package:otrack/views/categories/controllers/add_category_controller.dart';

import '../../../exports/index.dart';

class AddCategory extends GetView<AddCategoryController> {
  static const String routeName = '/addCategory';

  const AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      overscroll: false,
      appBarTitle: controller.appBarTitle,
      children: [
        Column(
          children: const [
            CategoryInfoFrom(),
          ],
        ).sliverToBoxAdapter,
      ],
    ).scaffold();
  }
}
