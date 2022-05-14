import 'move_state_type.dart';
import 'player_type.dart';

/// 駒の移動ルートを表すクラス
///
class PieceRoute {
  /// 移動方向のリスト
  ///
  /// 0要素目から順番に入っています。
  ///
  final List<List<MoveStateType>> routeMatrix;

  /// １辺の長さです。
  ///
  /// confition:
  ///
  ///   * 1 < [widthTileLnegth] <= 9
  ///   * [widthTileLnegth] % 2 == 1
  final int widthTileLnegth;

  /// ctor
  PieceRoute(this.routeMatrix, this.widthTileLnegth);

  /// playerを入れ替えた[PieceRoute]を返します。
  PieceRoute reversedPieceRoute() {
    final reversedMatrix = routeMatrix.reversed.toList();
    final pr = PieceRoute(reversedMatrix, widthTileLnegth);
    return pr;
  }
}

extension PieceRouteEx on PieceRoute {
  PieceRoute consideredPieceRoute(PlayerType playerType) {
    if (playerType.isBlack) {
      return this;
    } else {
      return this.reversedPieceRoute();
    }
  }
}
