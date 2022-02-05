import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_movement.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/one_tile.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

/// 盤上の操作を行うクラスです。
/// 具体的には [Tile9x9] クラスを操作します。
class BoardOperator {
  /// 移動開始地点のタイル
  OneTile? movingStartTile;

  /// 移動終了地点のタイル
  OneTile? movingEndTile;

  /// 駒の移動履歴
  List<PieceMovement> movementHistory = <PieceMovement>[];

  /// 現在の履歴のindex
  int _currentHistoryIndex = 0;

  /// 操作対象のboard
  final Tile9x9 board;

  /// ctor
  BoardOperator(this.board);

  /// 将棋盤に対してアクションします。
  void clickBoard(OneTile targetTile) {
    if (movingStartTile == null) {
      movingStartTile = targetTile;
    } else if (movingEndTile == null) {
      movingEndTile = targetTile;
    }

    // movingStartTile()
    if (movingStartTile != null && movingEndTile != null) {
      final firstPos = PiecePosition.fromOneTile(movingStartTile!);
      final endPos = PiecePosition.fromOneTile(movingEndTile!);
      final movement =
          PieceMovement(firstPos, endPos, movingEndTile!.stackedPiece);
      _movePiece(movement);
      _forgetMovingPiece();
    }
  }

  /// 選択中の[movingStartTile] と [movingEndTile] の手を忘れます。
  void _forgetMovingPiece() {
    movingStartTile = null;
    movingEndTile = null;
  }

  /// 駒の移動を行います。
  /// 戻り値に討ち取った[ IPiece ]を取得します。
  /// 討ち取った駒がなければ[ null ]を返します。
  ///
  /// 移動元or移動先のコマがない、操作する駒がない場合は [Error] が発生します。
  IPiece? move(PieceMovement movement) {
    // 移動元のタイルがない場合はnull
    final startTile = board.getTile(movement.movingStartPosition);
    if (startTile == null) {
      throw new Error();
    }

    // 操作駒がない場合はnull
    final movingPiece = startTile.stackedPiece;
    if (movingPiece.pieceType == PieceType.Blank) {
      // return null;
      throw new Error();
    }

    // 移動先のタイルがない場合はnull
    final destTile = board.getTile(movement.movingEndPosition);
    if (destTile == null) {
      throw new Error();
    }

    // 空の場合は倒した駒がない為、nullを返す
    final killedPiece = destTile.stackedPiece;
    if (killedPiece.pieceType == PieceType.Blank) {
      return null;
    }

    destTile.stackedPiece = movingPiece;
    startTile.stackedPiece = PieceFactory.createBlankPiece();
    return killedPiece;
  }

  /// [startPos] から [trialRoute] を通って移動が可能か検証します。
  ///
  /// 可能: true, 不可能: false を返します。
  bool _verifyMovingRoute(PiecePosition startPos, PieceRoute trialRoute) {
    final path = trialRoute.route;
    throw UnimplementedError();
  }

  /// 一つ前の配置に戻します。
  /// [movementHistory] が空、もしくは戻れる過去がない場合、何も処理を行いません。
  void undo() {
    final pastIndex = _currentHistoryIndex - 1;
    if (movementHistory.isEmpty ||
        _currentHistoryIndex <= 0 ||
        movementHistory.length <= pastIndex) {
      return;
    }

    _currentHistoryIndex = pastIndex;

    final lastMovement = movementHistory[pastIndex];
    _moveReversePiece(lastMovement);
    _forgetMovingPiece();
  }

  /// １つ先の配置に進めます。
  void redo() {
    final futureIndex = _currentHistoryIndex + 1;
    if (movementHistory.isEmpty ||
        _currentHistoryIndex <= 0 ||
        movementHistory.length <= futureIndex) {
      return;
    }
    _currentHistoryIndex = futureIndex;

    final futureMovement = movementHistory[futureIndex];
    _movePiece(futureMovement);
    _forgetMovingPiece();
  }

  void _moveReversePiece(PieceMovement movement) {
    // 先に移動した駒を前の位置に戻す
    final startPos = movement.movingStartPosition;
    final endPos = movement.movingEndPosition;

    final startTile = board.getTile(startPos);
    final endTile = board.getTile(endPos);
    if (startTile == null || endTile == null) {
      // 'tile at startPos or endPos is null. startPos: $startPos, endPos: $endPos';
      // TODO: 他に良いエラー記述方法がないか検討する。
      throw Error();
    }

    final movingPiece = endTile.stackedPiece;
    board.changeSelectedTile(startPos);
    // TODO: ここで成り、不成の分岐を実装する。
    board.setPiece(movingPiece);

    final killedPiece = movement.killedPiece;
    if (killedPiece != null) {
      // TODO: 駒台クラスからPieceを受け取る処理を記載する。
      board.changeSelectedTile(endPos);
      board.setPiece(killedPiece);
    }
  }

  void _movePiece(PieceMovement movement) {
    final startPos = movement.movingStartPosition;
    final endPos = movement.movingEndPosition;

    final startTile = board.getTile(startPos);
    final endTile = board.getTile(endPos);
    if (startTile == null || endTile == null) {
      // 'tile at startPos or endPos is null. startPos: $startPos, endPos: $endPos';
      // TODO: 他に良いエラー記述方法がないか検討する。
      throw new Error();
    }

    final movingPiece = startTile.stackedPiece;
    board.changeSelectedTile(endPos);
    // TODO: ここで成り、不成の分岐を実装する。
    board.setPiece(movingPiece);

    final blanckPiece = PieceFactory.createBlankPiece();
    startTile.stackedPiece = blanckPiece;

    final killedPiece = movement.killedPiece;
    if (killedPiece != null) {
      // TODO: 駒台クラスへ駒を渡す処理を実装する
    }

    // 履歴の更新
    final nextIndex = _currentHistoryIndex + 1;
    if (movementHistory.isNotEmpty &&
        movementHistory[_currentHistoryIndex] != movementHistory.last) {
      movementHistory.removeRange(nextIndex, movementHistory.length);
    }
    movementHistory.add(movement);
    _currentHistoryIndex = nextIndex;
  }
}
