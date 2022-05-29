import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';
import 'package:shogi_game/example/quiz_container.dart';
import 'package:shogi_game/widget/ui_widget/timelimit_progress_bar.dart';

import '../widget/piece/model/kifu_generator.dart';
import '../widget/piece/model/move_info.dart';
import '../widget/piece/model/piece_position.dart';
import '../widget/piece/model/piece_type.dart';
import '../widget/piece/model/position_type.dart';
import '../widget/shogi_board/one_tile.dart';
import '../widget/shogi_board/tile9x9.dart';

class ScoreAttackContainer extends FlameGame with HasTappables {
  late Tile9x9 board;
  late TimelimitProgressBar timelimitProgressComponent;
  late PositionComponent headerComponent;
  Component? questionComponent;

  bool _hasShown = false;
  bool _canTap = false;
  Timer _timer = Timer(1);
  List<AnswearResult> _answearHolder = <AnswearResult>[];
  PositionComponent _answearComponent = PositionComponent()
    ..topLeftPosition = Vector2(800, 100);
  Component successComponent =
      TextComponent(text: 'correct!', textRenderer: TextPaint())
        ..topLeftPosition = Vector2(660, 50);
  Component failureComponent =
      TextComponent(text: 'incorrect...', textRenderer: TextPaint())
        ..topLeftPosition = Vector2(660, 50);
  Component? _correctRiveComponent;
  MoveInfo? _targetMoveInfo;
  OneTile? _oldTile;
  final KifuGenerator _kifuGenerator = KifuGenerator();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    add(headerComponent = PositionComponent()..size = Vector2(1000, 100));
    headerComponent.add(timelimitProgressComponent = TimelimitProgressBar(
      onTick: (() => print('ストップしました。')),
    )..size = Vector2(1000, 100));

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

    _prepareQuestion(board);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    if (_timer.finished && !_hasShown) {
      // ここに問題表示処理を実装
      _showQuestion();
      _hasShown = true;
    }
  }

  Future<void> _showQuestion() async {
    _correctRiveComponent?.removeFromParent();
    successComponent.removeFromParent();
    failureComponent.removeFromParent();
    _oldTile?.isMovableTile = false;
    final unpromotedPieceType = PieceTypeEx.unPromotedPieceTypes;
    final moveInfos = _kifuGenerator.generateMoveInfos(1,
        pieceTypeCandidates: unpromotedPieceType);
    _targetMoveInfo = moveInfos[0];
    questionComponent?.removeFromParent();
    await add(questionComponent = TextComponent(
      text: 'Tap ${_targetMoveInfo?.reversedColumn} ${_targetMoveInfo?.row} !',
    )..topLeftPosition = Vector2(660, 20));
    _canTap = true;
  }

  Future<void> _prepareQuestion(Tile9x9 board) async {
    board.addListener((tile) async {
      if (!_canTap) {
        return;
      }

      var rowIndex = tile.rowIndex;
      var columnIndex = tile.columnIndex;
      if (rowIndex == null || columnIndex == null) {
        return;
      }
      final isCorrect = _targetMoveInfo?.rowIndex == rowIndex &&
          _targetMoveInfo?.columnIndex == columnIndex;
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
          _targetMoveInfo?.rowIndex,
          _targetMoveInfo?.columnIndex,
          PositionFieldType.None,
          PieceType.Blank,
        );
        _oldTile = board.getTile(pp);
        _oldTile?.isMovableTile = true;
      }

      final answearResult =
          AnswearResult(moveInfo: _targetMoveInfo!, success: isCorrect);
      _answearHolder.add(answearResult);
      _updateResults();

      _canTap = false;
      _hasShown = false;
      _timer.start();
    });
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
