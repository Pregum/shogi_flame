import 'dart:math';

/// 駒のタイプ
enum PieceType {
  /// 空
  /// 何も置かれていないマスを表す
  Blank,

  // 不成駒 --------------------
  /// 王将、玉将(K)
  King,

  /// 飛車(R)
  Rook,

  /// 角行(B)
  Bishop,

  /// 金将(G)
  GoldGeneral,

  /// 銀将(S)
  SilverGeneral,

  /// 桂馬(N)
  Knight,

  /// 香車(L)
  Lance,

  /// 歩兵(P)
  Pawn,

  // 成駒 --------------------

  /// 龍王(竜)
  PromotedRook,

  /// 龍馬(馬)
  PromotedBishop,

  /// 成銀
  PromotedSilver,

  /// 成桂
  PromotedKnight,

  /// 成香
  PromotedLance,

  /// と金
  PromotedPawn,
}

extension PieceTypeEx on PieceType {
  String describe() {
    switch (this) {
      case PieceType.Blank:
        return '  ';
      case PieceType.King:
        return '王';
      case PieceType.Rook:
        return '飛';
      case PieceType.Bishop:
        return '角';
      case PieceType.GoldGeneral:
        return '金';
      case PieceType.SilverGeneral:
        return '銀';
      case PieceType.Knight:
        return '桂';
      case PieceType.Lance:
        return '香';
      case PieceType.Pawn:
        return '歩';
      case PieceType.PromotedRook:
        return '龍';
      case PieceType.PromotedBishop:
        return '馬';
      case PieceType.PromotedSilver:
        return '成銀';
      case PieceType.PromotedKnight:
        return '成桂';
      case PieceType.PromotedLance:
        return '成香';
      case PieceType.PromotedPawn:
        return 'と金';
    }
  }

  /// ランダムな駒のタイプを返します。
  ///
  /// [candidates] が与えられている場合は、その候補リストから選出されます。
  static PieceType random({List<PieceType>? candidates}) {
    // return PieceType.Blank;
    var pieceTypes = PieceType.values;
    final filteredCandidates = candidates?.whereType<PieceType>().toList();
    if (filteredCandidates != null && filteredCandidates.isNotEmpty) {
      pieceTypes =
          pieceTypes.where((pt) => filteredCandidates.contains(pt)).toList();
    }

    final selectedPieceTypeIndex = Random().nextInt(pieceTypes.length);
    final selectedPieceType = pieceTypes[selectedPieceTypeIndex];
    return selectedPieceType;
  }

  bool get isPromotion {
    return this == PieceType.PromotedRook ||
        this == PieceType.PromotedBishop ||
        this == PieceType.PromotedSilver ||
        this == PieceType.PromotedKnight ||
        this == PieceType.PromotedLance ||
        this == PieceType.PromotedPawn;
  }
}
