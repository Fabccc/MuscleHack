enum SegmentType { AMRAP, FORTIME, EMOM, TABATA, REST }

class ExerciceData {
  int weightTotal = 10;
  bool weightX2 = false;
  int repetition = 3;
  bool eachSide = false;

  ExerciceData(this.weightTotal, this.weightX2, this.repetition, this.eachSide);
}

class Segment {
  int id;
  int duration = 5;
  List<int> data = [];
  SegmentType type = SegmentType.AMRAP;
  Map<int, ExerciceData> exercices = {};

  Segment(this.id, this.duration, this.type, this.exercices, this.data);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'duration': duration,
      'data': data.join(','),
      'type': type.index
    };
  }
}

class Week {
  int id;
  DateTime dateTime;
  Map<Segment, bool> sessions = {};

  Week(this.id, this.dateTime);

  Map<String, dynamic> toMap() {
    return {'id': id, 'datetime': dateTime};
  }
}
