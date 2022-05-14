enum PlayerType {
  /// なし
  None,

  /// 先手
  Black,

  /// 後手
  White
}

extension PlayerTypeEx on PlayerType {
  bool get isBlack {
    return this == PlayerType.Black;
  }
}
