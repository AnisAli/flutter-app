import '../../../exports/index.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final BoxFit fit;
  final String? src;
  final double radius;

  const NetworkImageWithLoader(
    this.src, {
    Key? key,
    this.fit = BoxFit.cover,
    this.radius = Sizes.PADDING_16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: src != null
          ? CachedNetworkImage(
              fit: fit,
              imageUrl: src!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                  ),
                ),
              ),
              placeholder: (context, url) => const Skeleton(),
              errorWidget: (context, url, error) => Center(
                child: Icon(
                  Iconsax.gallery,
                  size: Sizes.ICON_SIZE_40,
                  color: context.onBackground,
                ),
              ),
            )
          : Center(
              child: Icon(
                Iconsax.gallery,
                size: Sizes.ICON_SIZE_40,
                color: context.onBackground,
              ),
            ),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width, this.layer = 1})
      : super(key: key);

  final double? height, width;
  final int layer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(Sizes.PADDING_16 / 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04 * layer),
        borderRadius: const BorderRadius.all(
          Radius.circular(Sizes.PADDING_16),
        ),
      ),
    );
  }
}
