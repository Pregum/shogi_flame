import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';

import 'piece_position.dart';
import 'piece_type.dart';

/// 駒の移動を表すオブジェクト
class PieceMovement {
  List<List<PieceType>>? snapshot;

  /// 移動開始地点
  PiecePosition movingStartPosition;

  /// 移動終了地点
  PiecePosition movingEndPosition;

  /// 討ち取られた駒
  IPiece? killedPiece;

  /// ctor
  PieceMovement(
      this.movingStartPosition, this.movingEndPosition, this.killedPiece,
      {required List<List<PieceType>> this.snapshot});

  /// 移動だけ時用のctor
  factory PieceMovement.movingOnly(PiecePosition movingStartPosition,
      PiecePosition movingEndPosition, List<List<PieceType>>? snapshot) {
    return PieceMovement(movingStartPosition, movingEndPosition, null,
        snapshot: snapshot ?? []);
  }

  /// 配置用のctor
  /// 駒台から移動するタイプの場合は、別のfactoryコンストラクタを作成する必要があります。
  factory PieceMovement.putOnly(
      {required PiecePosition putPosition,
      required IPiece killedPiece,
      List<List<PieceType>>? snapshot}) {
    return PieceMovement(PiecePosition.createNew(pieceType: PieceType.Blank),
        putPosition, PieceFactory.createBlankPiece(),
        snapshot: snapshot ?? []);
  }
}
