import '../../exports/index.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncWidgetBuilder<T> hasDataBuilder;
  final String errorMsg;
  final double loaderSize;
  const CustomStreamBuilder({
    Key? key,
    required this.stream,
    required this.hasDataBuilder,
    this.errorMsg = 'Failed to Retrieve your data.',
    this.loaderSize = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: context.primaryColor),
          );
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            return hasDataBuilder(context, snapshot);
          } else {
            return Center(
              child: Text(
                errorMsg,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        } else {
          return Center(
            child: Text(
              'State: ${snapshot.connectionState}',
              style: TextStyle(color: context.primaryColor),
            ),
          );
        }
      },
    );
  }
}
