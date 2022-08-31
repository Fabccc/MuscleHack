import 'package:flutter/material.dart';
import 'package:musclatax/components/title.dart';
import 'package:musclatax/components/utils.dart' as uu;
import 'package:musclatax/model/model.dart';
import 'package:musclatax/views/edit/row_day.dart';

import '../../components/button.dart';
import '../../components/container.dart';

class EditDay extends StatefulWidget {
  final int dayOfWeek;

  const EditDay({Key? key, required this.dayOfWeek}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _EditDayState(dayOfWeek: this.dayOfWeek);
}

class _EditDayState extends State<EditDay> {
  final int dayOfWeek;
  List<Exercice> data = [];

  _EditDayState({required this.dayOfWeek});

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() async {
    var _sessions = await _fetchData();
    setState(() {
      data = _sessions;
    });
  }

  Future<List<Exercice>> _fetchData() async {
    return Exercice().select().day.equals(dayOfWeek).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe0e0e0),
        body: DefaultContainer(
            topbottom: 150,
            leftright: 10,
            child: Column(
              children: [
                HeaderText(text: uu.DateUtils.dayName(dayOfWeek)),
                Flexible(
                    child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              thickness: 1,
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          Exercice extracted = data[index];
                          return RowDay(
                            exercice: extracted,
                            update: () {
                              _updateData();
                            },
                            modify: true,
                          );
                        },
                        itemCount: data.length))
              ],
            )),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 5,
          onPressed: () async {
            final value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ExerciceAdd(Exercice(day: dayOfWeek))));
            _updateData();
          },
        ));
  }
}
