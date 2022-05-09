import 'dart:math';

/// 駒の動作のタイプ
enum MoveType {
  /// 盤面に打った
  Drop,

  /// 上へ前進
  Forward,

  /// 寄り
  Approach,

  /// 下へ後退
  Back
}

extension MoveTypeEx on MoveType {
  String get decribe {
    switch (this) {
      case MoveType.Drop:
        return '打';
      case MoveType.Forward:
        return '上';
      case MoveType.Approach:
        return '寄';
      case MoveType.Back:
        return '引';
    }
  }

  /// ランダムな駒の動作を返します。
  static MoveType random({List<MoveType>? candidates}) {
    var moveTypes = MoveType.values;
    if (candidates != null && candidates.isNotEmpty) {
      moveTypes = moveTypes.where((mt) => candidates.contains(mt)).toList();
    }

    final selectedMoveTypeIndex = Random().nextInt(moveTypes.length);
    final selectedMoveType = moveTypes[selectedMoveTypeIndex];
    return selectedMoveType;
  }
}
