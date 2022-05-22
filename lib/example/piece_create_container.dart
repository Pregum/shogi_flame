import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shogi_game/widget/operator/action_mode.dart';
import 'package:shogi_game/widget/operator/board_operator.dart';
import 'package:shogi_game/widget/operator/operator_history_table.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

import '../widget/shogi_board/piece_stand.dart';

class PieceCreateContainer extends FlameGame with HasTappables, KeyboardEvents {
  late Tile9x9 board;
  late PieceStand _blackPieceStand;
  late PieceStand _whitePieceStand;
  late BoardOperator operator;

  late _PieceCreateButton changeText;

  PieceCreateContainer() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final marginTop = 64.0;

    // ひとまず金銀あたりの駒生成ボタンを表示する
    final scale = 2.0;
    final srcTileSize = 32.0;
    add(_whitePieceStand = PieceStand(playerType: PlayerType.Black));
    add(board =
        Tile9x9(scale: scale, srcTileSize: srcTileSize, marginTop: marginTop));
    add(_blackPieceStand = PieceStand(playerType: PlayerType.White)
      ..topLeftPosition = Vector2(0, 64 * 10));
    operator = BoardOperator(board,
        blackPieceStand: _blackPieceStand, whitePieceStand: _whitePieceStand);
    add(OperatorHistoryTable(stream: operator.historyStream)
      ..positionType = PositionType.game);
    board.addListener((tile) {
      print('on call board click');
      operator.onClickBoard(tile);
    });
    add(_PieceCreateButton('reset', () {
      board.resetBoard();
    })
      ..x = 64 * 10
      ..y = 20);
    add(_PieceCreateButton('blank', () {
      print('set blank piece!!!');
      final blankPiece = PieceFactory.createBlankPiece();
      operator.putPiece(blankPiece);
    })
      ..x = 64 * 10
      ..y = 100);
    add(_PieceCreateButton('gold', () async {
      print('set gold piece!!!');
      final goldPiece = await PieceFactory.createSpritePiece(
          PieceType.GoldGeneral, scale * srcTileSize);
      if (goldPiece != null) {
        operator.putPiece(goldPiece);
      } else {
        print('generated piece is null...');
      }
    })
      ..x = 64 * 10
      ..y = 200);
    add(_PieceCreateButton('silver', () async {
      print('set silver piece!!!');
      final silverPiece = await PieceFactory.createSpritePiece(
          PieceType.SilverGeneral, scale * srcTileSize);
      if (silverPiece != null) {
        operator.putPiece(silverPiece);
      }
    })
      ..x = 64 * 10
      ..y = 300);
    add(_PieceCreateButton('knight', () async {
      print('set knight piece!!!');
      final knightPiece = await PieceFactory.createSpritePiece(
          PieceType.Knight, scale * srcTileSize);
      if (knightPiece != null) {
        operator.putPiece(knightPiece);
      }
    })
      ..x = 64 * 10
      ..y = 400);
    add(_PieceCreateButton('lance', () async {
      print('set lance piece!!!');
      final lancePiece = await PieceFactory.createSpritePiece(
          PieceType.Lance, scale * srcTileSize);
      if (lancePiece != null) {
        operator.putPiece(lancePiece);
      }
    })
      ..x = 64 * 10
      ..y = 500);
    add(_PieceCreateButton('bishop', () async {
      print('set bishop piece!!!');
      final bishopPiece = await PieceFactory.createSpritePiece(
          PieceType.Bishop, scale * srcTileSize);
      if (bishopPiece != null) {
        operator.putPiece(bishopPiece);
      }
    })
      ..x = 64 * 10
      ..y = 600);
    add(_PieceCreateButton('sprite', () async {
      await operator.startSpriteAnimation();
    })
      ..x = 64 * 10
      ..y = 700);
    add(_PieceCreateButton('rook', () async {
      print('set rook piece!!!');
      final rookPiece = await PieceFactory.createSpritePiece(
          PieceType.Rook, scale * srcTileSize);
      if (rookPiece != null) {
        operator.putPiece(rookPiece);
      }
    })
      ..x = 64 * 10 + 120
      ..y = 20);

    add(_PieceCreateButton('pawn', () async {
      print('set pawn piece!!!');
      final pawnPiece = await PieceFactory.createSpritePiece(
          PieceType.Pawn, scale * srcTileSize);
      if (pawnPiece != null) {
        operator.putPiece(pawnPiece);
      }
    })
      ..x = 64 * 10 + 120
      ..y = 100);
    add(_PieceCreateButton('king', () async {
      print('set king piece!!!');
      final kingPiece = await PieceFactory.createSpritePiece(
          PieceType.King, scale * srcTileSize);
      if (kingPiece != null) {
        operator.putPiece(kingPiece);
      }
    })
      ..x = 64 * 10 + 120
      ..y = 200);
    add(changeText = _PieceCreateButton('change mode', () async {
      if (operator.mode == ActionMode.Put) {
        operator.changeActionMode(ActionMode.Move);
      } else {
        operator.changeActionMode(ActionMode.Put);
      }
      print('change operator mode!!! ${operator.mode}');
    })
      ..x = 64 * 10 + 120
      ..y = 300);
    add(changeText = _PieceCreateButton('undo', () {
      operator.undo();
    })
      ..x = 64 * 10 + 120
      ..y = 400);
    add(changeText = _PieceCreateButton('redo', () {
      operator.redo();
    })
      ..x = 64 * 10 + 120
      ..y = 500);
    add(changeText = _PieceCreateButton('MoveEffect.by', () async {
      await operator.startStage(isTo: false);
    })
      ..x = 64 * 10 + 120
      ..y = 600);
    add(
      changeText = _PieceCreateButton('MoveEffect.to ', () async {
        await operator.startStage(isTo: true);
      })
        ..topLeftPosition = Vector2(64 * 10 + 120, 700),
    );
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event.logicalKey == LogicalKeyboardKey.keyQ) {
      print('tap q');
      board.relocationDefaultPiecePosition();
    }
    return super.onKeyEvent(event, keysPressed);
  }
}

class PieceCreateContainerOfPhone extends FlameGame with HasTappables {
  late Tile9x9 board;
  late BoardOperator operator;

  late _PieceCreateButton changeText;

  PieceCreateContainerOfPhone() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final scale = 1.0;
    final srcTileSize = 32.0;
    // ひとまず金銀あたりの駒生成ボタンを表示する
    add(board = (Tile9x9(scale: scale, srcTileSize: srcTileSize)));
    operator = BoardOperator(board);
    board.addListener((tile) {
      print('on call board click');
      operator.onClickBoard(tile);
    });
    add(_PieceCreateButton('reset', () {
      board.resetBoard();
    })
      ..x = 20
      ..y = 400);
    add(_PieceCreateButton('blank', () {
      print('set blank piece!!!');
      final blankPiece = PieceFactory.createBlankPiece();
      operator.putPiece(blankPiece);
    })
      ..x = 20
      ..y = 500);
    add(_PieceCreateButton('gold', () async {
      print('set gold piece!!!');
      final goldPiece = await PieceFactory.createSpritePiece(
          PieceType.GoldGeneral, scale * srcTileSize);
      if (goldPiece != null) {
        operator.putPiece(goldPiece);
      } else {
        print('generated piece is null...');
      }
    })
      ..x = 20
      ..y = 600);
    add(_PieceCreateButton('silver', () async {
      print('set silver piece!!!');
      final silverPiece = await PieceFactory.createSpritePiece(
          PieceType.SilverGeneral, scale * srcTileSize);
      if (silverPiece != null) {
        operator.putPiece(silverPiece);
      }
    })
      ..x = 20
      ..y = 700);
    add(_PieceCreateButton('knight', () async {
      print('set knight piece!!!');
      final knightPiece = await PieceFactory.createSpritePiece(
          PieceType.Knight, scale * srcTileSize);
      if (knightPiece != null) {
        operator.putPiece(knightPiece);
      }
    })
      ..x = 20
      ..y = 800);
    add(_PieceCreateButton('lance', () async {
      print('set lance piece!!!');
      final lancePiece = await PieceFactory.createSpritePiece(
          PieceType.Lance, scale * srcTileSize);
      if (lancePiece != null) {
        operator.putPiece(lancePiece);
      }
    })
      ..x = 120
      ..y = 400);
    add(_PieceCreateButton('bishop', () async {
      print('set bishop piece!!!');
      final bishopPiece = await PieceFactory.createSpritePiece(
          PieceType.Bishop, scale * srcTileSize);
      if (bishopPiece != null) {
        operator.putPiece(bishopPiece);
      }
    })
      ..x = 120
      ..y = 500);
    add(_PieceCreateButton('rook', () async {
      print('set rook piece!!!');
      final rookPiece = await PieceFactory.createSpritePiece(
          PieceType.Rook, scale * srcTileSize);
      if (rookPiece != null) {
        operator.putPiece(rookPiece);
      }
    })
      ..x = 120
      ..y = 600);

    add(_PieceCreateButton('pawn', () async {
      print('set pawn piece!!!');
      final pawnPiece = await PieceFactory.createSpritePiece(
          PieceType.Pawn, scale * srcTileSize);
      if (pawnPiece != null) {
        operator.putPiece(pawnPiece);
      }
    })
      ..x = 120
      ..y = 700);
    add(_PieceCreateButton('king', () async {
      print('set king piece!!!');
      final kingPiece = await PieceFactory.createSpritePiece(
          PieceType.King, scale * srcTileSize);
      if (kingPiece != null) {
        operator.putPiece(kingPiece);
      }
    })
      ..x = 120
      ..y = 800);
    add(changeText = _PieceCreateButton('change mode', () async {
      if (operator.mode == ActionMode.Put) {
        operator.changeActionMode(ActionMode.Move);
      } else {
        operator.changeActionMode(ActionMode.Put);
      }
      print('change operator mode!!! ${operator.mode}');
    })
      ..x = 120
      ..y = 900);
    add(changeText = _PieceCreateButton('undo', () {
      operator.undo();
    })
      ..x = 120
      ..y = 1000);
    add(changeText = _PieceCreateButton('redo', () {
      operator.redo();
    })
      ..x = 120
      ..y = 1100);
  }
}

class _PieceCreateButton extends TextComponent with Tappable {
  late VoidCallback callback;

  _PieceCreateButton(String text, this.callback) : super(text: text);

  @override
  bool onTapDown(TapDownInfo info) {
    callback();
    return super.onTapDown(info);
  }
}
