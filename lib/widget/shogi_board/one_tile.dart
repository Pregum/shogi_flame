import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';

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
