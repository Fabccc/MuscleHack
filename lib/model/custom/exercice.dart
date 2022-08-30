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
    int reps = exercice.reps ?? 4;

    String formatRepos = uu.DateUtils.formatSecond(repos);

    return Column(
      children: [Text(name), Text("Série: $reps, Repos: $formatRepos")],
    );
  }
}
