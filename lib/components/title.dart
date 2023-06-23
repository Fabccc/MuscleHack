import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class HeaderText extends StatelessWidget {
  final String text;
  double fontSize;
  double paddingBottom;
  double paddingTop;
  double paddingLeft;

  HeaderText(
      {Key? key,
      required this.text,
      this.fontSize = 36,
      this.paddingBottom = 25,
      this.paddingTop = 0,
      this.paddingLeft = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: paddingBottom, left: paddingLeft, top: paddingTop),
      child: Text(text,
          style: TextStyle(
              fontFamily: "Ubuntu",
              color: const Color(0xff4a8cfc),
              fontSize: fontSize)),
    );
  }
}

// ignore: must_be_immutable
class StandarText extends StatelessWidget {
  final String text;
  double fontSize;
  Color color;

  StandarText(
      {Key? key,
      required this.text,
      this.fontSize = 16,
      this.color = const Color(0xff030303)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style:
            TextStyle(fontFamily: "Ubuntu", fontSize: fontSize, color: color));
  }
}
