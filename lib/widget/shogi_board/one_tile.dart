import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
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

  // 表示する駒
  late IPiece _stackedPiece;
  // IPiece get stackedPiece => _stackedPiece;
  set stackedPiece(IPiece piece) {
    _stackedPiece = piece;
  }

  /// 選択されているか.
  /// trueの場合選択フラグを立てる
  bool isSelected = false;

  /// ctor
  OneTile(this.callback, this.topLeft, double s, Sprite spriteImage,
      {required IPiece stackedPiece, this.rowIndex, this.columnIndex})
      : super(sprite: spriteImage, size: Vector2.all(s)) {
    _stackedPiece = stackedPiece;
    x = topLeft.x;
    y = topLeft.y;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    callback?.call(this.topLeft, rowIndex, columnIndex);
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
