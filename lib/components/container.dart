import 'package:flutter/widgets.dart';

class DefaultContainer extends StatelessWidget {
  final Widget child;
  double topbottom = 100;

  DefaultContainer({Key? key, required this.child, this.topbottom = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double leftright = 25;
    return Container(
      margin: EdgeInsets.only(
          top: topbottom, bottom: topbottom, left: leftright, right: leftright),
      child: child,
    );
  }
}
