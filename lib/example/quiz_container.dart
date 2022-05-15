import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/position_type.dart';

import '../widget/piece/model/kifu_generator.dart';
import '../widget/piece/model/move_info.dart';
import '../widget/shogi_board/tile9x9.dart';

class QuizContainer extends FlameGame with HasTappables {
  late Tile9x9 board;
  Component? questionComponent;
  final KifuGenerator kifuGenerator = KifuGenerator();
  MoveInfo? targetMoveInfo;
  final Component successComponent =
      TextComponent(text: 'correct!', textRenderer: TextPaint())
        ..topLeftPosition = Vector2(660, 50);
  final Component failureComponent =
      TextComponent(text: 'incrrect...', textRenderer: TextPaint())
        ..topLeftPosition = Vector2(660, 50);
  var timer = Timer(0.5);
  var canTap = false;
  var haveShown = false;
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    add(board = Tile9x9(
        scale: Tile9x9.defaultScale, srcTileSize: Tile9x9.defaultSrcTileSize));
    board.addListener((tile) {
      if (!canTap) {
        return;
      }

      var rowIndex = tile.rowIndex;
      var columnIndex = tile.columnIndex;
      if (rowIndex == null || columnIndex == null) {
        return;
      }
      if (targetMoveInfo?.rowIndex == rowIndex &&
          targetMoveInfo?.columnIndex == columnIndex) {
        add(successComponent);
      } else {
        add(failureComponent);
        final pp = PiecePosition(
          targetMoveInfo?.rowIndex,
          targetMoveInfo?.columnIndex,
          PositionFieldType.None,
          PieceType.Blank,
        );
        final successTile = board.getTile(pp);
        successTile?.isMovableTile = true;
        // successTile?.stackedPiece.add(PositionComponent(
        //   size: Vector2.all(Tile9x9.defaultScale * Tile9x9.defaultSrcTileSize),
        // ));
      }

      canTap = false;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
    if (timer.finished && !haveShown) {
      // ここに問題表示処理を実装
      _showQuestion();
      haveShown = true;
    }
  }

  Future<void> _showQuestion() async {
    final unpromotedPieceType = PieceTypeEx.unPromotedPieceTypes;
    final moveInfos = kifuGenerator.generateMoveInfos(1,
        pieceTypeCandidates: unpromotedPieceType);
    targetMoveInfo = moveInfos[0];
    questionComponent?.removeFromParent();
    await add(questionComponent =
        // TextComponent(text: '${targetMoveInfo.toString()}のマスはどこ？')
        TextComponent(
      text: 'Tap ${targetMoveInfo?.reversedColumn} ${targetMoveInfo?.row} !',
      // textRenderer: tr,
    )..topLeftPosition = Vector2(660, 20));
    canTap = true;
  }
}
