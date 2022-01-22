import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/selector.dart';

import 'one_tile.dart';

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
