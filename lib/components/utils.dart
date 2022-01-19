import 'package:intl/intl.dart';

class DateUtils {
  static int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static DateTime startOfWeek() {
    DateTime d = DateTime.now();
    return d.subtract(Duration(days: d.weekday - 1));
  }
}
