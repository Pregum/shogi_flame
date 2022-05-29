import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/example/score_attack_container.dart';

class ScoreAttackView extends StatefulWidget {
  const ScoreAttackView({Key? key}) : super(key: key);

  @override
  State<ScoreAttackView> createState() => _ScoreAttackViewState();
}

class _ScoreAttackViewState extends State<ScoreAttackView> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: ScoreAttackContainer());
  }
}
