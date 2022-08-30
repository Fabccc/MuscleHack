import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/model/custom/exercice.dart';
import 'package:musclatax/model/model.dart';

class RowDay extends StatelessWidget {
  Exercice exercice;

  RowDay({Key? key, required this.exercice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> state) {
      return Colors.green.shade400;
    }

    return InkWell(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ExerciceListWidget(exercice: exercice),
      Row(
        children: [
          IconButton(
            onPressed: () {
              Exercice().select().id.equals(exercice.id).delete();
            },
            icon: const Icon(
              Icons.delete,
            ),
            color: Colors.red,
            iconSize: 32,
          )
        ],
      )
    ]));
  }
}
