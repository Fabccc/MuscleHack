import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/components/container.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:musclatax/views/main/edit_week.dart';
import 'package:musclatax/views/main/launch_week.dart';

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
      backgroundColor: const Color(0xffe0e0e0),
      body: DefaultContainer(
        topbottom: 200,
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            NeumophirsmButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditWeek()))
              },
              content: "Editer les semaines",
              colorDifference: 0.10,
            ),
            NeumophirsmButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LaunchWeek()))
              },
              content: "Lancer une séance",
              colorDifference: 0.10,
            ),
            NeumophirsmButton(
              content: "Statistiques",
              colorDifference: 0.10,
            )
          ],
        ),
      ),
    );
  }
}
