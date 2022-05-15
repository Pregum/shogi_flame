import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/example/quiz_container.dart';

class QuizView extends StatefulWidget {
  const QuizView({Key? key}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: QuizContainer());
  }
}
