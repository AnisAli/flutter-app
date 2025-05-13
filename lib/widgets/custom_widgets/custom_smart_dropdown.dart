import '../../exports/index.dart';
import 'package:dropdown_search/dropdown_search.dart';

enum SelectionType { single, multiple }

class CustomDropDownField<T> extends StatefulWidget {
  final SelectionType selectionType;
  final String title;
  final String? dropDownTileTitle;
  final TextEditingController controller;
  final void Function(T?)? onChange;
  final void Function(List<T>)? onMultipleChange;

  final List<T>? items;
  final Future<List<T>> Function(String)? asyncItems;
  final List<T>? selectedItems;
  final T? selectedItem;
  final bool Function(T, T)? compareFn;

  final Widget Function(BuildContext context, T item, bool selected)?
      itemBuilder;
  final IconData? prefixIcon;

  final bool isRequired;
  final bool isEnabled;
  final bool showSearchBox;
  final bool showLoading;
  final double verticalPadding;
  final FlexFit fit;

  const CustomDropDownField({
    Key? key,
    this.selectedItems,
    required this.title,
    required this.controller,
    this.onChange,
    this.onMultipleChange,
    this.items,
    this.asyncItems,
    this.selectedItem,
    this.dropDownTileTitle,
    this.prefixIcon,
    this.isRequired = false,
    this.showSearchBox = false,
    this.verticalPadding = Sizes.PADDING_6,
    this.compareFn,
    this.itemBuilder,
    this.selectionType = SelectionType.single,
    this.fit = FlexFit.tight,
    this.isEnabled = true,
    this.showLoading = false,
  }) : super(key: key);

  @override
  State<CustomDropDownField<T>> createState() => _CustomDropDownFieldState<T>();
}

class _CustomDropDownFieldState<T> extends State<CustomDropDownField<T>> {
  late final TextEditingController searchController;
  late final GlobalKey<DropdownSearchState> key;

  @override
  void initState() {
    super.initState();
    key = GlobalKey<DropdownSearchState>();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.selectionType) {
      case SelectionType.single:
        return _buildSingleSelectionDropDown(context);
      case SelectionType.multiple:
        return _buildMultiSelectionDropDown(context);
    }
  }

  Widget _buildSingleSelectionDropDown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
      child: DropdownSearch<T>(
        key: key,
        items: widget.items ?? [],
        asyncItems: widget.asyncItems,
        selectedItem: widget.selectedItem,
        enabled: widget.isEnabled,
        compareFn: widget.compareFn ?? (a, b) => a == b,
        onChanged: (selected) {
          searchController.clear();
          if (widget.onChange != null) widget.onChange!(selected);
        },
        validator: (value) {
          if (!widget.isRequired) {
            return null;
          } else if (value == null) {
            return 'Select a ${widget.title}';
          }
          return null;
        },
        dropdownButtonProps: _buildDropdownButtonProps(context),
        popupProps: PopupPropsMultiSelection.modalBottomSheet(
          showSelectedItems: true,
          showSearchBox: widget.showSearchBox,
          isFilterOnline: false,
          fit: widget.fit,
          itemBuilder: _buildDropDownItem,
          modalBottomSheetProps: _buildModalBottomSheetProps(context),
          loadingBuilder: (_, __) =>
              Center(child: CustomLoading.cupertinoIndicatorLarge),
          searchFieldProps: _buildSearchFieldProps(context),
          emptyBuilder: (_, __) => const EmptyListIndicator(),
          errorBuilder: (_, __, ___) => const GenericErrorIndicator(),
        ),
        dropdownDecoratorProps: _buildDropDownTileProps(context),
      ),
    );
  }

  Widget _buildMultiSelectionDropDown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
      child: DropdownSearch<T>.multiSelection(
        items: widget.items ?? [],
        asyncItems: widget.asyncItems,
        enabled: widget.isEnabled,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        selectedItems: widget.selectedItems ?? [],
        compareFn: widget.compareFn ?? (a, b) => a == b,
        // Todo Implement onChanged For MultiSelection
        onChanged: (selected) {
          searchController.clear();
          if (widget.onMultipleChange != null)
            widget.onMultipleChange!(selected);
        },
        dropdownButtonProps: _buildDropdownButtonProps(context),
        popupProps: PopupPropsMultiSelection.modalBottomSheet(
          showSelectedItems: true,
          showSearchBox: widget.showSearchBox,
          isFilterOnline: false,
          fit: widget.fit,
          itemBuilder: _buildDropDownItem,
          modalBottomSheetProps: _buildModalBottomSheetProps(context),
          loadingBuilder: (_, __) => CustomLoading.cupertinoIndicatorLarge,
          searchFieldProps: _buildSearchFieldProps(context),
          emptyBuilder: (_, __) => const EmptyListIndicator(),
          errorBuilder: (_, __, ___) => const GenericErrorIndicator(),
        ),
        dropdownDecoratorProps: _buildDropDownTileProps(context),
      ),
    );
  }

  ModalBottomSheetProps _buildModalBottomSheetProps(BuildContext context) {
    return ModalBottomSheetProps(
      backgroundColor: context.scaffoldBackgroundColor,
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 350),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.RADIUS_16),
          topRight: Radius.circular(Sizes.RADIUS_16),
        ),
      ),
    );
  }

  DropDownDecoratorProps _buildDropDownTileProps(BuildContext context) {
    return DropDownDecoratorProps(
      dropdownSearchDecoration: textField.buildInputDecoration(context),
      baseStyle: context.titleMedium.copyWith(
        color: context.titleLarge.color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  TextFieldProps _buildSearchFieldProps(BuildContext context) {
    return TextFieldProps(
      controller: searchController,
      decoration: searchField.buildInputDecoration(context),
      cursorColor: context.primaryColor,
      keyboardType: TextInputType.text,
    );
  }

  CustomTextFormField get textField => _buildTextTileField();

  CustomTextFormField _buildTextTileField() {
    return CustomTextFormField(
      autofocus: false,
      readOnly: true,
      isRequired: widget.isRequired,
      controller: widget.controller,
      labelText: widget.title,
      prefixIconData: widget.prefixIcon,
      suffixIconData: Iconsax.arrow_down5,
    );
  }

  CustomTextFormField get searchField => _buildSearchTextField();

  CustomTextFormField _buildSearchTextField() {
    return CustomTextFormField(
      autofocus: false,
      controller: searchController,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelText: AppStrings.SEARCH_HINT_TEXT,
      labelColor: DarkTheme.darkShade3,
      suffixIconColor: LightTheme.grayColorShade0,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.emailAddress,
      prefixIconData: Iconsax.search_normal_1,
      suffixIconData: Iconsax.close_circle5,
      onSuffixTap: searchController.clear,
    );
  }

  DropdownButtonProps _buildDropdownButtonProps(BuildContext context) {
    return DropdownButtonProps(
      color: context.primaryColor,
      icon: widget.isEnabled
          ? widget.showLoading
              ? CustomLoading.cupertinoIndicatorMedium
              : Icon(
                  Iconsax.arrow_down5,
                  size: Sizes.ICON_SIZE_20,
                  color: context.primaryColor,
                )
          : widget.showLoading
              ? CustomLoading.cupertinoIndicatorMedium
              : const SizedBox.shrink(),
    );
  }

  Widget _buildDropDownItem(
    BuildContext context,
    T title,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_8),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: Sizes.PADDING_16),
        minVerticalPadding: 0,
        visualDensity: const VisualDensity(vertical: -2.5),
        selectedTileColor: context.fillColor,
        selected: isSelected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
        ),
        leading: widget.onMultipleChange != null
            ? null
            : isSelected
                ? Icon(
                    Icons.radio_button_checked_rounded,
                    size: Sizes.ICON_SIZE_22,
                    color: context.primaryColor,
                  )
                : Icon(
                    Icons.radio_button_unchecked_rounded,
                    size: Sizes.ICON_SIZE_22,
                    color: context.backgroundColor,
                  ),
        title: Text(
          widget.dropDownTileTitle ?? title.toString(),
          style: context.bodyLarge.copyWith(
            color: isSelected ? context.primaryColor : context.bodyLarge.color,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
