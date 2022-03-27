import 'package:shogi_game/widget/shogi_board/board_state.dart';

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

extension OperatorPhaseTypeEx on OperatorPhaseType {
  BoardState toBoardState() {
    switch (this) {
      case OperatorPhaseType.StartTileSelect:
        return BoardState.Move;
      case OperatorPhaseType.EndTileSelect:
        return BoardState.Select;
      case OperatorPhaseType.Unknwon:
      default:
        throw Error();
    }
  }
}
