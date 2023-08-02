import 'package:flutter/material.dart';
import 'package:musclatax/tools/helper.dart';

typedef Update = void Function(int index);

const Map<int, Color> weightColors = {
  // Multiple of 10 = green
  10: Color.fromARGB(255, 65, 145, 65),
  // Multiple of 20 = blue
  20: Color.fromARGB(255, 76, 162, 219),
  // Multiple of 25 = red
  25: Color.fromARGB(255, 219, 76, 76),
};

// ignore: must_be_immutable
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
            crossAxisCount: 5,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(100, (index) {
              double kg = (index + 1) * 2.5;
              // double lbs = kg.toDouble() * 2.205;

              Color colorForWeight = const Color.fromARGB(255, 56, 56, 56);
              weightColors.forEach((key, value) {
                if (kg % key == 0) {
                  colorForWeight = value;
                }
              });

              return GestureDetector(
                onTap: () {
                  onUpdate(index);
                },
                child: Container(
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      color: selectedWeight == index
                          ? UITools.mainItemBgColor
                          : colorForWeight,
                      shape: BoxShape.circle),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$kg kg',
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Text("(${lbs.floor()} lbs)",
                      //     style: const TextStyle(color: Colors.white))
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
