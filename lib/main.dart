import 'package:dashbook/dashbook.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/stories/utils.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dashbook = Dashbook(
    theme: ThemeData.dark(),
    title: 'shogi flame example',
  );
  addStrories(dashbook);

  runApp(dashbook);
}
