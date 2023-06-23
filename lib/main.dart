import 'package:flutter/material.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/components/container.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:musclatax/model/model.dart';
import 'package:musclatax/views/generic/select_day.dart';
import 'package:musclatax/views/main/edit_week.dart';
import 'package:musclatax/views/main/launch_week.dart';
import 'package:musclatax/views/statistics/select_exercice.dart';

Future<void> main() async {
  initializeDateFormatting("fr_FR", null);
  WidgetsFlutterBinding.ensureInitialized();
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
          physics: const NeverScrollableScrollPhysics(),
          children: [
            WhiteNeumorphismButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditWeek()))
              },
              content: "Editer la semaine",
              colorDifference: 0.10,
            ),
            WhiteNeumorphismButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectDay(callback: ((context, day) async {
                              List<Exercice> exercices = await Exercice()
                                  .select()
                                  .day
                                  .equals(day)
                                  .toList();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LaunchWeek(
                                    exercices: exercices, currentDay: day);
                              }));
                            }))));
              },
              content: "Lancer une séance",
              fontSize: 16,
              colorDifference: 0.10,
            ),
            WhiteNeumorphismButton(
              content: "Statistiques",
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectExercice()))
              },
              colorDifference: 0.10,
              fontSize: 15,
            )
          ],
        ),
      ),
    );
  }
}
