import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/stories/utils.dart';

Future<void> main() async {
  final dashbook = Dashbook(
    theme: ThemeData.dark(),
    title: 'shogi flame example',
  );
  addStrories(dashbook);

  runApp(dashbook);
}
