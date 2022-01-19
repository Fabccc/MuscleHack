import 'package:flutter/widgets.dart';

class HeaderText extends StatelessWidget {
  final String text;
  double fontSize = 36;

  HeaderText({Key? key, required this.text, this.fontSize = 36})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontFamily: "Ubuntu",
            color: const Color(0xff4a8cfc),
            fontSize: fontSize));
  }
}

class StandarText extends StatelessWidget {
  final String text;

  const StandarText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontFamily: "Ubuntu", fontSize: 18));
  }
}
