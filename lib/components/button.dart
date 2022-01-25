import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuButton extends StatelessWidget {
  final Function? onPressed;
  final String content;

  const MenuButton({Key? key, this.onPressed, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            elevation: 7,
            shadowColor: Colors.black45,
            backgroundColor: const Color(0xffffffff),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            side: const BorderSide(width: 1.5, color: Colors.white)),
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Text(content,
              style: const TextStyle(
                  color: Color(0xff4a8cfc),
                  fontSize: 18,
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.normal)),
        ));
  }
}

class DefaultButton extends StatelessWidget {
  final Function? onPressed;
  final String content;
  Color color;
  int fontSize;
  int paddingTopBottom;
  int paddingLeftRight;
  bool disabled;

  DefaultButton(
      {Key? key,
      this.onPressed,
      required this.content,
      this.color = const Color(0xff000000),
      this.fontSize = 18,
      this.paddingTopBottom = 10,
      this.paddingLeftRight = 0,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: disabled
          ? null
          : () {
              if (onPressed != null) {
                onPressed!();
              }
            },
      style: disabled ? _disabledButton() : _enabledButton(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: paddingTopBottom.toDouble(),
            horizontal: paddingLeftRight.toDouble()),
        child: Text(
          content,
          style: TextStyle(
              color: disabled ? const Color(0xff999999) : color,
              fontSize: fontSize.toDouble(),
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  dynamic _enabledButton() {
    return OutlinedButton.styleFrom(
      elevation: 10,
      shadowColor: Colors.black,
      backgroundColor: const Color(0xffffffff),
      side: const BorderSide(width: 0, color: Colors.transparent),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }

  dynamic _disabledButton() {
    return OutlinedButton.styleFrom(
      elevation: 10,
      shadowColor: Colors.black,
      backgroundColor: const Color(0xffB3B3B3),
      side: const BorderSide(width: 0, color: Colors.transparent),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
