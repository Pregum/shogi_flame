/// 駒の移動ルートを表すクラス
///
class PieceRoute {
  /// 移動方向のリスト
  ///
  /// 0要素目から順番に入っています。
  ///
  final List<List<MoveType>> routeMatrix;

  /// １辺の長さです。
  ///
  /// confition:
  ///
  ///   * 1 < [widthTileLnegth] <= 9
  ///   * [widthTileLnegth] % 2 == 1
  final int widthTileLnegth;

  /// ctor
  PieceRoute(this.routeMatrix, this.widthTileLnegth);
}

/// 移動の種類
enum MoveType {
  /// 不明(default値)
  Unknown,

  /// 移動不可
  UnMovable,

  /// 移動可能
  Movable,
}
