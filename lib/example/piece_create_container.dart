import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

class PieceCreateContainer extends FlameGame with HasTappables {
  late Tile9x9 board;

  PieceCreateContainer() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // ひとまず金銀あたりの駒生成ボタンを表示する
    add(board = Tile9x9());
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
      final goldPiece =
          await PieceFactory.createSpritePiece(PieceType.GoldGeneral);
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
      final silverPiece =
          await PieceFactory.createSpritePiece(PieceType.SilverGeneral);
      if (silverPiece != null) {
        board.setPiece(silverPiece);
      }
    })
      ..x = 64 * 10
      ..y = 300);
    add(_PieceCreateButton('knight', () async {
      print('set knight piece!!!');
      final knightPiece =
          await PieceFactory.createSpritePiece(PieceType.Knight);
      if (knightPiece != null) {
        board.setPiece(knightPiece);
      }
    })
      ..x = 64 * 10
      ..y = 400);
    add(_PieceCreateButton('lance', () async {
      print('set lance piece!!!');
      final lancePiece = await PieceFactory.createSpritePiece(PieceType.Lance);
      if (lancePiece != null) {
        board.setPiece(lancePiece);
      }
    })
      ..x = 64 * 10
      ..y = 500);
    add(_PieceCreateButton('bishop', () async {
      print('set bishop piece!!!');
      final bishopPiece =
          await PieceFactory.createSpritePiece(PieceType.Bishop);
      if (bishopPiece != null) {
        board.setPiece(bishopPiece);
      }
    })
      ..x = 64 * 10
      ..y = 600);
    add(_PieceCreateButton('rook', () async {
      print('set rook piece!!!');
      final rookPiece = await PieceFactory.createSpritePiece(PieceType.Rook);
      if (rookPiece != null) {
        board.setPiece(rookPiece);
      }
    })
      ..x = 64 * 10 + 120
      ..y = 20);
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
