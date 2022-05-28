import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';

import '../model/piece_type.dart';
import '../model/player_type.dart';
import '../util/piece_factory.dart';

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

extension IPieceEx on IPiece {
  Future<IPiece> cleanState() async {
    final reversedPieceType = pieceType.reversePieceType;
    final newPiece = await PieceFactory.createSpritePiece(
        reversedPieceType, this.size.x,
        playerType: PlayerType.Black);
    return newPiece!;
  }

  Future<IPiece?> clone() async {
    final replicaPiece = await PieceFactory.createSpritePiece(pieceType, size.x,
        playerType: playerType);
    return replicaPiece;
  }

  void reversePieceDirection() {
    // this.y -= size.y;
    this.flipHorizontallyAroundCenter();
  }
}
