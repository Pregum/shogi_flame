import 'piece_position.dart';

/// 駒の移動を表すオブジェクト
class PieceMovement {
  /// 移動開始地点
  PiecePosition movingStartPosition;

  /// 移動終了地点
  PiecePosition movingEndPosition;

  /// ctor
  PieceMovement(this.movingStartPosition, this.movingEndPosition);
}
