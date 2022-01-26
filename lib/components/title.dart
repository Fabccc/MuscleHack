import 'package:flutter/widgets.dart';

class HeaderText extends StatelessWidget {
  final String text;
  double fontSize;
  double paddingBottom;

  HeaderText(
      {Key? key,
      required this.text,
      this.fontSize = 36,
      this.paddingBottom = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: paddingBottom),
      child: Text(text,
          style: TextStyle(
              fontFamily: "Ubuntu",
              color: const Color(0xff4a8cfc),
              fontSize: fontSize)),
    );
  }
}

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
