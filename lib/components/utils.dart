import 'package:intl/intl.dart';

class DateUtils {
  static int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static DateTime startOfWeek() {
    return startOfWeekDate(DateTime.now());
  }

  static DateTime startOfWeekDate(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }
}
