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
    add(_PieceCreateButton('gold', () async {
      print('set blank piece!!!');
      final goldPiece =
          await PieceFactory.createSpritePiece(PieceType.GoldGeneral);
      if (goldPiece != null) {
        board.setPiece(goldPiece);
      } else {
        print('generated piece is null...');
      }
    })
      ..x = 64 * 10
      ..y = 100);
    add(_PieceCreateButton('blank', () {
      print('set blank piece!!!');
      final blankPiece = PieceFactory.createBlankPiece();
      board.setPiece(blankPiece);
    })
      ..x = 64 * 10
      ..y = 200);
  }
}

class _PieceCreateButton extends TextComponent with Tappable {
  late VoidCallback callback;

  _PieceCreateButton(String text, this.callback) : super(text: text);

  @override
  bool onTapDown(TapDownInfo info) {
    callback();
    return true;
  }
}
