import 'package:flutter/material.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/components/title.dart';
import 'package:musclatax/components/utils.dart' as uu;
import 'package:musclatax/model/model.dart';
import 'package:musclatax/tools/helper.dart';
import 'package:musclatax/views/edit/row_day.dart';
import 'package:musclatax/views/seance/seance_running.dart';

class LaunchWeek extends StatelessWidget {
  int currentDay;
  List<Exercice> exercices;

  LaunchWeek({Key? key, required this.exercices, required this.currentDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dayFormatted = uu.DateUtils.dayName(currentDay);

    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      body: DefaultContainer(
        topbottom: 100,
        child: Column(children: [
          HeaderText(
            text: "Séance du $dayFormatted",
            fontSize: 28,
          ),
          exercices.isEmpty
              ? const Text(
                  "Pas d'exercice aujourd'hui ! Repos 😎🍹",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )
              : Flexible(
                  child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            thickness: 1,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        Exercice extracted = exercices[index];
                        return RowDay(
                          exercice: extracted,
                          update: () {},
                          modify: false,
                        );
                      },
                      itemCount: exercices.length))
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            // On démarre le service
            await SeanceIsolate.initializeService();
            // On lance la vue
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SeanceRunning(
                          exercices: exercices,
                        )));
            // Quand on revient derrière on stop le service
            await SeanceIsolate.stop();
          },
          label: const Text("LANCER"),
          backgroundColor: UITools.mainBgColor,
          icon: const Icon(
            Icons.play_arrow,
            color: Colors.white,
          )),
    );
  }
}
