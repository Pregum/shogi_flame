import 'dart:math';

import 'package:shogi_game/widget/piece/model/move_type.dart';
import 'package:shogi_game/widget/piece/model/piece_relation_type.dart';

import 'move_info.dart';
import 'piece_type.dart';

/// 棋譜を生成するクラスです。
class KifuGenerator {
  late final int _columnNum;
  late final int _rowNum;
  KifuGenerator({int? columnNum, int? rowNum}) {
    _columnNum = columnNum ?? defaultColumnNum;
    _rowNum = rowNum ?? defaultRowNum;
  }

  /// デフォルトの列数です。
  static const int defaultColumnNum = 9;

  /// デフォルトの行数です。
  static const int defaultRowNum = 9;

  /// 手を生成します。
  ///
  /// [length] の手数分生成します。
  List<MoveInfo> generateMoveInfos(int length,
      {List<PieceType>? pieceTypeCandidates}) {
    // TODO: 前の手を考慮していない為、前の手を考慮した処理を加える必要がある。
    return List<MoveInfo>.generate(
      length,
      (i) => _generateMoveInfo(
        isBlank: i % 2 == 0,
        pieceTypeCandidates: pieceTypeCandidates,
      ),
    ).toList();
  }

  MoveInfo _generateMoveInfo(
      {bool? isBlank, List<PieceType>? pieceTypeCandidates}) {
    final pt = PieceTypeEx.random(candidates: pieceTypeCandidates);
    final col = Random().nextInt(_columnNum) + 1;
    final row = Random().nextInt(_rowNum) + 1;
    final isBlack = isBlank ?? Random().nextBool();
    final isPromotion = pt.isPromotion && Random().nextBool();
    final mt = Random().nextBool() ? MoveTypeEx.random() : null;
    final prt = Random().nextBool() ? PieceRelationTypeEx.random() : null;

    final moveInfo = MoveInfo(
      pieceType: pt,
      column: col,
      row: row,
      isBlack: isBlack,
      isPromotion: isPromotion,
      moveType: mt,
      pieceRelationType: prt,
      // TODO: previousRow, previousColumnはconfigでON/OFFを切り替えられるようにする。
    );
    return moveInfo;
  }
}
