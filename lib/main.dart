import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

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

class SandBox extends FlameGame {
  SandBox();
}

/// 駒台
class PieceStand extends SpriteComponent {
  PieceStand(double size, Sprite sprite)
      : super(size: Vector2.all(size), sprite: sprite);
}

/// 9x9の将棋盤を描画するcomponent
class Tile9x9 extends FlameGame with HasTappables {
  /// 選択マスを表示するselector
  late Selector _selector;

  Tile9x9();

  static const _scale = 2.0;
  static const _srcTileSize = 32.0;
  static const _destTileSize = _scale * _srcTileSize;

  static const _rowCount = 9;
  static const _columnCount = 9;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await _prepare9x9Tile();

    await _prepareSelector();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  /// [Selector] の初期設定を行う
  Future<void> _prepareSelector() async {
    final selectorImage = await images.load('selector.png');
    add(_selector = Selector(_destTileSize, selectorImage));
  }

  /// 9x9の初期設定を行う
  Future<void> _prepare9x9Tile() async {
    final OnTileTapDowned onTapDowned = (info) {
      print('ontapp!!!');
      _selector.visible = !_selector.visible;
      _selector.position = info;
    };

    for (int i = 0; i < _rowCount; i++) {
      for (int j = 0; j < _columnCount; j++) {
        final tileImage = await loadSprite(
          'tile.png',
        );
        final oneTile = OneTile(
            onTapDowned,
            Vector2(i * _destTileSize, j * _destTileSize),
            _destTileSize,
            tileImage)
          ..anchor = Anchor.topLeft;
        add(oneTile);
      }
    }
  }
}

typedef OnTileTapDowned = void Function(Vector2 xy);

/// 将棋盤の1マスを描画するcomponent
class OneTile extends SpriteComponent with Tappable {
  /// tapdown時のcallback
  late OnTileTapDowned? callback;

  /// 左上の座標(xy)
  late Vector2 topLeft;

  // 表示する駒
  late Component? stackedPiece;

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
  /// 表示されているかどうか.
  /// trueに設定すると表示されます.
  bool visible = true;

  /// ctor
  Selector(double s, ui.Image img)
      : super(
          sprite: Sprite(img, srcSize: Vector2.all(32.0)),
          size: Vector2.all(s),
        );

  @override
  void render(Canvas canvas) {
    if (!visible) {
      return;
    }

    super.render(canvas);
  }
}
