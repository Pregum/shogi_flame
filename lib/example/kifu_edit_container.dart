import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/position_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';

import '../widget/piece/model/kifu_generator.dart';
import '../widget/piece/model/piece_position.dart';
import '../widget/piece/model/player_type.dart';
import '../widget/shogi_board/tile9x9.dart';

class KifuEditContainer extends FlameGame with HasTappables {
  late Tile9x9 board;
  final KifuGenerator kifuGenerator = KifuGenerator();
  int generatedLength = 3;
  late TextComponent lengthTextComponent;
  late TextComponent moveInfodsComponent;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    add(board = Tile9x9(
        scale: Tile9x9.defaultScale, srcTileSize: Tile9x9.defaultSrcTileSize));
    add(
      ButtonComponent(
        button: TextComponent(text: '-'),
        onPressed: () {
          generatedLength -= 1;
          lengthTextComponent.removeFromParent();
          add(
            lengthTextComponent = TextComponent(text: '$generatedLength')
              ..topLeftPosition = Vector2(660, 10),
          );
        },
      )..topLeftPosition = Vector2(600, 10),
    );
    add(
      lengthTextComponent = TextComponent(text: '$generatedLength')
        ..topLeftPosition = Vector2(660, 10),
    );
    add(
      ButtonComponent(
        button: TextComponent(text: '+'),
        onPressed: () {
          generatedLength += 1;
          print('generatedLength: $generatedLength');

          lengthTextComponent.removeFromParent();
          add(
            lengthTextComponent = TextComponent(text: '$generatedLength')
              ..topLeftPosition = Vector2(660, 10),
          );
        },
      )..topLeftPosition = Vector2(700, 10),
    );
    add(
      ButtonComponent(
        button: TextComponent(text: '棋譜生成 generate'),
        onPressed: () async {
          final candidates = PieceTypeEx.unPromotedPieceTypes;
          final moveInfos = kifuGenerator.generateMoveInfos(generatedLength,
              pieceTypeCandidates: candidates);
          print(moveInfos.join('\n'));
          moveInfodsComponent.removeFromParent();
          // await Future.delayed(const Duration(milliseconds: 500));
          board.resetBoard();

          add(moveInfodsComponent = TextComponent(text: moveInfos.join('\n'))
            ..topLeftPosition = Vector2(700, 140));

          // ここで盤面に反映させていく
          for (var i = 0; i < moveInfos.length; i++) {
            final moveInfo = moveInfos[i];
            final piecePosition = PiecePosition(
              moveInfo.rowIndex,
              moveInfo.columnIndex,
              PositionFieldType.None,
              PieceType.Blank,
            );
            board.changeSelectedTile(piecePosition);
            final playerType =
                moveInfo.isBlack ? PlayerType.Black : PlayerType.White;
            final piece = await PieceFactory.createSpritePiece(
                moveInfo.pieceType, board.destTileSize,
                playerType: playerType);

            final ret = board.setPiece(piece!);
            print('${moveInfo.toString()}: $ret');
          }
          for (var i = 0; i < board.pieceTypesOnTiles.length; i++) {
            final oneLine = board.pieceTypesOnTiles[i];
            print('$i: ${oneLine.map((pt) => pt.describe).join(' | ')}');
          }
        },
      )..topLeftPosition = Vector2(700, 80),
    );

    add(moveInfodsComponent = TextComponent(text: 'ここに指した手が表示されます。')
      ..topLeftPosition = Vector2(700, 140));
  }
}
