import '../../../exports/index.dart';
import 'components/expanded_drawer.dart';

class CustomDrawer extends GetView<MyDrawerController> {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ExpandedDrawer(),
    );
    // Obx(
    //   () => Row(
    //     children: [
    //       AnimatedSize(
    //         duration: const Duration(milliseconds: 200),
    //         child: controller.isExpanded.value
    //             ? ExpandedDrawer()
    //             : CollapsedDrawer(),
    //       ),
    //       CollapsedDrawer().invisibleSubMenus(context),
    //     ],
    //   ),
    // );
  }
}
