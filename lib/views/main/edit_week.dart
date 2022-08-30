import 'package:flutter/material.dart';
import 'package:musclatax/components/utils.dart' as uu;

import '../../components/button.dart';
import '../../components/container.dart';
import '../edit/edit_day.dart';

class EditWeek extends StatelessWidget {
  static const List<int> dayOfWeek = [1, 2, 3, 4, 5, 6, 7];

  const EditWeek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe0e0e0),
        body: DefaultContainer(
            topbottom: 50,
            child: GridView.count(
              crossAxisCount: 2,
              children: dayOfWeek
                  .map((day) => NeumophirsmButton(
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditDay(
                                        dayOfWeek: day,
                                      )))
                        },
                        content: uu.DateUtils.dayName(day),
                        colorDifference: 0.05,
                      ))
                  .toList(),
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            )));
  }
}
