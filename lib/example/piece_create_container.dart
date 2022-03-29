import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/widget/operator/action_mode.dart';
import 'package:shogi_game/widget/operator/board_operator.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

class PieceCreateContainer extends FlameGame with HasTappables {
  late Tile9x9 board;
  late BoardOperator operator;

  late _PieceCreateButton changeText;

  PieceCreateContainer() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // ひとまず金銀あたりの駒生成ボタンを表示する
    final scale = 2.0;
    final srcTileSize = 32.0;
    add(board = Tile9x9(scale: scale, srcTileSize: srcTileSize));
    operator = BoardOperator(board);
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
      board.setPiece(blankPiece);
    })
      ..x = 64 * 10
      ..y = 100);
    add(_PieceCreateButton('gold', () async {
      print('set gold piece!!!');
      final goldPiece = await PieceFactory.createSpritePiece(
          PieceType.GoldGeneral, scale * srcTileSize);
      if (goldPiece != null) {
        board.setPiece(goldPiece);
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
        board.setPiece(silverPiece);
      }
    })
      ..x = 64 * 10
      ..y = 300);
    add(_PieceCreateButton('knight', () async {
      print('set knight piece!!!');
      final knightPiece = await PieceFactory.createSpritePiece(
          PieceType.Knight, scale * srcTileSize);
      if (knightPiece != null) {
        board.setPiece(knightPiece);
      }
    })
      ..x = 64 * 10
      ..y = 400);
    add(_PieceCreateButton('lance', () async {
      print('set lance piece!!!');
      final lancePiece = await PieceFactory.createSpritePiece(
          PieceType.Lance, scale * srcTileSize);
      if (lancePiece != null) {
        board.setPiece(lancePiece);
      }
    })
      ..x = 64 * 10
      ..y = 500);
    add(_PieceCreateButton('bishop', () async {
      print('set bishop piece!!!');
      final bishopPiece = await PieceFactory.createSpritePiece(
          PieceType.Bishop, scale * srcTileSize);
      if (bishopPiece != null) {
        board.setPiece(bishopPiece);
      }
    })
      ..x = 64 * 10
      ..y = 600);
    add(_PieceCreateButton('rook', () async {
      print('set rook piece!!!');
      final rookPiece = await PieceFactory.createSpritePiece(
          PieceType.Rook, scale * srcTileSize);
      if (rookPiece != null) {
        board.setPiece(rookPiece);
      }
    })
      ..x = 64 * 10 + 120
      ..y = 20);

    add(_PieceCreateButton('pawn', () async {
      print('set pawn piece!!!');
      final pawnPiece = await PieceFactory.createSpritePiece(
          PieceType.Pawn, scale * srcTileSize);
      if (pawnPiece != null) {
        board.setPiece(pawnPiece);
      }
    })
      ..x = 64 * 10 + 120
      ..y = 100);
    add(_PieceCreateButton('king', () async {
      print('set king piece!!!');
      final kingPiece = await PieceFactory.createSpritePiece(
          PieceType.King, scale * srcTileSize);
      if (kingPiece != null) {
        board.setPiece(kingPiece);
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
      board.setPiece(blankPiece);
    })
      ..x = 20
      ..y = 500);
    add(_PieceCreateButton('gold', () async {
      print('set gold piece!!!');
      final goldPiece = await PieceFactory.createSpritePiece(
          PieceType.GoldGeneral, scale * srcTileSize);
      if (goldPiece != null) {
        board.setPiece(goldPiece);
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
        board.setPiece(silverPiece);
      }
    })
      ..x = 20
      ..y = 700);
    add(_PieceCreateButton('knight', () async {
      print('set knight piece!!!');
      final knightPiece = await PieceFactory.createSpritePiece(
          PieceType.Knight, scale * srcTileSize);
      if (knightPiece != null) {
        board.setPiece(knightPiece);
      }
    })
      ..x = 20
      ..y = 800);
    add(_PieceCreateButton('lance', () async {
      print('set lance piece!!!');
      final lancePiece = await PieceFactory.createSpritePiece(
          PieceType.Lance, scale * srcTileSize);
      if (lancePiece != null) {
        board.setPiece(lancePiece);
      }
    })
      ..x = 120
      ..y = 400);
    add(_PieceCreateButton('bishop', () async {
      print('set bishop piece!!!');
      final bishopPiece = await PieceFactory.createSpritePiece(
          PieceType.Bishop, scale * srcTileSize);
      if (bishopPiece != null) {
        board.setPiece(bishopPiece);
      }
    })
      ..x = 120
      ..y = 500);
    add(_PieceCreateButton('rook', () async {
      print('set rook piece!!!');
      final rookPiece = await PieceFactory.createSpritePiece(
          PieceType.Rook, scale * srcTileSize);
      if (rookPiece != null) {
        board.setPiece(rookPiece);
      }
    })
      ..x = 120
      ..y = 600);

    add(_PieceCreateButton('pawn', () async {
      print('set pawn piece!!!');
      final pawnPiece = await PieceFactory.createSpritePiece(
          PieceType.Pawn, scale * srcTileSize);
      if (pawnPiece != null) {
        board.setPiece(pawnPiece);
      }
    })
      ..x = 120
      ..y = 700);
    add(_PieceCreateButton('king', () async {
      print('set king piece!!!');
      final kingPiece = await PieceFactory.createSpritePiece(
          PieceType.King, scale * srcTileSize);
      if (kingPiece != null) {
        board.setPiece(kingPiece);
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
