import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

class SandboxView extends StatefulWidget {
  const SandboxView({Key? key}) : super(key: key);

  @override
  _SandboxViewState createState() => _SandboxViewState();
}

class _SandboxViewState extends State<SandboxView> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: Tile9x9());
  }
}
