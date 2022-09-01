import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "package:musclatax/components/utils.dart" as uu;
import 'package:musclatax/tools/helper.dart';

typedef Update = void Function(int index);

class WeightList extends StatelessWidget {
  int selectedWeight;
  Update onUpdate;

  WeightList({super.key, required this.selectedWeight, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 4,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(40, (index) {
              int kg = (index + 1) * 5;
              double lbs = kg.toDouble() * 2.205;

              return GestureDetector(
                onTap: () {
                  onUpdate(index);
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: selectedWeight == index
                          ? UITools.mainBgColor
                          : const Color.fromARGB(255, 56, 56, 56),
                      shape: BoxShape.circle),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$kg kg',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text("(${lbs.floor()} lbs)",
                          style: const TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
