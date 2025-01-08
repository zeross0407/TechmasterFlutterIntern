import 'package:flutter/material.dart';

class Word_data {
  final String text;
  bool hight_lighting;
  TextStyle? textStyle;
  final int length;
  final int start_index;

  Word_data(
      {required this.text,
      required this.hight_lighting,
      required this.length,
      this.textStyle,
      required this.start_index});
}

class Line_data {
  List<Word_data> words_data;
  final Color bouble_color;
  final bool speaker;
  int time_start;
  Line_data(
      {required this.speaker,
      required this.words_data,
      required this.bouble_color,
      required this.time_start});
}
