import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musclatax/models/access.dart';
import 'package:musclatax/models/train.dart';
import 'package:musclatax/views/week.dart';

class WeekList extends StatefulWidget {


  const WeekList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeekListState();
}

class _WeekListState extends State<WeekList> {
  List<Week> weeks = [];

  @override
  void initState() {
    super.initState();
    _initAsyncState();
  }

  void _initAsyncState() async {
    var _weeks = await _fetchData();
    setState(() {
      weeks = _weeks;
    });
  }

  Future<List<Week>> _fetchData() async {
    return await DBAccess.getWeeks();
  }

  @override
  Widget build(BuildContext context) {
    var _weeks = weeks;

    return Scaffold(
        body: Row(
      children: [
        const Text("Semaines"),
        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: _weeks.length,
          itemBuilder: (BuildContext context, int index) {
            Week extracted = _weeks[index];
            return InkWell(
              child: Week.widget(extracted),
              onTap: () {
                // Launch the week view
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => WeekDisplay(week: extracted)));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ],
    ));
  }
}
