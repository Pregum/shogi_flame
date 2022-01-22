import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flutter/material.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';

import 'dart:ui' as ui;

import 'widget/piece/model/piece_type.dart';
import 'widget/piece/util/piece_factory.dart';

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

    // 最初はブランクを入れておく
    final blankPiece = PieceFactory.createBlankPiece();

    for (int i = 0; i < _rowCount; i++) {
      for (int j = 0; j < _columnCount; j++) {
        final tileImage = await loadSprite(
          'tile.png',
        );
        final oneTile = OneTile(
            onTapDowned,
            Vector2(i * _destTileSize, j * _destTileSize),
            _destTileSize,
            tileImage,
            stackedPiece: blankPiece)
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
  late IPiece _stackedPiece;
  IPiece get stackedPiece => _stackedPiece;
  set stackedPiece(IPiece piece) {
    stackedPiece = piece;
  }

  /// 選択されているか.
  /// trueの場合選択フラグを立てる
  bool isSelected = false;

  /// ctor
  OneTile(this.callback, this.topLeft, double s, Sprite spriteImage,
      {required IPiece stackedPiece})
      : super(sprite: spriteImage, size: Vector2.all(s)) {
    _stackedPiece = stackedPiece;
    x = topLeft.x;
    y = topLeft.y;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    callback?.call(this.topLeft);
    isSelected = !isSelected;
    return super.onTapDown(info);
  }

  @override
  void render(Canvas canvas) {
    if (isSelected == false) {
      remove(_stackedPiece);
    } else {
      add(_stackedPiece);
    }
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
