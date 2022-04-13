import 'package:shogi_game/model/normal_logger.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_movement.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/one_tile.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

import 'action_mode.dart';
import 'operator_phase_type.dart';

/// 盤上の操作を行うクラスです。
/// 具体的には [Tile9x9] クラスを操作します。
class BoardOperator {
  /// 移動開始地点のタイル
  OneTile? _movingStartTile;

  /// 移動終了地点のタイル
  OneTile? _movingEndTile;

  /// 駒の移動履歴
  List<PieceMovement> _movementHistory = <PieceMovement>[];

  /// 現在の履歴のindex
  int _currentHistoryIndex = 0;

  /// 操作モードです。
  ActionMode _mode = ActionMode.Put;
  ActionMode get mode => _mode;

  /// 現在移動可能なルートです。
  PieceRoute? get currentMovableRoutes =>
      _movingStartTile?.stackedPiece.movableRoutes;

  /// 操作フェーズです。
  /// [OperatorPhaseType.StartTileSelect] や [OperatorPhaseType.EndTileSelect] があります。
  OperatorPhaseType _operatorStatus = OperatorPhaseType.StartTileSelect;
  set operatorStatus(OperatorPhaseType newValue) {
    _operatorStatus = newValue;
    _board.operationStatus = _operatorStatus.toBoardState();
    _logger.info(
        '[BoardOperator#operatorStatus::setter]: フェーズが変更されました。 new phase: $newValue');
  }

  /// 操作対象のboard
  final Tile9x9 _board;

  /// ロガー
  final NormalLogger _logger = NormalLogger.singleton();

  /// ctor
  BoardOperator(this._board);

  /// 将棋盤に対してアクションします。
  void onClickBoard(OneTile targetTile) {
    if (_mode != ActionMode.Move) {
      _logger.debug('[BoardOperator#onClickBoard]: ActionModeがMoveではないです。');
      return;
    }

    if (_verifySatisfiedStartTile(targetTile: targetTile)) {
      _setMovingStartTile(targetTile);
      return;
    } else if (_verifySatisfiedEndTile(
        targetTile: targetTile, startTile: _movingStartTile)) {
      _setMovingEndTile(targetTile);
    }

    if (_movingStartTile == null || _movingEndTile == null) {
      _logger.debug('[BoardOperator#onClickBoard]: 開始地点のタイルもしくは目標地点のタイルが空です。');
      return;
    }

    // 選択されていれば移動処理を行う。
    if (_verifySatisfiedMoveCondition(
      startTile: _movingStartTile,
      endTile: _movingEndTile,
    )) {
      _movePiece(startTile: _movingStartTile!, endTile: _movingEndTile!);
      _forgetMovingPiece();
    }
  }

  /// 駒の移動を行います。
  /// 戻り値に討ち取った[ IPiece ]を取得します。
  /// 討ち取った駒がなければ[ null ]を返します。
  ///
  /// 移動元or移動先のコマがない、操作する駒がない場合は [Error] が発生します。
  IPiece? move(PieceMovement movement) {
    // 移動元のタイルがない場合はnull
    final startTile = _board.getTile(movement.movingStartPosition);
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
    final destTile = _board.getTile(movement.movingEndPosition);
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

  /// モードを [ nextMode ] のモードに変更します。
  void changeActionMode(ActionMode nextMode) {
    _logger.info('[BoardOperator#changeActionMode]: モードを変更します。 new: $nextMode');
    _mode = nextMode;
    _forgetMovingPiece();
  }

  /// 一つ前の配置に戻します。
  /// [_movementHistory] が空、もしくは戻れる過去がない場合、何も処理を行いません。
  void undo() {
    final pastIndex = _currentHistoryIndex - 1;
    if (_movementHistory.isEmpty ||
        _currentHistoryIndex <= 0 ||
        _movementHistory.length <= pastIndex) {
      return;
    }

    _currentHistoryIndex = pastIndex;

    final lastMovement = _movementHistory[pastIndex];
    _emulatePreviousPieceMovement(lastMovement);
    _forgetMovingPiece();
  }

  /// １つ先の配置に進めます。
  void redo() {
    final futureIndex = _currentHistoryIndex + 1;
    if (_movementHistory.isEmpty ||
        _currentHistoryIndex < 0 ||
        _movementHistory.length <= futureIndex) {
      return;
    }
    _currentHistoryIndex = futureIndex;

    final futureMovement = _movementHistory[futureIndex];
    _emulateNextPieceMovement(futureMovement);
    _forgetMovingPiece();
  }

  void _emulatePreviousPieceMovement(PieceMovement movement) {
    // 先に移動した駒を前の位置に戻す
    final startPos = movement.movingStartPosition;
    final endPos = movement.movingEndPosition;

    final startTile = _board.getTile(startPos);
    final endTile = _board.getTile(endPos);
    if (startTile == null || endTile == null) {
      // TODO: 他に良いエラー記述方法がないか検討する。
      _logger.error(
          '[BoardOperator#_emulateMovingPiece]: 開始地点、もしくは終了地点のタイルがnullです。');
      throw Error();
    }

    final movingPiece = endTile.stackedPiece;
    _board.changeSelectedTile(startPos);
    // TODO: ここで成り、不成の分岐を実装する。
    _board.setPiece(movingPiece);

    final killedPiece = movement.killedPiece;
    if (killedPiece != null) {
      // TODO: 駒台クラスからPieceを受け取る処理を記載する。
      _board.changeSelectedTile(endPos);
      _board.setPiece(killedPiece);
    }
  }

  void _emulateNextPieceMovement(PieceMovement movement) {
    final startTile = _board.getTile(movement.movingStartPosition);
    final endTile = _board.getTile(movement.movingEndPosition);

    if (startTile == null || endTile == null) {
      // TODO: 他に良いエラー記述方法がないか検討する。
      _logger.error(
          '[BoardOperator#_emulateNextPieceMovement]: 開始地点、もしくは終了地点のタイルがnullです。');
      throw Error();
    }

    _movePiece(startTile: startTile, endTile: endTile);
  }

  void _movePiece({required OneTile startTile, required OneTile endTile}) {
    operatorStatus = OperatorPhaseType.StartTileSelect;
    // 移動可能タイルでない場合は移動処理を行わない。
    if (!endTile.isMovableTile) {
      _logger.debug('[BoardOperator#_movePiece]: 移動先のタイルが移動可能タイルではないです。');
      return;
    }

    final startPos = PiecePosition.fromOneTile(startTile);
    final endPos = PiecePosition.fromOneTile(endTile);
    final movement = PieceMovement(startPos, endPos, endTile.stackedPiece);
    _logger.info('[BoardOperator#_movePiece]: pieceを移動します。');

    final movingPiece = startTile.stackedPiece;
    _board.changeSelectedTile(endPos);
    // TODO: ここで成り、不成の分岐を実装する。
    _board.setPiece(movingPiece);

    final blanckPiece = PieceFactory.createBlankPiece();
    startTile.stackedPiece = blanckPiece;

    final killedPiece = movement.killedPiece;
    if (killedPiece != null) {
      // TODO: 駒台クラスへ駒を渡す処理を実装する
    }

    // 履歴の更新
    final nextIndex = _currentHistoryIndex + 1;
    if (_movementHistory.isNotEmpty && nextIndex < _movementHistory.length) {
      _movementHistory.removeRange(nextIndex, _movementHistory.length);
    }
    _movementHistory.add(movement);
    _currentHistoryIndex = nextIndex;
  }

  /// 選択中の[_movingStartTile] と [_movingEndTile] の手を忘れます。
  void _forgetMovingPiece() {
    _logger.debug('[BoardOperator#_forgetMovingPiece]: 開始地点と終了地点をクリアします。');
    _movingStartTile = null;
    _movingEndTile = null;
    _board.forgetMovablePiece();
  }

  /// 引数の [ targetTile ] が開始地点の条件を満たしているか判定します。
  bool _verifySatisfiedStartTile({required OneTile targetTile}) {
    return _operatorStatus == OperatorPhaseType.StartTileSelect &&
        targetTile.stackedPiece.pieceType != PieceType.Blank;
  }

  /// 引数の [ targetTile ] が終了地点の条件を満たしているか判定します。
  bool _verifySatisfiedEndTile({
    required OneTile targetTile,
    required OneTile? startTile,
  }) {
    return _operatorStatus == OperatorPhaseType.EndTileSelect &&
        startTile != null &&
        targetTile.stackedPiece.pieceType == PieceType.Blank;
  }

  /// 移動条件を満たしているか判定します。
  bool _verifySatisfiedMoveCondition({
    required OneTile? startTile,
    required OneTile? endTile,
  }) {
    return startTile != null &&
        startTile.stackedPiece.pieceType != PieceType.Blank &&
        endTile != null &&
        endTile.stackedPiece.pieceType == PieceType.Blank;
  }

  /// [targetTile] を終了地点のタイルに設定します。
  /// 同時に [operatorStatus] を開始地点選択フェーズへ変更します。
  void _setMovingStartTile(OneTile targetTile) {
    _movingStartTile = targetTile;
    _board.configureMovablePiece(
        targetTile, targetTile.stackedPiece.movableRoutes);
    _logger.info('[BoardOperator#onClickBoard]: _movingStartTileにセットしました。');
    operatorStatus = OperatorPhaseType.EndTileSelect;
  }

  /// [targetTile] を開始地点のタイルに設定します。
  /// 同時に [operatorStatus] をタイル移動フェーズへ変更します。
  void _setMovingEndTile(OneTile targetTile) {
    _movingEndTile = targetTile;
    _logger.info('[BoardOperator#onClickBoard]: _movingEndTileにセットしました。');
    operatorStatus = OperatorPhaseType.MoveTile;
  }
}
