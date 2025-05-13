import 'package:flutter/material.dart';

class Spacing extends StatelessWidget {
  final double height;
  const Spacing({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height.toDouble()),
    );
  }

  Widget get sliver => SliverPadding(
        padding: EdgeInsets.only(bottom: height.toDouble()),
      );

  Widget get side => Padding(
        padding: EdgeInsets.only(left: height.toDouble()),
      );
}
