import 'package:otrack/views/categories/components/category_card.dart';

import '../../../exports/index.dart';

class Categories extends GetView<CategoryController> {
  static const String routeName = '/categories';

  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      overscroll: false,
      showThemeButton: false,
      showMenuButton: false,
      simpleAppBar: _buildSimpleAppBar(context),
      pinAppBar: true,
      scaffoldKey: controller.scaffoldKey,
      children: [
        Obx(() => controller.isShimmerEffectLoading.value
            ? const ProductShimmer().sliverToBoxAdapter
            : _buildCategoryList(context).sliverToBoxAdapter)
      ],
    ).scaffoldWithDrawer();
  }

  Widget _buildCategoryList(BuildContext context) {
    // Sort the categories in ascending order based on rootCategoryName
    controller.rootCategories.sort((a, b) =>
        (a.rootCategoryName ?? '').compareTo(b.rootCategoryName ?? ''));
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.rootCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              if (controller.rootCategories[index].subCategories?.isNotEmpty ??
                  false) {
                Get.toNamed(AppRoutes.CATEGORY_DETAIL, arguments: {
                  'category': controller.rootCategories[index],
                });
              }
            },
            child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.5,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) async {
                        if (controller.rootCategories[index].canDelete ??
                            false) {
                          await controller.deleteCategory(controller
                              .rootCategories[index].categoryId
                              .toString());
                        }
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon:
                          (controller.rootCategories[index].canDelete ?? false)
                              ? Icons.delete
                              : Icons.delete_forever_outlined,
                      padding: const EdgeInsets.all(5),
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        Get.toNamed(AppRoutes.ADD_CATEGORY, arguments: {
                          "pageType": 'editCategory',
                          "category": controller.rootCategories[index],
                          "fromProductPage": false
                        });
                      },
                      backgroundColor: Colors.yellow.shade800,
                      foregroundColor: Colors.white,
                      icon: Icons.edit_outlined,
                      padding: const EdgeInsets.all(5),
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        Get.toNamed(AppRoutes.ADD_CATEGORY, arguments: {
                          "pageType": 'newSubCategory',
                          "category": controller.rootCategories[index],
                          "fromProductPage": false
                        });
                      },
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      icon: Icons.add,
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                ),
                child: CategoryCard(
                  categoryName:
                      controller.rootCategories[index].rootCategoryName ?? '',
                  noOfSubs:
                      controller.rootCategories[index].subCategories?.length ??
                          0,
                )),
          );
        },
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      actions: [_buildAddNewParentCategoryButton(context)],
      primary: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.onBackground, //change your color here
      ),
      pinned: true,
      centerTitle: true,
      title: Text(
        '',
        style: context.titleMedium,
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
      onPressed: () => Get.toNamed(AppRoutes.ADD_CATEGORY, arguments: {
        "pageType": 'newCategory',
        "category": null,
        "fromProductPage": false
      }),
      verticalMargin: 0,
      textColor: Colors.white,
      text: AppStrings.CATEGORY,
      hasInfiniteWidth: false,
    );
  }
}
