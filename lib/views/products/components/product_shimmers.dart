import '../../../exports/index.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: Sizes.PADDING_8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.getResponsiveValue(
          mobile: 1,
          tablet: 2,
          desktop: 3,
        ),
        mainAxisExtent: 130,
        crossAxisSpacing: Sizes.PADDING_8,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 20,
      itemBuilder: (_, index) => _buildProductCard(context),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: Sizes.PADDING_4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.RADIUS_12),
        color: context.cardColor,
      ),
      child: _buildCardContent().shimmerWidget,
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(Sizes.PADDING_8),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconButton(),
              const SpaceW4(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          TitlePlaceholder(
                            width: 80,
                            linesCount: 1,
                            padding: EdgeInsets.symmetric(
                              vertical: Sizes.PADDING_2,
                            ),
                          ),
                          TitlePlaceholder(
                            width: 40,
                            linesCount: 1,
                            padding: EdgeInsets.symmetric(
                              vertical: Sizes.PADDING_2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const TitlePlaceholder(
                      width: 150,
                      linesCount: 1,
                      padding: EdgeInsets.symmetric(
                        vertical: Sizes.PADDING_4,
                      ),
                    ),
                    const Spacer(),
                    const TitlePlaceholder(
                      width: 40,
                      linesCount: 1,
                      padding: EdgeInsets.symmetric(
                        vertical: Sizes.PADDING_2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: Sizes.PADDING_4,
            right: Sizes.PADDING_0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                TitlePlaceholder(
                  width: Sizes.WIDTH_60,
                  linesCount: 1,
                  padding: EdgeInsets.symmetric(vertical: Sizes.PADDING_2),
                ),
                TitlePlaceholder(
                  width: Sizes.WIDTH_80,
                  linesCount: 1,
                  padding: EdgeInsets.symmetric(vertical: Sizes.PADDING_2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        height: Sizes.HEIGHT_60,
        width: Sizes.WIDTH_60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Sizes.RADIUS_10),
        ),
      ),
    );
  }
}
