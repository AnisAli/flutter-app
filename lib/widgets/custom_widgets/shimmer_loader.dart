import '../../exports/index.dart';

class ShimmerCardLoader extends StatelessWidget {
  const ShimmerCardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
