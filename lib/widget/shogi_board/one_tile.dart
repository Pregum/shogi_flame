import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/shogi_board/movable_tile.dart';

import '../piece/model/player_type.dart';

/// タップしたマスの左上のxy座標が [Vector2] から与えられる.
/// タップ箇所のマスのindexを **rowIndex** と **columnIndex** から与えられる.
typedef OnTileTapDown = void Function(
    Vector2 xy, int? rowIndex, int? columnIndex, bool isDoubleTap);

class TapStatus {
  final bool isTap;
  double? dt;
  TapStatus(this.isTap, this.dt);
}

/// 将棋盤の1マスを描画するcomponent
class OneTile extends SpriteComponent with Tappable {
  /// tapdown時のcallback
  OnTileTapDown? callback;

  /// 左上の座標(xy)
  Vector2 topLeft;

  /// 行のindex
  int? rowIndex;

  /// 列のindex
  int? columnIndex;

  /// 前の更新時にタップされていたかどうかの判定フラグ
  bool hadTap = false;

  /// ダブルタップで使用される一時保存用フィールド
  bool? currentTap;

  /// ダブルタップの1回目と2回目の間隔を計るタイマー
  var countDown = Timer(0.3);

  // 表示する駒のバッキングフィールドです。
  late IPiece _stackedPiece;
  // 表示する駒へアクセスするプロパティです。
  IPiece get stackedPiece => _stackedPiece;
  // 表示する駒を設定するプロパティです。
  set stackedPiece(IPiece piece) {
    final oldPiece = _stackedPiece;
    _stackedPiece = piece;
    oldPiece.removeFromParent();
    // if (piece.playerType == PlayerType.White) {
    //   piece.flipVerticallyAroundCenter();
    // }
    add(_stackedPiece);
  }

  /// 選択されているか.
  /// trueの場合選択フラグを立てる
  bool isSelected = false;

  /// 移動できるタイル描画用Component
  late MovableTile _movableTile;

  bool _isMovableTile = false;
  bool get isMovableTile => _isMovableTile;
  set isMovableTile(bool newValue) {
    _isMovableTile = newValue;
    _movableTile.isVisible = newValue;
  }

  /// ctor
  OneTile(this.callback, this.topLeft, double s, Sprite spriteImage,
      {required IPiece stackedPiece, this.rowIndex, this.columnIndex})
      : super(sprite: spriteImage, size: Vector2.all(s)) {
    _stackedPiece = stackedPiece;
    x = topLeft.x;
    y = topLeft.y;
  }

  factory OneTile.fromPiece(
      OnTileTapDown callback, Vector2 topLeft, IPiece piece) {
    final sprite = (piece as SpriteComponent).sprite;
    final tile =
        OneTile(callback, topLeft, piece.size.x, sprite!, stackedPiece: piece);
    return tile;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    isSelected = !isSelected;

    var isDoubleTap = false;
    if (hadTap) {
      isDoubleTap = true;
    }

    countDown = Timer(0.3);
    currentTap = isSelected;

    callback?.call(this.topLeft, rowIndex, columnIndex, isDoubleTap);

    // 子供に伝播させるフラグを返す
    // true: 伝播させる, false: 伝播させない
    // ref: https://docs.flame-engine.org/1.0.0/gesture-input.html?highlight=tappable#tappable-draggable-and-hoverable-components
    return false;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    _movableTile = MovableTile(
      size.x,
      await Sprite.load('movable_tile_sprite.png'),
    )..add(
        OpacityEffect.fadeOut(
          EffectController(
            duration: 1.5,
            reverseDuration: 1.5,
            infinite: true,
          ),
        ),
      );
    add(_movableTile);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updateDoubleTapStatus(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_isMovableTile) {
      final opacityPaint = Paint()..color = Colors.blue.withOpacity(0.6);
      canvas.drawRect(_movableTile.toRect(), opacityPaint);
    }
  }

  void _updateDoubleTapStatus(double dt) {
    var ct = currentTap;
    if (ct != null) {
      hadTap = ct;
      currentTap = null;
    }
    countDown.update(dt);
    if (countDown.finished) {
      hadTap = false;
    }
  }
}
