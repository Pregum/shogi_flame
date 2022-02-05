import 'package:shogi_game/widget/piece/interface/i_piece.dart';

import 'piece_position.dart';

/// 駒の移動を表すオブジェクト
class PieceMovement {
  /// 移動開始地点
  PiecePosition movingStartPosition;

  /// 移動終了地点
  PiecePosition movingEndPosition;

  /// 討ち取られた駒
  IPiece? killedPiece;

  /// ctor
  PieceMovement(
      this.movingStartPosition, this.movingEndPosition, this.killedPiece);

  /// 移動だけ時用のctor
  factory PieceMovement.movingOnly(
      PiecePosition movingStartPosition, PiecePosition movingEndPosition) {
    return PieceMovement(movingStartPosition, movingEndPosition, null);
  }
}
