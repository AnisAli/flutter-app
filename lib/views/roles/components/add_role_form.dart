import '../../../exports/index.dart';

class AddRoleForm extends GetView<AddRoleController> {
  const AddRoleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_8),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.cardColor,
          width: Sizes.WIDTH_2,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Sizes.RADIUS_12),
          bottomRight: Radius.circular(Sizes.RADIUS_12),
          bottomLeft: Radius.circular(Sizes.RADIUS_12),
        ),
      ),
      child: Form(
        key: controller.addRoleFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH8(),
            _buildTextFields(context),
            const SpaceH24(),
            _buildPermissions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionChecklist(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => controller.onlyForUpdateState.value
              ? _buildCheckListBuilder(context)
              : _buildCheckListBuilder(context))
        ],
      ),
    );
  }

  Widget _buildCheckListBuilder(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.applicationPermissionsModel.permissions!
          .where((permission) => permission.parentId == null)
          .length,
      itemBuilder: (BuildContext context, int parentIndex) {
        final parentPermission = controller
            .applicationPermissionsModel.permissions!
            .where((permission) => permission.parentId == null)
            .elementAt(parentIndex);
        return CheckboxListTile(
          title: ExpansionTile(
            title: Text(
              parentPermission.name ?? '',
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.applicationPermissionsModel.permissions!
                    .where((permission) =>
                        permission.parentId == parentPermission.id)
                    .length,
                itemBuilder: (BuildContext context, int childIndex) {
                  final childPermission = controller
                      .applicationPermissionsModel.permissions!
                      .where((permission) =>
                          permission.parentId == parentPermission.id)
                      .elementAt(childIndex);
                  return CheckboxListTile(
                    title: Text(childPermission.name ?? ''),
                    value: controller
                        .checkListGates[childPermission.id ?? 0]?.value,
                    onChanged: (value) {
                      controller.checkListGates[childPermission.id ?? 0]
                          ?.value = value ?? false;

                      controller.onlyForUpdateState(
                          !controller.onlyForUpdateState.value);
                    },
                  );
                },
              ),
            ],
          ),
          value: controller.checkListGates[parentPermission.id ?? 0]?.value,
          onChanged: (value) {
            controller.checkListGates[parentPermission.id ?? 0]?.value =
                value ?? false;
            // Toggle selection for children permissions
            final childrenPermissions =
                controller.applicationPermissionsModel.permissions!.where(
                    (permission) => permission.parentId == parentPermission.id);
            for (var childPermission in childrenPermissions) {
              controller.checkListGates[childPermission.id ?? 0]?.value =
                  value ?? false;
            }

            controller.onlyForUpdateState(!controller.onlyForUpdateState.value);
          },
        );
      },
    );
  }

  Widget _buildPermissions(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Permissions:",
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w500),
              ),
              const SpaceH12(),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Text(
                  "${controller.applicationPermissionsModel.application}",
                  style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w500, color: context.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildPermissionChecklist(context)
            ],
          ));
  }

  StaggeredGrid _buildTextFields(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: Responsive.getResponsiveValue(mobile: 1, tablet: 2),
      crossAxisSpacing: Sizes.PADDING_8,
      mainAxisSpacing: Sizes.PADDING_4,
      children: [
        CustomTextFormField(
          autofocus: false,
          isRequired: true,
          controller: controller.nameController,
          labelText: AppStrings.NAME,
          prefixIconData: Iconsax.user,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        CustomTextFormField(
          autofocus: false,
          isRequired: false,
          controller: controller.descriptionController,
          labelText: AppStrings.DESCRIPTION,
          prefixIconData: Iconsax.receipt,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
