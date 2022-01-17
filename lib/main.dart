import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

Future<void> main() async {
  runApp(MaterialApp(
      home: Scaffold(
    body: GameWidget(
      game: IsometricMapGame(),
    ),
  )));
}

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GameWidget(game: IsometricMapGame()),
      ),
    );
  }
}

class IsometricMapGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await loadSprite('normal_shogi_tile.png');
    add(SpriteComponent(
      sprite: sprite,
      position: Vector2(size.x / 2, size.y / 2),
      size: sprite.srcSize * 2,
      anchor: Anchor.center,
    ));
  }
}

class Selector extends SpriteComponent {
  bool show = true;

  Selector(double s, ui.Image img)
      : super(
          sprite: Sprite(img, srcSize: Vector2.all(32.0)),
          size: Vector2.all(s),
        );
  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }

    super.render(canvas);
  }
}
