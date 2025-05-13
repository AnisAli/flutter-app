import '../exports/index.dart';

class PermissionWrapper extends StatefulWidget {
  final Widget child;
  final String permissionName;
  const PermissionWrapper(
      {Key? key, required this.child, required this.permissionName})
      : super(key: key);

  @override
  State<PermissionWrapper> createState() => _PermissionWrapperState();
}

class _PermissionWrapperState extends State<PermissionWrapper> {
  final AuthManager authController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (authController.hasAccessTo(widget.permissionName)) {
      return widget.child;
    }
    return const SizedBox();
  }
}
