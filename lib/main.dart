import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/src/game/game_render_box.dart';
import 'package:flame/src/assets/images.dart';
import 'package:flame/src/assets/assets_cache.dart';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:flutter/src/rendering/object.dart';

Future<void> main() async {
  runApp(MaterialApp(
      home: Scaffold(
    body: GameWidget(
      // game: IsometricMapGame(),
      game: Tile9x9(),
    ),
  )));
}

// class HomeView extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeViewState();
//   }
// }

// class _HomeViewState extends State<HomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         // body: GameWidget(game: IsometricMapGame()),
//         body: GameWidget(game: Tile9x9()),
//       ),
//     );
//   }
// }

class IsometricMapGame extends FlameGame with MouseMovementDetector {
  static const scale = 2.0;
  static const srcTileSize = 32.0;
  static const destTileSize = scale * srcTileSize;

  late Selector selector;
  IsometricMapGame();
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

    final selectorImage = await images.load('selector.png');
    add(selector = Selector(destTileSize, selectorImage));
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenPosition = info.eventPosition.game;
    selector.position.setFrom(screenPosition);
  }
}

class Tile9x9 extends FlameGame with HasTappables {
  late Selector selector;

  Tile9x9();

  static const scale = 2.0;
  static const srcTileSize = 32.0;
  static const destTileSize = scale * srcTileSize;

  static const rowCount = 9;
  static const columnCount = 9;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final onTapDowned = () {
      print('ontapp!!!');
      selector.show = !selector.show;
    };

// これだと何も表示されなくなった
    for (int i = 0; i < rowCount; i++) {
      // for (int j = 0; j < columnCount; j++) {
      final tileImage = await loadSprite('tile.png',
          // srcPosition: Vector2.all(i * destTileSize),
          srcPosition: Vector2(i * 10, 10));

      final oneTile = OneTile(onTapDowned, destTileSize, tileImage);
      add(oneTile);
      // }
    }

    final selectorImage = await images.load('selector.png');
    add(selector = Selector(destTileSize, selectorImage));
  }
}

typedef OnTileTapDowned = void Function();

/// 将棋盤の1盤面を描画するcomponent
class OneTile extends SpriteComponent with Tappable {
  /// tapdown時のcallback
  late OnTileTapDowned? callback;

  /// ctor
  OneTile(this.callback, double s, Sprite spriteImage)
      : super(sprite: spriteImage, size: Vector2.all(s));

  @override
  bool onTapDown(TapDownInfo info) {
    callback?.call();
    return super.onTapDown(info);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
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
