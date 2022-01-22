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

class PieceStand extends SpriteComponent {
  PieceStand(double size, Sprite sprite)
      : super(size: Vector2.all(size), sprite: sprite);
}

/// 9x9の将棋盤を描画するcomponent
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

    final OnTileTapDowned onTapDowned = (info) {
      print('ontapp!!!');
      selector.show = !selector.show;
      selector.position = info;
    };

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        final tileImage = await loadSprite(
          'tile.png',
        );

        final oneTile = OneTile(
            onTapDowned,
            Vector2(i * destTileSize, j * destTileSize),
            destTileSize,
            tileImage)
          ..anchor = Anchor.topLeft;
        add(oneTile);
      }
    }

    final selectorImage = await images.load('selector.png');
    add(selector = Selector(destTileSize, selectorImage));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

typedef OnTileTapDowned = void Function(Vector2 xy);

/// 将棋盤の1マスを描画するcomponent
class OneTile extends SpriteComponent with Tappable {
  /// tapdown時のcallback
  late OnTileTapDowned? callback;

  /// 左上の座標(xy)
  late Vector2 topLeft;

  /// ctor
  OneTile(this.callback, this.topLeft, double s, Sprite spriteImage)
      : super(sprite: spriteImage, size: Vector2.all(s)) {
    x = topLeft.x;
    y = topLeft.y;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    callback?.call(this.topLeft);
    return super.onTapDown(info);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

/// 選択マスを表すcomponent
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
