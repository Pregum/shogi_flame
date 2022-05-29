import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';
import 'package:shogi_game/example/quiz_container.dart';
import 'package:shogi_game/widget/ui_widget/timelimit_progress_bar.dart';
import 'package:universal_platform/universal_platform.dart';

import '../widget/piece/model/kifu_generator.dart';
import '../widget/piece/model/move_info.dart';
import '../widget/piece/model/piece_position.dart';
import '../widget/piece/model/piece_type.dart';
import '../widget/piece/model/position_type.dart';
import '../widget/shogi_board/one_tile.dart';
import '../widget/shogi_board/tile9x9.dart';

class ScoreAttackContainer extends FlameGame with HasTappables {
  Tile9x9? _board;
  late TimelimitProgressBar timelimitProgressComponent;
  late PositionComponent headerComponent;
  Component? _questionComponent;

  bool get _isPhone => UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

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
  late final Vector2 _screenSize;

  /// ctor
  ScoreAttackContainer({required Size size, super.camera}) {
    _screenSize = Vector2(size.width, size.height);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    add(headerComponent = PositionComponent()
      ..size = Vector2(_screenSize.x, 100));
    headerComponent.add(timelimitProgressComponent = TimelimitProgressBar(
      remainSeconds: 30.0,
      onTick: (() => print('ストップしました。')),
    )..size = Vector2(_screenSize.x, 100));

    add(_board = Tile9x9(
      scale: _isPhone ? 1.0 : Tile9x9.defaultScale,
      srcTileSize: _isPhone
          ? (_screenSize.x / (_board?.defaultColumnCount ?? 10))
          : Tile9x9.defaultSrcTileSize,
      marginTop: 100,
    ));

    add(
      ButtonComponent(
        button: TextComponent(text: 'start!!!'),
        onPressed: () {
          print('onclick start...');
          _answearHolder.clear();
          _updateResults();
          timelimitProgressComponent.resetTimer();
          timelimitProgressComponent.startTimer();
          _showQuestion();
        },
      )..topLeftPosition = _isPhone
          ? ((Vector2(2, _board?.destTileSize ?? 0) * 11) + Vector2(0, 50))
          : Vector2(600, 50),
    );
    add(
      ButtonComponent(
        button: TextComponent(text: 'stop!!!'),
        onPressed: () {
          print('onclick stop...');
          timelimitProgressComponent.stopTimer();
        },
      )..topLeftPosition = _isPhone
          ? ((Vector2(2, _board?.destTileSize ?? 0) * 12) + Vector2(0, 50))
          : Vector2(600, 80),
    );

    _prepareQuestion(_board!);
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
    _questionComponent?.removeFromParent();
    await add(_questionComponent = TextComponent(
      text: 'Tap ${_targetMoveInfo?.reversedColumn} ${_targetMoveInfo?.row} !',
    )..topLeftPosition = _isPhone
        ? ((Vector2(2, _board?.destTileSize ?? 0) * 14) + Vector2(0, 50))
        : Vector2(760, 50));
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
              ..topLeftPosition = Vector2(600, 150));
        await _showSuccessRive();
      } else {
        add(failureComponent =
            TextComponent(text: 'incorrect...', textRenderer: TextPaint())
              ..topLeftPosition = Vector2(600, 150));
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
    if (_isPhone) {
      _answearComponent.position =
          Vector2(_screenSize.x / 2, (_board?.destTileSize ?? 32.0) * 12);
    }
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
