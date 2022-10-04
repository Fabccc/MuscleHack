import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/model/model.dart';
import 'package:musclatax/tools/helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class ExerciceStat extends StatefulWidget {
  final Exercice exercice;
  const ExerciceStat({super.key, required this.exercice});

  @override
  State<StatefulWidget> createState() =>
      _ExerciceStateState(exercice: exercice);
}

class _ExerciceStateState extends State<ExerciceStat> {
  static List<Color> LINE_COLORS = [
    Colors.red.shade500,
    Colors.blue.shade500,
    Colors.green.shade700,
    Colors.pink.shade600,
    Colors.orange.shade500
  ];
  Exercice exercice;
  List<Performed> _performed = [];

  _ExerciceStateState({required this.exercice});

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() async {
    var sessions = await _fetchData();
    setState(() {
      _performed = sessions;
    });
  }

  Future<List<Performed>> _fetchData() async {
    return Performed()
        .select()
        .exercice
        .equals(exercice.id)
        .orderBy(["date"])
        .top((exercice.series ?? 4) * 10)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_performed.toString());

    int maxWeight = _performed.map((e) => e.weight ?? 5).reduce(max) + 5;
    int minWeight = _performed.map((e) => e.weight ?? 5).reduce(min) - 5;

    var formatted =
        groupBy(_performed, (e) => e.seriesIndex ?? 0).entries.map((e) {
      int serie = e.key;
      var performeds = e.value;
      return LineSeries<Performed, DateTime>(
          dataSource: performeds,
          name: "Serie n°${serie + 1}",
          xValueMapper: (p, _) => p.date,
          yValueMapper: (p, _) => p.weight,
          color: LINE_COLORS[serie],
          markerSettings: MarkerSettings(
              isVisible: true,
              height: 4,
              width: 4,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: LINE_COLORS[serie]),
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside));
    }).toList();

    return Scaffold(
        backgroundColor: const Color(0xffe0e0e0),
        body: DefaultContainer(
            topbottom: 50,
            leftright: 10,
            child: Column(children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 5.0,
                    minWidth: 5.0,
                    maxHeight: 500,
                    maxWidth: 400,
                  ),
                  child: SfCartesianChart(
                      primaryYAxis: NumericAxis(
                          name: "Poids (kg)",
                          isVisible: true,
                          minimum: minWeight.toDouble(),
                          maximum: maxWeight.toDouble()),
                      legend: Legend(isVisible: true, isResponsive: true),
                      primaryXAxis:
                          DateTimeAxis(name: "Date séances", isVisible: true),
                      series: formatted),
                ),
              )
            ])));
  }
}