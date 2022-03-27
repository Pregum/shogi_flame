import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';

/// タップしたマスの左上のxy座標が [Vector2] から与えられる.
/// タップ箇所のマスのindexを **rowIndex** と **columnIndex** から与えられる.
typedef OnTileTapDowned = void Function(
    Vector2 xy, int? rowIndex, int? columnIndex);

/// 将棋盤の1マスを描画するcomponent
class OneTile extends SpriteComponent with Tappable {
  /// tapdown時のcallback
  OnTileTapDowned? callback;

  /// 左上の座標(xy)
  Vector2 topLeft;

  /// 行のindex
  int? rowIndex;

  /// 列のindex
  int? columnIndex;

  // 表示する駒のバッキングフィールドです。
  late IPiece _stackedPiece;
  // 表示する駒へアクセスするプロパティです。
  IPiece get stackedPiece => _stackedPiece;
  // 表示する駒を設定するプロパティです。
  set stackedPiece(IPiece piece) {
    final oldPiece = _stackedPiece;
    _stackedPiece = piece;
    remove(oldPiece);
    add(_stackedPiece);
  }

  /// 選択されているか.
  /// trueの場合選択フラグを立てる
  bool isSelected = false;

  /// 移動できるタイル描画用Component
  late PositionComponent _movableTile;

  bool _isVisibleMovableTile = false;
  set isVisibleMovableTile(bool newValue) => _isVisibleMovableTile = newValue;

  /// ctor
  OneTile(this.callback, this.topLeft, double s, Sprite spriteImage,
      {required IPiece stackedPiece, this.rowIndex, this.columnIndex})
      : super(sprite: spriteImage, size: Vector2.all(s)) {
    _stackedPiece = stackedPiece;
    x = topLeft.x;
    y = topLeft.y;

    _movableTile = PositionComponent(
      size: Vector2.all(s),
      anchor: Anchor.topLeft,
    );
    add(_movableTile);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    callback?.call(this.topLeft, rowIndex, columnIndex);
    isSelected = !isSelected;

    // 子供に伝播させるフラグを返す
    // true: 伝播させる, false: 伝播させない
    // ref: https://docs.flame-engine.org/1.0.0/gesture-input.html?highlight=tappable#tappable-draggable-and-hoverable-components
    return false;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _stackedPiece.render(canvas);

    if (_isVisibleMovableTile) {
      final opacityPaint = Paint()..color = Colors.blue.withOpacity(0.6);
      canvas.drawRect(_movableTile.toRect(), opacityPaint);
    }
  }
}
