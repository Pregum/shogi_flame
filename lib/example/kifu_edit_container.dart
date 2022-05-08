import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import '../widget/piece/model/kifu_generator.dart';
import '../widget/shogi_board/tile9x9.dart';

class KifuEditContainer extends FlameGame with HasTappables {
  late Tile9x9 board;
  final KifuGenerator kifuGenerator = KifuGenerator();
  int generatedLength = 3;
  late TextComponent lengthTextComponent;
  late TextComponent moveInfodsComponent;

  @override
  Future<void>? onLoad() async {
    super.onLoad();
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
    await add(
      ButtonComponent(
        button: TextComponent(text: '棋譜生成'),
        onPressed: () {
          final moveInfos = kifuGenerator.generateMoveInfos(generatedLength);
          print(moveInfos.join('\n'));
          moveInfodsComponent.removeFromParent();

          add(moveInfodsComponent = TextComponent(text: moveInfos.join('\n'))
            ..topLeftPosition = Vector2(700, 140));
        },
      )..topLeftPosition = Vector2(700, 80),
    );

    add(moveInfodsComponent = TextComponent(text: 'ここに指した手が表示されます。')
      ..topLeftPosition = Vector2(700, 140));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
