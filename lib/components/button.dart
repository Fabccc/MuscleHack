import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/components/utils.dart';

class NeumophirsmButton extends StatelessWidget {
  static const double difference = 0.15;

  final Function? onPressed;
  final String content;
  final double minWidth;
  int horizontal;
  int vertical;
  Color backgroundColor;
  Color color;
  double colorDifference;
  double fontSize;
  bool disabled;

  NeumophirsmButton(
      {Key? key,
      required this.content,
      this.onPressed,
      this.horizontal = 5,
      this.vertical = 15,
      this.backgroundColor = const Color(0xffe0e0e0),
      this.color = const Color(0xff48acfc),
      this.colorDifference = 0.15,
      this.minWidth = 88,
      this.fontSize = 18,
      this.disabled = false})
      : super(key: key);

  /*
  Neumorphic style: 
  border-radius: 50px;
  background: #e0e0e0;
  box-shadow:  dx    dy    blur  color
  box-shadow:  20px 20px 60px #bebebe,
              -20px -20px 60px #ffffff;*/

  List<BoxShadow> calcShadow(Color color, double blur, double distance,
      {intensity = difference}) {
    return [
      BoxShadow(
        color: ColorUtils.colorLuminance(color, intensity * -1),
        offset: Offset(distance, distance),
        blurRadius: blur,
      ),
      BoxShadow(
        color: ColorUtils.colorLuminance(color, intensity),
        offset: Offset(-distance, -distance),
        blurRadius: blur,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlinedButton(
        style: disabled ? _disabledButton() : _enabledButton(),
        onPressed: disabled
            ? null
            : () {
                if (onPressed != null) {
                  onPressed!();
                }
              },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: vertical.toDouble(), horizontal: horizontal.toDouble()),
          child: Text(content,
              style: TextStyle(
                  color: disabled ? const Color(0xff999999) : color,
                  fontSize: fontSize,
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.normal)),
        ),
      ),
      decoration: BoxDecoration(
          boxShadow: calcShadow(
              disabled ? const Color(0xffB3B3B3) : backgroundColor, 40, 20,
              intensity: colorDifference)),
    );
  }

  ButtonStyle _enabledButton() {
    return OutlinedButton.styleFrom(
        minimumSize: Size(minWidth, 36),
        backgroundColor: const Color(0xffffffff),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        side: const BorderSide(width: 0, color: Colors.transparent));
  }

  ButtonStyle _disabledButton() {
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
            side: const BorderSide(width: 0, color: Colors.transparent)),
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

  ButtonStyle _enabledButton() {
    return OutlinedButton.styleFrom(
      elevation: 10,
      shadowColor: Colors.black,
      backgroundColor: const Color(0xffffffff),
      side: const BorderSide(width: 0, color: Colors.transparent),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }

  ButtonStyle _disabledButton() {
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
