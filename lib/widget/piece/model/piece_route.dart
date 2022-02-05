/// 駒の移動ルートを表すクラス
///
class PieceRoute {
  /// 移動方向のリスト
  /// 0要素目から順番に入っている
  final List<MovingDirection> route;

  /// 移動限界距離
  final int limitDistance;

  /// ctor
  PieceRoute(this.route, this.limitDistance);
}

/// 移動方向
enum MovingDirection {
  /// 不明
  Unknown,

  /// 左上
  LeftUp,

  /// 上方向
  Up,

  /// 右上
  RightUp,

  /// 左方向
  Left,

  /// 右方向
  Right,

  /// 左下
  LeftDown,

  /// 下方向
  Down,

  /// 右下
  RightDown,

  /// 桂馬の右上
  RightJump,

  /// 桂馬の左上
  LeftJump
}
