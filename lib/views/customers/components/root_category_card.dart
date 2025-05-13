import '../../../exports/index.dart';

class RootCategoryCard extends StatelessWidget {
  late String categoryName;

  RootCategoryCard({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String firstCharacter = categoryName.isNotEmpty ? categoryName[0] : '';
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text(
            firstCharacter.toUpperCase(),
            textAlign: TextAlign.center,
            style:
                context.titleLarge.copyWith(color: Colors.white, fontSize: 40),
          )),
        ),
        Text(
          categoryName,
          textAlign: TextAlign.center,
          style: context.captionMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
