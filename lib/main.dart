import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/views/weeks.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("fr_FR", null);
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
    return Scaffold(
      body: DefaultContainer(
        topbottom: 200,
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
