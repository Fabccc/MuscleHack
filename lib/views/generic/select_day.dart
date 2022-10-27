import 'package:flutter/material.dart';
import 'package:musclatax/components/utils.dart' as uu;

import '../../components/button.dart';
import '../../components/container.dart';

typedef SelectDayCallback = void Function(
    BuildContext context, int day);

class SelectDay extends StatelessWidget {
  static const List<int> dayOfWeek = [1, 2, 3, 4, 5, 6, 7];

  SelectDayCallback callback;

  SelectDay({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe0e0e0),
        body: DefaultContainer(
            topbottom: 50,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: dayOfWeek
                  .map((day) => WhiteNeumorphismButton(
                        onPressed: () async {
                          callback(context, day);
                        },
                        content: uu.DateUtils.dayName(day),
                        colorDifference: 0.05,
                        vertical: 0,
                        horizontal: 0,
                      ))
                  .toList(),
            )));
  }
}
