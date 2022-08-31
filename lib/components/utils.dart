import 'dart:ui';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DateUtils {
  static const Map<int, String> _dayName = {
    1: "Lundi",
    2: "Mardi",
    3: "Mercredi",
    4: "Jeudi",
    5: "Vendredi",
    6: "Samedi",
    7: "Dimanche"
  };

  static String formatSecond(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static int dayNumber() {
    return DateTime.now().weekday;
  }

  static String dayName(int weekday) {
    return _dayName[weekday] ?? "monday";
  }

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

class ColorUtils {
  static Color colorLuminance(Color color, double lum) {
    double r, g, b;
    r = color.red.toDouble();
    g = color.green.toDouble();
    b = color.blue.toDouble();

    r = min(max(0, r + r * lum), 255);
    g = min(max(0, g + g * lum), 255);
    b = min(max(0, b + b * lum), 255);

    return Color.fromARGB(color.alpha, r.round(), g.round(), b.round());
  }

  /// Retourne une couleur avec la luminosité changé
  ///
  /// Permet le calcul d'une nouvelle couleur en fonction de
  /// son point d'origine [color] ainsi qu'un pourcentage de luminosité
  /// [lum] (si [lum] ``< 0`` alors on baissera la luminosité)
  ///
  /// Fonction prise du site [neumorphism css](https://neumorphism.io/)
  @Deprecated("fonction lente car utilise des strings")
  static Color colorLuminanceTweaked(Color color, double lum) {
    // validate hex string
    String hex = color.toHex().replaceAll("#", '');
    if (hex.length < 6) {
      hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }

    // convert to decimal and change luminosity
    String rgb = '#';
    int tempInt;
    String tempString;
    for (int i = 0; i < 3; i++) {
      tempInt = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
      tempString =
          min(max(0, tempInt + tempInt * lum), 255).round().toRadixString(16);
      rgb += ('00' + tempString).substring(tempString.length);
    }

    return HexColor.fromHex(rgb);
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class MathUtils {
  static double map(
      double val, double iMin, double iMax, double oMin, double oMax) {
    return (val - iMin) * (oMax - oMin) / (iMax - iMin) + oMin;
  }
}
