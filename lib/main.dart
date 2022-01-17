import 'package:flutter/material.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/views/weeks.dart';

void main() {
  runApp(const Musclatax());
}

class Musclatax extends StatelessWidget {
  const Musclatax({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: const Color(0xff48acfc)),
      home: const MusclataxMainMenu(),
    );
  }
}

class MusclataxMainMenu extends StatelessWidget {
  const MusclataxMainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double topbottom = 200;
    const double leftright = 30;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(
            top: topbottom,
            bottom: topbottom,
            left: leftright,
            right: leftright),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MenuButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WeekList()))
                    },
                content: "Liste semaines"),
            const MenuButton(content: "Statistiques")
          ],
        ),
      ),
    );
  }
}
