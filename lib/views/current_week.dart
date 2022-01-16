import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/models/access.dart';
import 'package:musclatax/models/train.dart';

class CurrentWeek extends StatefulWidget {
  const CurrentWeek({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CurrentWeekState();
}

class _CurrentWeekState extends State<CurrentWeek> {
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
    return Scaffold(
      body: Container(),
    );
  }
}
