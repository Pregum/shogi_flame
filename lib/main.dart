import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: Tile9x9(),
        ),
      ),
    ),
  );
}
