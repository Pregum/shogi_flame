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
