// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:musclatax/main.dart';

void main() {
  test("String immuability", () {
    String s = "test issou";
    String s2 = s.substring(2, 4);
    expect(s2, "st");
    expect(s, "test issou");
  });
}
