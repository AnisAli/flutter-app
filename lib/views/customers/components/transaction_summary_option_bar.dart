import '../../../exports/index.dart';

class TransactionSummaryOptionBar extends StatelessWidget {
  final VoidCallback? onPressedOption1;
  final VoidCallback? onPressedOption2;
  final bool isContrastColor;

  const TransactionSummaryOptionBar(
      {Key? key,
      this.onPressedOption1,
      this.onPressedOption2,
      this.isContrastColor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      height: 55,
      color: context.primary,
      child: Row(
        children: [
          InkWell(
            onTap: onPressedOption1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                  color: isContrastColor
                      ? context.scaffoldBackgroundColor
                      : context.primary,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 22,
                    color: isContrastColor
                        ? context.primary
                        : context.scaffoldBackgroundColor,
                  ),
                  const SpaceW4(),
                  Text(AppStrings.FILTER,
                      style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isContrastColor
                              ? context.primary
                              : context.scaffoldBackgroundColor)),
                ],
              ),
            ),
          ),
          VerticalDivider(
            thickness: 2,
            width: 40,
            color: context.scaffoldBackgroundColor,
          ),
          InkWell(
            onTap: onPressedOption2,
            child: Text(
              AppStrings.SORT_BY,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: context.scaffoldBackgroundColor,
              ),
            ),
          ),
          VerticalDivider(
            thickness: 2,
            width: 40,
            color: context.scaffoldBackgroundColor,
          ),
        ],
      ),
    );
  }
}
