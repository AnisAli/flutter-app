import '../../exports/pub_widgets.dart';

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.boxShape,
  }) : super(key: key);
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape? boxShape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: boxShape == null
            ? BorderRadius.circular(borderRadius ?? 12.0)
            : null,
        color: Colors.white,
        shape: boxShape ?? BoxShape.rectangle,
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final int linesCount;
  final EdgeInsets padding;

  const TitlePlaceholder({
    Key? key,
    required this.width,
    this.linesCount = 2,
    this.height = 12.0,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemBuilder: (_, index) => Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8.0),
        itemCount: linesCount,
      ),
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({
    Key? key,
    required this.lineType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96.0,
            height: 72.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
