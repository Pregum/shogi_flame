import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/position_type.dart';

import '../widget/piece/model/kifu_generator.dart';
import '../widget/piece/model/move_info.dart';
import '../widget/shogi_board/one_tile.dart';
import '../widget/shogi_board/tile9x9.dart';

class QuizContainer extends FlameGame with HasTappables {
  late Tile9x9 board;
  Component? questionComponent;
  final KifuGenerator kifuGenerator = KifuGenerator();
  MoveInfo? targetMoveInfo;
  OneTile? oldTile;
  Component successComponent =
      TextComponent(text: 'correct!', textRenderer: TextPaint())
        ..topLeftPosition = Vector2(660, 50);
  Component failureComponent =
      TextComponent(text: 'incorrect...', textRenderer: TextPaint())
        ..topLeftPosition = Vector2(660, 50);
  late ButtonComponent retryComponent = ButtonComponent(
      button: TextComponent(text: 'next'),
      onPressed: () {
        // needFadeIn = true;
        _showQuestion();
      })
    ..topLeftPosition = Vector2(660, 80);
  List<AnswearResult> _answearHolder = <AnswearResult>[];
  PositionComponent _answearComponent = PositionComponent()
    ..topLeftPosition = Vector2(800, 100);
  var timer = Timer(1);
  var canTap = false;
  var haveShown = false;
  bool needFadeIn = false;
  bool movingAnimation = false;
  late PositionComponent fadeInComponent;
  Component? _correctRiveComponent;

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    fadeInComponent =
        PositionComponent(size: Vector2(canvasSize.x * 1.5, canvasSize.y))
          ..debugMode = true
          ..topLeftPosition = Vector2(canvasSize.x, 0);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    add(board = Tile9x9(
        scale: Tile9x9.defaultScale, srcTileSize: Tile9x9.defaultSrcTileSize));
    board.addListener((tile) async {
      if (!canTap) {
        return;
      }

      var rowIndex = tile.rowIndex;
      var columnIndex = tile.columnIndex;
      if (rowIndex == null || columnIndex == null) {
        return;
      }
      final isCorrect = targetMoveInfo?.rowIndex == rowIndex &&
          targetMoveInfo?.columnIndex == columnIndex;
      if (isCorrect) {
        add(successComponent =
            TextComponent(text: 'correct!', textRenderer: TextPaint())
              ..topLeftPosition = Vector2(660, 50));
        await _showSuccessRive();
      } else {
        add(failureComponent =
            TextComponent(text: 'incorrect...', textRenderer: TextPaint())
              ..topLeftPosition = Vector2(660, 50));
        final pp = PiecePosition(
          targetMoveInfo?.rowIndex,
          targetMoveInfo?.columnIndex,
          PositionFieldType.None,
          PieceType.Blank,
        );
        oldTile = board.getTile(pp);
        oldTile?.isMovableTile = true;
      }

      final answearResult =
          AnswearResult(moveInfo: targetMoveInfo!, success: isCorrect);
      _answearHolder.add(answearResult);
      _updateResults();

      canTap = false;
      haveShown = false;
      timer.start();
    });
    add(retryComponent);
    add(_answearComponent);
    // await _showSuccessRive();
  }

  void _updateResults() {
    _answearComponent.children.clear();
    final tr = TextPaint();
    for (var i = 0; i < _answearHolder.length; i++) {
      final answear = _answearHolder[i];
      final comp = TextComponent(text: '$answear', textRenderer: tr)
        ..topLeftPosition = Vector2(0, i * 30);
      _answearComponent.add(comp);
      // add(comp);
    }
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

    if (needFadeIn) {
      add(fadeInComponent);
      needFadeIn = false;
      movingAnimation = true;
    } else if (movingAnimation) {
      fadeInComponent.x -= 50;
      if (fadeInComponent.x < -fadeInComponent.size.x) {
        movingAnimation = false;
        fadeInComponent.position = Vector2(canvasSize.x, 0);
      }
    }
  }

  Future<void> _showQuestion() async {
    _correctRiveComponent?.removeFromParent();
    successComponent.removeFromParent();
    failureComponent.removeFromParent();
    oldTile?.isMovableTile = false;
    final unpromotedPieceType = PieceTypeEx.unPromotedPieceTypes;
    final moveInfos = kifuGenerator.generateMoveInfos(1,
        pieceTypeCandidates: unpromotedPieceType);
    targetMoveInfo = moveInfos[0];
    questionComponent?.removeFromParent();
    await add(questionComponent = TextComponent(
      text: 'Tap ${targetMoveInfo?.reversedColumn} ${targetMoveInfo?.row} !',
    )..topLeftPosition = Vector2(660, 20));
    canTap = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
        fadeInComponent.toRect(), Paint()..color = Colors.greenAccent);
  }

  Future<void> _showSuccessRive() async {
    final correctArtboard =
        await loadArtboard(RiveFile.asset('assets/rives/correct_circle.riv'));
    final correctComponent = RiveComponent(
      artboard: correctArtboard,
      priority: 1,
      position: Vector2.all(100),
    )
      ..size = Vector2.all(300)
      ..debugMode = true;
    var controller = OneShotAnimation('first_animation', autoplay: true);
    correctArtboard.addController(controller);
    add(_correctRiveComponent = correctComponent);
  }
}

class AnswearResult {
  final bool success;
  final MoveInfo moveInfo;

  AnswearResult({
    required this.success,
    required this.moveInfo,
  });

  @override
  String toString() {
    final passFailStr = success ? 'o' : 'x';
    return '$passFailStr ${moveInfo.reversedColumn} ${moveInfo.row}';
  }
}
