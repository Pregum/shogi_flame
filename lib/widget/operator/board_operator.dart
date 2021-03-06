import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/model/normal_logger.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_movement.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';
import 'package:shogi_game/widget/piece/model/position_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/one_tile.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

import '../shogi_board/piece_stand.dart';
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

  /// 駒の移動履歴のsink/streamを扱う
  /// 他オブジェクトで移動履歴を扱うときはlistenしてもらう
  final _sc = StreamController<Iterable<PieceMovement>>();

  /// 移動履歴のstream
  Stream<Iterable<PieceMovement>> get historyStream => _sc.stream;

  /// 移動履歴のsink
  StreamSink<Iterable<PieceMovement>> get _sink => _sc.sink;

  /// 現在の履歴のindex
  int _currentHistoryIndex = -1;

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

  /// 先手の駒台
  PieceStand? _blackPieceStand;

  /// 後手の駒台
  PieceStand? _whitePieceStand;

  /// ロガー
  final NormalLogger _logger = NormalLogger.singleton();

  /// ダイアログを出すためのグルーピング用component
  final PositionComponent _promotionDalogComponent =
      PositionComponent(priority: 10)
        ..size = Vector2.all(5000)
        ..position = Vector2.all(0)
        ..debugColor = Colors.red;

  /// ctor
  BoardOperator(this._board,
      {PieceStand? blackPieceStand, PieceStand? whitePieceStand}) {
    _blackPieceStand = blackPieceStand
      ?..callback = (IPiece piece) => onClickStand(piece, PlayerType.Black);
    _whitePieceStand = whitePieceStand
      ?..callback = (IPiece piece) => onClickStand(piece, PlayerType.White);
    final firstSnapshot = List<List<PieceType>>.filled(_board.defaultRowCount,
        List<PieceType>.filled(_board.defaultColumnCount, PieceType.Blank));
    final movement = PieceMovement(
        PiecePosition(0, 0, PositionFieldType.None, PieceType.Blank),
        PiecePosition(0, 0, PositionFieldType.None, PieceType.Blank),
        null,
        snapshot: firstSnapshot);
    _addHistory(movement);

    // ダイアログはTile9x9のメンバに持たせる方が機能的に良さそう?
    _board.add(_promotionDalogComponent);
  }

  /// クラス破棄時に呼び出すメソッドです。
  void dispose() {
    _sc.close();
  }

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
    } else {
      // 終点条件もクリアできなかった場合は、開始地点選択状態へ遷移する。
      operatorStatus = OperatorPhaseType.StartTileSelect;
      _forgetMovingPiece();
    }

    if (_movingStartTile == null || _movingEndTile == null) {
      _logger.debug('[BoardOperator#onClickBoard]: 開始地点のタイルもしくは目標地点のタイルが空です。');
      return;
    }

    if (_movingStartTile?.rowIndex == null ||
        _movingStartTile?.columnIndex == null) {
      // 駒台から打つputPieceメソッドを叩く
      putPiece(_movingStartTile!.stackedPiece, fromPieceStand: true);
      _forgetMovingPiece();
    } else if (_verifySatisfiedMoveCondition(
      startTile: _movingStartTile,
      endTile: _movingEndTile,
    )) {
      // 選択されていれば移動処理を行う。
      _movePiece(startTile: _movingStartTile!, endTile: _movingEndTile!);
      _forgetMovingPiece();
    }
  }

  /// 駒台がクリックされた時のハンドリング処理
  /// クリックされた [piece] に対して配置箇所などの処理を行います。
  void onClickStand(IPiece piece, PlayerType ownerPlayerType) {
    // 事前条件の確認
    if (piece.pieceType.isBlank) {
      return;
    } else if (_operatorStatus != OperatorPhaseType.StartTileSelect) {
      operatorStatus = OperatorPhaseType.StartTileSelect;
      _forgetMovingPiece();
      return;
    }
    final tile = OneTile.fromPiece(
        (xy, rowIndex, columnIndex, isDoubleTap) {}, Vector2.zero(), piece);
    _setMovingStartTile(tile);

    _board.updateMovableTilesThatCanPut(piece, ownerPlayerType);
  }

  /// モードを [ nextMode ] のモードに変更します。
  void changeActionMode(ActionMode nextMode) {
    _logger.info('[BoardOperator#changeActionMode]: モードを変更します。 new: $nextMode');
    _mode = nextMode;
    _forgetMovingPiece();
  }

  /// [piece] を配置します。
  /// 併せて履歴にも追加します。
  void putPiece(IPiece piece, {bool fromPieceStand = false}) {
    operatorStatus = OperatorPhaseType.StartTileSelect;
    final tile = _board.selectedTile;
    if (tile == null) {
      _logger.debug('[BoardOperator#putPiece]: 設置タイルがnullです。');
      return;
    }

    if (fromPieceStand && !tile.isMovableTile) {
      // 駒台から配置の場合は、移動不可の場合は早期return
      return;
    }

    if (piece.playerType.isBlack) {
      _blackPieceStand?.popPiece(piece.pieceType);
    } else {
      _whitePieceStand?.popPiece(piece.pieceType);
      piece.reversePieceDirection();
    }

    final alreadyPiece = tile.stackedPiece;

    _board.setPiece(piece);

    final endPosition = PiecePosition.fromOneTile(tile);
    final movement = PieceMovement.putOnly(
        putPosition: endPosition,
        killedPiece: alreadyPiece,
        snapshot: _board.pieceTypesOnTiles);

    // 履歴の更新
    _addHistory(movement);
  }

  Future<void> startStage({bool isTo = true}) async {
    await _board.startAnimation(isTo: isTo);
  }

  Future<void> startSpriteAnimation() async {
    await _board.startSpriteAnimation();
  }

  /// 一つ前の配置に戻します。
  /// [_movementHistory] が空、もしくは戻れる過去がない場合、何も処理を行いません。
  Future<void> undo() async {
    final pastIndex = _currentHistoryIndex - 1;
    if (_movementHistory.isEmpty ||
        pastIndex < 0 ||
        _movementHistory.length <= pastIndex) {
      return;
    }

    final lastMovement = _movementHistory[pastIndex];
    await _emulatePreviousPieceMovement(lastMovement);
    _forgetMovingPiece();

    _currentHistoryIndex = pastIndex;
    _sink.add(_movementHistory.take(pastIndex + 1));
  }

  /// １つ先の配置に進めます。
  void redo() {
    final futureIndex = _currentHistoryIndex + 1;
    if (_movementHistory.isEmpty ||
        futureIndex < 0 ||
        _movementHistory.length <= futureIndex) {
      return;
    }

    final futureMovement = _movementHistory[futureIndex];
    _emulateNextPieceMovement(futureMovement);
    _forgetMovingPiece();

    _currentHistoryIndex = futureIndex;
    _sink.add(_movementHistory.take(futureIndex + 1));
  }

  Future<void> _emulatePreviousPieceMovement(PieceMovement movement) async {
    final snapshot = movement.snapshot;

    if (snapshot == null) {
      return;
    }

    // snapshotの盤面に戻す
    await syncPiecesOnBoard(snapshot);
  }

  Future<void> syncPiecesOnBoard(List<List<PieceType>> snapshot) async {
    for (var i = 0; i < snapshot.length; i++) {
      final row = snapshot[i];
      for (var j = 0; j < row.length; j++) {
        final tile = row[j];
        _board.changeSelectedTile(
            PiecePosition(i, j, PositionFieldType.None, PieceType.Blank));
        final piece = await PieceFactory.createSpritePiece(
            tile, _board.scale * _board.srcTileSize);
        _board.setPiece(piece!);
      }
      final str = row.map((tile) => tile.describe).join(' | ');
      print('$i: $str');
    }
  }

  Future<void> _emulateNextPieceMovement(PieceMovement movement) async {
    final snapshot = movement.snapshot;
    if (snapshot == null) {
      return;
    }

    // snapshotの盤面に同期する
    await syncPiecesOnBoard(snapshot);
  }

  Future<void> _movePiece(
      {required OneTile startTile, required OneTile endTile}) async {
    operatorStatus = OperatorPhaseType.StartTileSelect;
    // 移動可能タイルでない場合は移動処理を行わない。
    if (!endTile.isMovableTile) {
      _logger.debug('[BoardOperator#_movePiece]: 移動先のタイルが移動可能タイルではないです。');
      return;
    }

    final startPos = PiecePosition.fromOneTile(startTile);
    final endPos = PiecePosition.fromOneTile(endTile);
    _logger.info('[BoardOperator#_movePiece]: pieceを移動します。');

    final movingPiece = startTile.stackedPiece;
    final moveSuccess = _board.changeSelectedTile(endPos);
    if (!moveSuccess) {
      return;
    }

    final handleOnTapDialog = ({IPiece? nPiece}) async {
      final nextPiece = nPiece != null ? nPiece : movingPiece;
      final killedPiece = endTile.stackedPiece;
      _board.setPiece(nextPiece);

      final blankPiece = PieceFactory.createBlankPiece();
      startTile.stackedPiece = blankPiece;

      final movement = PieceMovement(startPos, endPos, killedPiece,
          snapshot: _board.pieceTypesOnTiles);

      final newPiece = await killedPiece.cleanState();
      if (newPiece.pieceType != PieceType.Blank) {
        if (movingPiece.playerType == PlayerType.Black) {
          _blackPieceStand?.pushPiece(newPiece);
        } else {
          _whitePieceStand?.pushPiece(newPiece);
        }
      }

      // 履歴の更新
      _addHistory(movement);
    };

    // 成り、不成の判定を行う。
    final promotionMatrix =
        _board.getPromotionTileMatrix(movingPiece.playerType);
    final isPromotableOfEndTile =
        promotionMatrix[endPos.rowIndex!][endPos.columnIndex!];
    final isPromotableOfStartTile =
        promotionMatrix[startPos.rowIndex!][startPos.columnIndex!];
    // 桂馬などの後ろに下がれない駒の成らせないといけない駒の判定を行う。
    final canMoveNext = _board.verifyCanMoveNext(endTile, movingPiece);
    if (!canMoveNext) {
      final promotedPieceType = movingPiece.pieceType.promotedPieceType;
      final promotedPiece = await PieceFactory.createSpritePiece(
          promotedPieceType, _board.destTileSize,
          playerType: movingPiece.playerType);
      if (!movingPiece.playerType.isBlack) {
        promotedPiece?.y -= _board.destTileSize;
        promotedPiece?.flipHorizontallyAroundCenter();
      }
      handleOnTapDialog(nPiece: promotedPiece);
    } else if ((isPromotableOfEndTile || isPromotableOfStartTile) &&
        movingPiece.pieceType.canPromote) {
      // 成り・不成を決めるダイアログを表示する。
      // 成り・不成用のSpriteComponentを配置してたっぷされたら反映するようにする。
      // ただここでダイアログを出すと下の処理を待つ処理を入れる必要がありよくなさそう？
      // → タップ時のコールバックに処理をセットするなどして対応する
      final promotedPieceType = movingPiece.pieceType.promotedPieceType;
      final okSprite = await PieceFactory.createSpritePiece(
          promotedPieceType, _board.destTileSize,
          playerType: movingPiece.playerType);
      if (!movingPiece.playerType.isBlack) {
        okSprite?.y -= _board.destTileSize;
        okSprite?.flipHorizontallyAroundCenter();
      }
      final sprite = (okSprite as SpriteComponent).sprite;
      final okComponent = SpriteComponent(
          sprite: sprite,
          size: Vector2.all(_board.srcTileSize),
          scale: Vector2.all(_board.scale),
          anchor: Anchor.center);
      final okButtonComp = ButtonComponent(
          button: okComponent,
          position: Vector2(
            endTile.x + _board.srcTileSize / 2,
            endTile.y + _board.srcTileSize / 2,
          ),
          onPressed: () async {
            // 成りのPieceTypeに変更する.
            _promotionDalogComponent.children.clear();
            await handleOnTapDialog(nPiece: okSprite);
            print('成りました。');
          })
        ..debugMode = true;
      final noSprite = (movingPiece as SpriteComponent).sprite;
      final noComponent = SpriteComponent(
        sprite: noSprite,
        size: Vector2.all(_board.srcTileSize),
        scale: Vector2.all(_board.scale),
        anchor: Anchor.center,
      );
      final noButtonComp = ButtonComponent(
          button: noComponent,
          position: Vector2(
            okButtonComp.x + _board.destTileSize * 1.5,
            okButtonComp.y,
          ),
          onPressed: () async {
            _promotionDalogComponent.children.clear();
            await handleOnTapDialog();
            print('不成です。');
          });

      await _promotionDalogComponent.add(okButtonComp);
      await _promotionDalogComponent.add(noButtonComp);
    } else {
      await handleOnTapDialog();
    }
  }

  /// [movement] を新しい履歴に追加します。
  void _addHistory(PieceMovement movement) {
    final nextIndex = _currentHistoryIndex + 1;
    if (_movementHistory.isNotEmpty && nextIndex <= _movementHistory.length) {
      _movementHistory.removeRange(nextIndex, _movementHistory.length);
    }
    _movementHistory.add(movement);
    _currentHistoryIndex = nextIndex;

    _sink.add(_movementHistory);
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
            targetTile.stackedPiece.pieceType == PieceType.Blank ||
        (startTile?.stackedPiece.playerType ?? PlayerType.None) !=
            targetTile.stackedPiece.playerType;
  }

  /// 移動条件を満たしているか判定します。
  bool _verifySatisfiedMoveCondition({
    required OneTile? startTile,
    required OneTile? endTile,
  }) {
    return startTile != null &&
            startTile.stackedPiece.pieceType != PieceType.Blank &&
            endTile != null &&
            endTile.stackedPiece.pieceType == PieceType.Blank ||
        startTile?.stackedPiece.playerType != endTile?.stackedPiece.playerType;
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
