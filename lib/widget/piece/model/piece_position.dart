import 'package:shogi_game/widget/shogi_board/one_tile.dart';

import 'piece_type.dart';
import 'position_type.dart';

/// 駒の位置を表すオブジェクト
class PiecePosition {
  /// [rowIndex] は0始まりの行数
  ///
  /// 駒台などマスに配置されていない場合はnull
  int? rowIndex;

  /// [columnIndex] は0始まりの列数
  ///
  /// 駒台などマスに配置されていない場合はnull
  int? columnIndex;

  /// 配置された場所のタイプ
  PositionFieldType positionFieldType;

  /// 配置されている駒の種類
  PieceType pieceType;

  /// ctor
  PiecePosition(
      this.rowIndex, this.columnIndex, this.positionFieldType, this.pieceType);

  @override
  String toString() {
    return 'row: $rowIndex, column: $columnIndex, pieceType: $pieceType';
  }

  /// [OneTile] から [PiecePosition] を生成します。
  factory PiecePosition.fromOneTile(OneTile tile) {
    final positionFieldType = tile.rowIndex != null && tile.columnIndex != null
        ? PositionFieldType.Square
        : PositionFieldType.PieceStand;
    return PiecePosition(tile.rowIndex, tile.columnIndex, positionFieldType,
        tile.stackedPiece.pieceType);
  }

  factory PiecePosition.createNew({required PieceType pieceType}) {
    return PiecePosition(null, null, PositionFieldType.None, pieceType);
  }
}
