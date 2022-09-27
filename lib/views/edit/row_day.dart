import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/model/custom/exercice.dart';
import 'package:musclatax/model/model.dart';
import 'package:flutter/foundation.dart';

typedef AsyncCallback = Future<void> Function();

class RowDay extends StatelessWidget {
  Exercice exercice;
  VoidCallback update;
  bool modify;

  RowDay(
      {Key? key,
      required this.exercice,
      required this.update,
      this.modify = false})
      : super(key: key);

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
        children: !modify
            ? []
            : [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciceAdd(exercice)));
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.green,
                  iconSize: 28,
                ),
                IconButton(
                  onPressed: () {
                    Performed()
                        .select()
                        .exercice
                        .equals(exercice.id)
                        .delete()
                        .then((value) {
                      Exercice()
                          .select()
                          .id
                          .equals(exercice.id)
                          .delete()
                          .then((value) {
                        update();
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                  color: Colors.red,
                  iconSize: 28,
                )
              ],
      )
    ]));
  }
}
