import '../../exports/pub_widgets.dart';

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }

  // Can be added in Context Extensions
  // void hideKeyboard() {
  //   // https://github.com/flutter/flutter/issues/54277#issuecomment-640998757
  //   final currentScope = FocusScope.of(this);
  //   if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
  //     FocusManager.instance.primaryFocus?.unfocus();
  //   }
  // }
}
