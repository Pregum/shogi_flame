import 'package:shogi_game/widget/piece/model/piece_movement.dart';
import 'package:shogi_game/widget/shogi_board/one_tile.dart';

/// 盤上の操作を行うクラスです。
/// 具体的には [Tile9x9] クラスを操作します。
class BoardOperator {
  /// 移動開始地点のタイル
  OneTile? movingStartTile;

  /// 移動終了地点のタイル
  OneTile? movingEndTile;

  List<PieceMovement> movementHistory = <PieceMovement>[];

  /// ctor
  BoardOperator();

  /// 駒の移動を行います。
  void move() {
    // 開始、終了タイルがnullの場合は処理終了
    if (movingStartTile == null || movingEndTile == null) {
      return;
    }
  }

  /// 一つ前の配置に戻します。
  void undo() {
    if (movementHistory.isEmpty) {
      return;
    }

    final lastMovement = movementHistory.removeLast();
    // TODO: ここにlastMovementから元に戻す処理を実行する。
  }

  /// １つ先の配置に進めます。
  void redo() {
    // TODO: ここに先に進める処理を実装する。
  }
}
