/// 操作のフェーズの状態です。
/// このフェーズはクリック時の処理の分岐などに使用されます。
enum OperatorPhaseType {
  /// 不明です。
  Unknwon,

  /// 開始地点を選択するフェーズです。
  StartTileSelect,

  /// 終了地点を選択するフェーズです。
  EndTileSelect,
}
