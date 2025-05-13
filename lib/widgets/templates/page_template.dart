import '../../exports/index.dart';

import 'action_buttons/back_button.dart';
import 'action_buttons/menu_button.dart';
import 'action_buttons/theme_button.dart';
import 'custom_drawer/custom_drawer.dart';
import 'space.dart';

class PageTemplate extends GetView<MyDrawerController> {
  final List<Widget> children;
  final bool showBackButton;
  final bool showMenuButton;
  final bool showThemeButton;
  final bool pinAppBar;
  final bool overscroll;
  final bool resizeToAvoidBottomInset;
  final Widget actionButton;
  final double padding;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final ScrollPhysics? physics;
  final String appBarTitle;
  final Widget? extendedAppBar;
  final double? extendedAppBarSize;
  final Widget? simpleAppBar;
  final ScrollController? scrollController;
  final Widget? customBottomNavigationBar;

  const PageTemplate(
      {super.key,
      this.extendedAppBarSize = 140,
      required this.children,
      this.showBackButton = false,
      this.extendedAppBar,
      this.simpleAppBar,
      this.customBottomNavigationBar,
      this.showMenuButton = true,
      this.showThemeButton = true,
        this.resizeToAvoidBottomInset = true,
      this.pinAppBar = false,
      this.actionButton = const ThemeButton(),
      this.overscroll = true,
      this.scaffoldKey,
      this.scrollController,
      this.padding = Sizes.PADDING_20,
      this.physics,
      this.appBarTitle = ''});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.only(left: padding, right: padding),
        child: CustomScrollView(
          physics: physics,
          controller: scrollController,
          slivers: <Widget>[
            if (!pinAppBar && extendedAppBar == null)
              Spacing(height: context.statusBarHeight * 1.3).sliver,
            if (extendedAppBar != null) _buildExtendedAppBar(context),
            if (simpleAppBar != null) simpleAppBar ?? Container(),
            if (pinAppBar && simpleAppBar == null && extendedAppBar == null)
              _buildSimpleAppBar(context)
            // Build AppBar with both Menu and Theme Button
            else if (showMenuButton && showThemeButton)
              _buildCompleteAppBar(
                firstActionButton: const MenuButton(),
                secondActionButton: actionButton,
              ).sliverToBoxAdapter

            // Build AppBar with only Back Button
            else if (showBackButton)
              _buildPartialAppBar(
                action: const AppBackButton(),
              ).sliverToBoxAdapter
            // Build AppBar with only Menu Button
            else if (showMenuButton)
              _buildPartialAppBar(
                action: const MenuButton(),
              ).sliverToBoxAdapter

            // Build AppBar with only Theme Button
            else if (showThemeButton)
              _buildPartialAppBar(
                action: actionButton,
                crossAxisAlignment: CrossAxisAlignment.end,
              ).sliverToBoxAdapter

            // No Action Button
            else
              const Spacing(height: Sizes.HEIGHT_1).sliver,

            // End of AppBar

            // Body Widgets
            ...children,

            // allow for some overscroll
            // this is a feature, not a bug
            if (overscroll) ...[
              const Spacing(height: Sizes.HEIGHT_100).sliver,
            ]
          ],
        ),
      ),
    );
  }

  Column _buildPartialAppBar({
    required Widget action,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        const Spacing(height: Sizes.HEIGHT_16),
        // Using wrap so it doesn't take 100% width
        Wrap(children: <Widget>[action]),

        const Spacing(height: Sizes.HEIGHT_16),
      ],
    );
  }

  Column _buildCompleteAppBar({
    Widget firstActionButton = const AppBackButton(),
    Widget secondActionButton = const ThemeButton(),
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacing(height: Sizes.HEIGHT_16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            firstActionButton,
            secondActionButton,
          ],
        ),
        const Spacing(height: Sizes.HEIGHT_16),
      ],
    );
  }

  Widget scaffold() {
    return Scaffold(
      body: this,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
        child: customBottomNavigationBar,
      ),
    );
  }

  Widget _buildExtendedAppBar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.onBackground, //change your color here
      ),
      floating: !pinAppBar,
      snap: !pinAppBar,
      pinned: pinAppBar,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(extendedAppBarSize ?? 140),
        child: Container(
          child: extendedAppBar,
        ),
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: context.onBackground, //change your color here
      ),
      pinned: pinAppBar,
      centerTitle: true,
      title: Text(
        appBarTitle,
        style: context.titleMedium,
      ),
    );
  }

  Widget scaffoldWithDrawer() {
    controller.setKey = scaffoldKey!;
    return Scaffold(
      key: scaffoldKey,
      drawer: scaffoldKey == null ? null : const CustomDrawer(),
      body: this,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
        child: customBottomNavigationBar,
      ),
    );
  }
}
