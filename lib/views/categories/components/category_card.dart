import '../../../exports/index.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final int noOfSubs;
  const CategoryCard({Key? key, required this.categoryName, this.noOfSubs = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade400, width: 0.5))),
      child: Card(
          borderOnForeground: false,
          elevation: 0,
          margin: const EdgeInsets.all(0),
          color: context.scaffoldBackgroundColor,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _buildCardInfo(context),
          ])),
    );
  }

  Expanded _buildCardInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyText1.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            if (noOfSubs != 0)
              Row(
                children: [
                  Icon(
                    Icons.subdirectory_arrow_right_outlined,
                    color: context.iconColor1,
                  ),
                  Text(
                    '$noOfSubs',
                    style: context.titleSmall,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
