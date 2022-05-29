import 'dart:math';

import 'move_type.dart';
import 'piece_relation_type.dart';
import 'piece_type.dart';

/// 手を表すクラス
/// 1手(1st move)のような意味
class MoveInfo {
  /// 配置された駒の種類
  late final PieceType pieceType;

  /// 到達地点の段
  final int row;
  int get rowIndex => max(row - 1, 0);
  int get reversedRow => rowLength - rowIndex;

  final int rowLength;

  // 到達地点の筋
  final int column;
  int get columnIndex => max(column - 1, 0);
  int get reversedColumn => columnLength - columnIndex;

  final int columnLength;

  /// 前の地点の段
  final int? previousRow;

  /// 前の地点の筋
  final int? previousColumn;

  /// 成・不成のフラグ
  /// default: [false]
  final bool isPromotion;

  /// 先手かどうかのフラグ
  /// default: [true]
  final bool isBlack;

  /// 駒の相対位置
  final PieceRelationType? pieceRelationType;

  /// 駒の動作
  /// どの駒が移動したかわからない場合に設定される
  final MoveType? moveType;

  MoveInfo({
    required this.pieceType,
    required this.row,
    required this.column,
    required this.columnLength,
    required this.rowLength,
    this.previousRow,
    this.previousColumn,
    this.isPromotion = false,
    this.isBlack = true,
    this.pieceRelationType,
    this.moveType,
  });

  @override
  String toString() {
    final playerStr = isBlack ? '▲' : '△';
    final pieceRelationTypeStr = pieceRelationType?.describe ?? '';
    final moveTypeStr = moveType?.decribe ?? '';
    final promotionStr = isPromotion ? '成' : '';
    return '$playerStr $reversedColumn $row ${pieceType.describe} $pieceRelationTypeStr $moveTypeStr $promotionStr';
  }
}
