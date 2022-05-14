import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';

import '../model/piece_type.dart';
import '../model/player_type.dart';

/// 駒としての機能を表すインタフェース
abstract class IPiece extends PositionComponent {
  /// 次に移動できる場所のルートリスト
  /// PieceRouteが移動可能な１パターンです。
  PieceRoute get movableRoutes;

  /// 駒の種類
  PieceType get pieceType;

  /// 駒の種類の設定
  set pieceType(PieceType type);

  /// プレイヤーの種類
  PlayerType get playerType;
  set playerType(PlayerType playerType);
}
