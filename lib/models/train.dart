import 'package:flutter/widgets.dart';

/// Package permettant de manipuler les types de données
/// liés a l'entrainement sportif de l'application

enum SegmentType { AMRAP, FORTIME, EMOM, TABATA, REST }

class ExerciceType {}

class ExerciceData {
  int weightTotal = 10;
  bool weightX2 = false;
  int repetition = 3;
  bool eachSide = false;

  ExerciceData(this.weightTotal, this.weightX2, this.repetition, this.eachSide);

  ExerciceData.fromSerial(String serial) {
    List<String> data = serial.split(",");
    weightTotal = int.parse(data[0]);
    weightX2 = data[1] == "true" ? true : false;
    repetition = int.parse(data[2]);
    eachSide = data[3] == "true" ? true : false;
  }

  String serial() {
    return "$weightTotal,$weightX2,$repetition,$eachSide";
  }
}

class Segment {
  int id;
  int duration = 5;
  List<int> data = [];
  SegmentType type = SegmentType.AMRAP;
  Map<int, ExerciceData> exercices = {};

  Segment(this.id, this.duration, this.type, this.exercices, this.data);

  Segment.fromSerial(Map<String, dynamic> data) : id = 0 {
    id = data["id"];
    duration = data["duration"];
    type = SegmentType.values[data["type"]];

    String ex = data["exercices"];
    for (var exercice in ex.split(";")) {
      List<String> vals = exercice.split("!");
      int exerciceId = int.parse(vals[0]);
      ExerciceData values = ExerciceData.fromSerial(vals[1]);
      exercices[exerciceId] = values;
    }
  }

  Map<String, dynamic> toMap() {
    String exos = exercices.entries
        .map((e) => e.key.toString() + "!" + e.value.serial())
        .join(";");
    return {
      'id': id,
      'duration': duration,
      'data': data.join(','),
      'type': type.index,
      'exercices': exos
    };
  }
}

class Session {


  static Widget widget(Session extracted) {
    return SizedBox(
      height: 50,
      child: Center(child: Text("Session ${extracted.id}"),),
    );
  }

  int id;
  DateTime dateTime;
  List<Segment> sessions = [];

  Session(this.id, this.dateTime);

  Session.fromSerial(Map<String, dynamic> data)
      : id = 0,
        dateTime = DateTime.now() {
    id = data["id"];
    dateTime = data["dateTime"];
    sessions = [];
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "dateTime": dateTime.millisecondsSinceEpoch};
  }

}

class Week {
  static Widget widget(Week week) {
    return SizedBox(
      height: 50,
      child: Center(child: Text('Semaine ${week.dateTime}')),
    );
  }

  int id;
  DateTime dateTime;
  List<Session> sessions = [];

  Week(this.id, this.dateTime);

  Week.fromSerial(Map<String, dynamic> data)
      : id = 0,
        dateTime = DateTime.now() {
    id = data["id"];
    dateTime = data["dateTime"];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'dateTime': dateTime.millisecondsSinceEpoch};
  }
}
