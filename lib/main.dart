import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';

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
