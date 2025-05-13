import '../../../exports/index.dart';

class UserListCard extends StatelessWidget {
  final UserListModel userListModel;
  const UserListCard({Key? key, required this.userListModel}) : super(key: key);

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
            _buildUserCardInfo(context),
          ])),
    );
  }

  Expanded _buildUserCardInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userListModel.fullName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: context.primary),
                ),
                Text(
                  userListModel.role ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      context.titleMedium.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SpaceH4(),
            Text(
              userListModel.email ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyText2.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: context.iconColor1),
            ),
          ],
        ),
      ),
    );
  }
}
