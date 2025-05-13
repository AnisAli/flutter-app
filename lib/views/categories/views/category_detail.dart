import 'package:otrack/views/categories/controllers/category_detail_controller.dart';

import '../../../exports/index.dart';
import '../components/category_card.dart';

class CategoryDetail extends GetView<CategoryDetailController> {
  static const String routeName = '/categoryDetail';

  const CategoryDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      showBackButton: true,
      actionButton: _buildAddNewParentCategoryButton(context),
      scaffoldKey: controller.scaffoldKey,
      children: [_buildCategoryList(context).sliverToBoxAdapter],
    ).scaffoldWithDrawer();
  }

  Widget _buildCategoryList(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.category.subCategories?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {},
            child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.5,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) async {
                        await controller.deleteSubCategory(controller
                                .category.subCategories?[index].categoryId
                                .toString() ??
                            '');
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      padding: const EdgeInsets.all(5),
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        Get.toNamed(AppRoutes.ADD_CATEGORY, arguments: {
                          "pageType": 'editSubCategory',
                          "subCategory": controller.category.subCategories?[index],
                          "fromProductPage": false
                        });
                      },
                      backgroundColor: Colors.yellow.shade800,
                      foregroundColor: Colors.white,
                      icon: Icons.edit_outlined,
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                ),
                child: CategoryCard(
                  categoryName:
                      controller.category.subCategories?[index].name ?? '',
                )),
          );
        },
      ),
    );
  }

  Widget _buildAddNewParentCategoryButton(BuildContext context) {
    return CustomButton(
      buttonType: ButtonType.textWithImage,
      constraints: const BoxConstraints(minWidth: 100),
      color: context.primaryColor,
      image: const Icon(Iconsax.add, color: Colors.white),
      buttonPadding: const EdgeInsets.symmetric(
        vertical: Sizes.PADDING_8,
        horizontal: Sizes.PADDING_12,
      ),
      customTextStyle: context.titleMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      onPressed: () {},
      verticalMargin: 0,
      textColor: Colors.white,
      text: AppStrings.SUB_CATEGORY,
      hasInfiniteWidth: false,
    );
  }
}
