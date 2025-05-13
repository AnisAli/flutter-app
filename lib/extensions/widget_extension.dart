part of extensions;

extension WidgetExtensions on Widget {
  Widget get sliverToBoxAdapter => SliverToBoxAdapter(child: this);

  Widget get sliverFillViewPort => SliverFillViewport(
        delegate: SliverChildListDelegate(
          [this],
        ),
      );

  Widget get sliverFillRemaining => SliverFillRemaining(
        hasScrollBody: true,
        fillOverscroll: true,
        child: this,
      );

  Widget staggeredGridTile({
    int crossAxisCellCount = 1,
    num mainAxisCellCount = 1,
  }) =>
      StaggeredGridTile.count(
        crossAxisCellCount: crossAxisCellCount,
        mainAxisCellCount: mainAxisCellCount,
        child: this,
      );

  Widget get addRepaintBoundary => RepaintBoundary(child: this);

  Widget addConstrainedBox({double maxWidth = 450}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: this,
    );
  }

  Widget get shimmerWidget => Shimmer.fromColors(
        baseColor: Get.context!.isDark
            ? DarkTheme.shimmerBaseColor
            : LightTheme.shimmerBaseColor,
        highlightColor: Get.context!.isDark
            ? DarkTheme.shimmerHighlightColor
            : LightTheme.shimmerHighlightColor,
        enabled: true,
        child: this,
      );

  Widget fadeScaleTransition({
    int delay = 0,
    AnimDirection animationDirection = AnimDirection.bottomToTop,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return FadeSlideTransition(
      animationDirection: animationDirection,
      duration: duration,
      delay: delay,
      child: this,
    );
  }
}
