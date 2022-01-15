enum SegmentType { AMRAP, FORTIME, EMOM, TABATA, REST }

class ExerciceData {
  int weightTotal = 10;
  bool weightX2 = false;
  int repetition = 3;
  bool eachSide = false;

  ExerciceData(this.weightTotal, this.weightX2, this.repetition, this.eachSide);
}

class Segment {
  int duration = 5;
  List<int> data = [];
  SegmentType type = SegmentType.AMRAP;
  Map<int, ExerciceData> exercices = {};

  Segment(this.duration, this.type, this.exercices, this.data);
}

class Week {
  Map<Segment, bool> sessions = {};
}
