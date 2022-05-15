import 'package:flutter/material.dart';
import 'package:shogi_game/example/quiz_view.dart';

import 'example/kifu_edit_view.dart';
import 'example/sandbox_view.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      home: Scaffold(
        // body: SandboxView(),
        // body: KifuEditView(),
        body: QuizView(),
      ),
    ),
  );
}
