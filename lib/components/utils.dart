import 'dart:ui';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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

class ColorUtils {
  static Color colorLuminance(Color color, double lum) {
    return HSLColor.fromColor(color).withLightness(lum).toColor();
  }

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
