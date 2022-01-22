import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flutter/material.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';

import 'dart:ui' as ui;

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

/// 駒台
class PieceStand extends SpriteComponent {
  PieceStand(double size, Sprite sprite)
      : super(size: Vector2.all(size), sprite: sprite);
}
