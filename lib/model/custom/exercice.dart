import 'package:flutter/cupertino.dart';
import 'package:musclatax/components/utils.dart' as uu;

import '../model.dart';

class ExerciceListWidget extends StatelessWidget {
  Exercice exercice;

  ExerciceListWidget({Key? key, required this.exercice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = exercice.name ?? "??";
    int repos = exercice.rest ?? 120;
    int reps = exercice.reps ?? 8;
    int series = exercice.series ?? 4;

    String formatRepos = uu.DateUtils.formatSecond(repos);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          textAlign: TextAlign.left,
        ),
        Text(
          "$series série de $reps reps avec $formatRepos de repos",
          textAlign: TextAlign.left,
          style: const TextStyle(fontStyle: FontStyle.italic),
        )
      ],
    );
  }
}
