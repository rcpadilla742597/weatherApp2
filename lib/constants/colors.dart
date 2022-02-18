import 'package:flutter/material.dart';

@immutable
class MyColors {
  final white = const Color(0xFFFFFFFF);
  final black = const Color(0xFF000000);
  final mainBlue = const Color(0xff003A6B);
  final mediumBlue = const Color(0xff67CFF8);
  final lightBlue = const Color(0xFF0288D1);
  final grey = const Color(0xFF414141);
  final customRed = const Color(0xFFFF7979);
  final lightGrey = const Color(0xFFABABAB);

  const MyColors();
}

final cList1 = const [Colors.yellow, Colors.red];
final cList2 = const [Colors.lightBlue, Colors.blueGrey];
