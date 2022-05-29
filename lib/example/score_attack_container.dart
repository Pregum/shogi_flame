import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:shogi_game/widget/ui_widget/timelimit_progress_bar.dart';

import '../widget/shogi_board/tile9x9.dart';

class ScoreAttackContainer extends FlameGame with HasTappables {
  late Tile9x9 board;
  late TimelimitProgressBar timelimitProgressComponent;
  late PositionComponent headerComponent;
  late PositionComponent centerComponent;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    add(headerComponent = PositionComponent()..size = Vector2(1000, 100));
    headerComponent.add(timelimitProgressComponent = TimelimitProgressBar(
      onTick: (() => print('ストップしました。')),
    )..size = Vector2(1000, 100));
    add(centerComponent = PositionComponent()
      ..topLeftPosition = Vector2(0, headerComponent.y));

    add(board = Tile9x9(
      scale: Tile9x9.defaultScale,
      srcTileSize: Tile9x9.defaultSrcTileSize,
      marginTop: 100,
    ));

    add(
      ButtonComponent(
        button: TextComponent(text: 'スタート!!!'),
        onPressed: () {
          print('onclick...');
          timelimitProgressComponent.resetTimer();
          timelimitProgressComponent.startTimer();
        },
      )..topLeftPosition = Vector2(500, 50),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
