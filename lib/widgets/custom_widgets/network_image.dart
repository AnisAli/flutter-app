import '../../exports/index.dart';

class ViewNetworkImage extends StatelessWidget {
  const ViewNetworkImage({super.key, this.name, this.imageUrl, this.fit});
  final String? name;
  final String? imageUrl;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: fit ?? BoxFit.contain,
            errorWidget: (context, url, error) => Padding(
              padding: const EdgeInsets.all(Sizes.PADDING_8 / 2),
              child: Image.asset(
                AppAssets.getPNGIcon('info'),
              ),
            ),
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(Sizes.PADDING_8 / 2),
              child: ShimmerCardLoader(),
            ),
          )
        : Image.asset(
            name!,
            fit: fit ?? BoxFit.contain,
            errorBuilder: (context, object, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(Sizes.PADDING_8 / 2),
                child: Image.asset(AppAssets.getPNGIcon('info')),
              );
            },
          );
  }
}
