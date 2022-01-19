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
          onPressed!();
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
