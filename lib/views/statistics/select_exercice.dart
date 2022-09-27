import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/components/title.dart';
import 'package:musclatax/model/model.dart';
import 'package:musclatax/components/utils.dart' as uu;
import 'package:musclatax/tools/helper.dart';
import 'package:musclatax/views/statistics/exercice_stats.dart';

class SelectExercice extends StatefulWidget {
  const SelectExercice({super.key});

  @override
  State<StatefulWidget> createState() => _SelectExercice();
}

class _SelectExercice extends State<SelectExercice> {
  static const List<int> dayOfWeek = [1, 2, 3, 4, 5, 6, 7];

  List<Exercice> _exercices = [];
  int _isOpen = -1;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() async {
    var sessions = await _fetchData();
    setState(() {
      _exercices = sessions;
    });
  }

  Future<List<Exercice>> _fetchData() async {
    return Exercice().select().toList();
  }

  @override
  Widget build(BuildContext context) {
    var acordion = groupBy(_exercices, (Exercice ex) => ex.day ?? 1)
        .map((key, value) => MapEntry(
            key,
            ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: _isOpen == key,
                headerBuilder: ((context, isExpanded) {
                  return HeaderText(
                    text: uu.DateUtils.dayName(key),
                    paddingLeft: 15,
                    paddingTop: 10,
                    fontSize: 20,
                  );
                }),
                body: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    thickness: 1,
                  ),
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    var exercice = value[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ExerciceStat(exercice: exercice)));
                      },
                      child: Center(
                        child: Text(
                          exercice.name ?? "",
                          style: TextStyle(
                              color: UITools.mainBgColor, fontSize: 14),
                        ),
                      ),
                    );
                  }),
                  itemCount: value.length,
                ))))
        .entries
        .sorted((a, b) => a.key - b.key)
        .map((e) => e.value)
        .toList();
    return Scaffold(
        backgroundColor: const Color(0xffe0e0e0),
        body: DefaultContainer(
            topbottom: 50,
            child: Column(
              children: [
                ExpansionPanelList(
                  children: acordion,
                  expansionCallback: (i, isOpen) => setState(() {
                    debugPrint(_isOpen.toString());
                    _isOpen = (i + 1) == _isOpen ? -1 : (i + 1);
                  }),
                )
              ],
            )));
  }
}
