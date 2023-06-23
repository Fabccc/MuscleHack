import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class DefaultContainer extends StatelessWidget {
  final Widget child;
  double topbottom = 100;
  double leftright = 25;

  DefaultContainer(
      {Key? key, required this.child, this.topbottom = 50, this.leftright = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: topbottom, bottom: topbottom, left: leftright, right: leftright),
      child: child,
    );
  }
}
