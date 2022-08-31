import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/components/utils.dart';

// ignore: must_be_immutable
const double distance = 25;

class WhiteNeumorphismButton extends NeumophirsmButton {
  WhiteNeumorphismButton(
      {Key? key,
      required String content,
      super.onPressed,
      super.colorDifference,
      super.disabled,
      super.fontSize})
      : super(key: key, content: content, boxShadows: [
//         border-radius: 50px;
// background: #e0e0e0;
// box-shadow:  31px 31px 62px #bebebe,
//              -31px -31px 62px #ffffff;
          !disabled
              ? const BoxShadow(
                  color: Color(0xbebebeFF),
                  offset: Offset(distance, distance),
                  blurRadius: 62,
                )
              : const BoxShadow(
                  color: Color.fromARGB(189, 181, 181, 181),
                  offset: Offset(distance, distance),
                  blurRadius: 62,
                ),
          const BoxShadow(
            color: Color(0xFFFFFFFF),
            offset: Offset(-distance, -distance),
            blurRadius: 62,
          )
        ]);
}

// ignore: must_be_immutable
class NeumophirsmButton extends StatelessWidget {
  static const double difference = 0.15;
  static const double borderRadius = 30;

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
  List<BoxShadow> boxShadows;

  NeumophirsmButton(
      {Key? key,
      required this.content,
      this.onPressed,
      this.horizontal = 5,
      this.vertical = 15,
      this.backgroundColor = const Color(0xFFF1F1F1),
      this.color = const Color(0xff48acfc),
      this.colorDifference = 0.15,
      this.minWidth = 88,
      this.fontSize = 18,
      this.disabled = false,
      this.boxShadows = const []})
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

// Card(
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),

  @override
  Widget build(BuildContext context) {
    ButtonStyle bStyle = disabled ? _disabledButton() : _enabledButton();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: TextButton(
        style: bStyle,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: disabled ? const Color(0xff999999) : color,
                  fontSize: fontSize,
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.normal)),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadows.length > 0
              ? boxShadows
              : calcShadow(
                  disabled ? const Color(0xffB3B3B3) : backgroundColor, 10, 7,
                  intensity: colorDifference)),
    );
  }

  ButtonStyle _enabledButton() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(width: 0, color: Colors.transparent)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))));
  }

  ButtonStyle _disabledButton() {
    return OutlinedButton.styleFrom(
        shadowColor: Colors.black,
        backgroundColor: const Color(0xffB3B3B3),
        side: const BorderSide(width: 0, color: Colors.transparent),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)));
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
