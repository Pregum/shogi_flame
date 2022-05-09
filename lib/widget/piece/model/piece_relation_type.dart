import 'dart:math';

enum PieceRelationType {
  /// 右
  FromRight,

  /// 左
  FromLeft,
}

extension PieceRelationTypeEx on PieceRelationType {
  String get describe {
    switch (this) {
      case PieceRelationType.FromRight:
        return '右';
      case PieceRelationType.FromLeft:
        return '左';
    }
  }

  /// ランダムな駒の動作を返します。
  static PieceRelationType random({List<PieceRelationType>? candidates}) {
    var pieceRelationTypes = PieceRelationType.values;
    if (candidates != null && candidates.isNotEmpty) {
      pieceRelationTypes =
          pieceRelationTypes.where((prt) => candidates.contains(prt)).toList();
    }

    final selectedPieceRelationTypeIndex =
        Random().nextInt(pieceRelationTypes.length);
    final selectedPieceRelationType =
        pieceRelationTypes[selectedPieceRelationTypeIndex];
    return selectedPieceRelationType;
  }
}
