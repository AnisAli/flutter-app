import '../../../exports/index.dart';
import '../components/product_info_form.dart';

class AddProduct extends GetView<AddProductController> {
  static const String routeName = '/addProduct';

  const AddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pinAppBar: true,
      showMenuButton: false,
      showThemeButton: false,
      simpleAppBar: _buildSimpleAppBar(context),
      children: [
        Column(
          children: const [
            ProductInfoForm(),
          ],
        ).sliverToBoxAdapter,
      ],
    ).scaffold();
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (controller.productAddCheck ?? false) {
            Get.offAllNamed(AppRoutes.PRODUCTS);
          } else {
            Get.back();
          }
        },
      ),
      primary: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.onBackground, //change your color here
      ),
      pinned: true,
      centerTitle: true,
      title: Text(
        (controller.arguments["backRoute"] ||
                controller.isClone == true)
            ? AppStrings.ADD_PRODUCT
            : AppStrings.EDIT_PRODUCT,
        style: context.titleMedium,
      ),
    );
  }
}
