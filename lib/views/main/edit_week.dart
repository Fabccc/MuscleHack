import 'package:flutter/material.dart';
import 'package:musclatax/views/generic/select_day.dart';

import '../edit/edit_day.dart';

class EditWeek extends StatelessWidget {
  static const List<int> dayOfWeek = [1, 2, 3, 4, 5, 6, 7];

  const EditWeek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectDay(callback: (context, day) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EditDay(dayOfWeek: day);
      }));
    });
  }
}
