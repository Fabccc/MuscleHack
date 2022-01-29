import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:musclatax/components/title.dart';
import 'package:musclatax/components/utils.dart';

/// Package permettant de manipuler les types de données
/// liés a l'entrainement sportif de l'application

enum SegmentType { AMRAP, FORTIME, EMOM, TABATA, REST }

extension SegmentTypeDescription on SegmentType {
  String get desc {
    return [
      "AMRAP : As Many Round As Possible, faire le plus de round possible pendant un temps définit",
      "FOR TIME : Un contre la montre, aller le plus vite possible sur un enchainement d'exercice, souvent avant un temps imparti",
      "EMOM : Each One In A Minute, faire l'exercice pendant X minutes, puis à la fin, on change d'exercice, et on continue ainsi pendant Y minutes",
      "TABATA : Travail en fractionné, X secondes d'exercice, Y secondes de repos",
      "REST : entrainement classique, on effectue les exercices en question, puis on prend X minutes de repos"
    ][index];
  }
}

extension SegmentFormProvider on SegmentType {}

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
  static Widget widget(Session session, Segment segment) {
    return SizedBox(
      height: 50,
      child: Center(
          child:
              StandarText(text: "Bloc ${session.sessions.indexOf(segment)}")),
    );
  }

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
      child: Center(
        child: StandarText(
          fontSize: 20,
          text: extracted.toString(),
        ),
      ),
    );
  }

  int id;
  DateTime dateTime;
  bool done = false;
  List<Segment> sessions = [];

  Session(this.id, this.dateTime);

  Session.fromSerial(Map<String, dynamic> data)
      : id = 0,
        dateTime = DateTime.now() {
    id = data["id"];
    dateTime = DateTime.fromMillisecondsSinceEpoch(data["dateTime"]);
    sessions = [];
    done = data["done"] == 1 ? true : false;
  }

  @override
  String toString() {
    return "Session du " + DateFormat("EEEEE", "fr_FR").format(dateTime);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "done": done ? 1 : 0
    };
  }
}

class Week {
  static final DateFormat format = DateFormat("yyyy", "fr_FR");

  static Widget widget(Week week) {
    return SizedBox(
      height: 50,
      child: Center(child: StandarText(text: week.toString())),
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
    dateTime = DateTime.fromMillisecondsSinceEpoch(data["dateTime"]);
  }

  @override
  String toString() {
    return "Semaine ${DateUtils.weekNumber(dateTime)} de ${format.format(dateTime)}";
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'dateTime': dateTime.millisecondsSinceEpoch};
  }
}
