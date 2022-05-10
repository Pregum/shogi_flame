import 'dart:math';

import 'package:flame/effects.dart';
import 'package:flame/layers.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:shogi_game/model/interface/loggingable.dart';
import 'package:shogi_game/model/normal_logger.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/selector.dart';

import 'board_state.dart';
import 'one_tile.dart';

typedef OnTapTileEventHandler = void Function(OneTile tile);

/// 9x9の将棋盤を描画するcomponent
class Tile9x9 extends FlameGame with HasTappables, HasPaint {
  /// 選択マスを表示するselector
  late Selector _selector;

  /// マス単位のインスタンスを保持するフィールド
  late List<List<OneTile>> _matrixTiles;

  late Component _effectControllerObject = Component();

  /// タイル上のpieceTypeを取得するgetter
  List<List<PieceType>> get pieceTypesOnTiles {
    final ret = _matrixTiles.map((row) {
      return row.map((tile) {
        final pt = tile.stackedPiece.pieceType;
        return pt;
      }).toList();
    }).toList();
    return ret;
  }

  /// 選択中の行index(0始まり)
  /// デフォルトはnull
  int? _selectedRowIndex;
  int? get selectedRowIndex => _selectedRowIndex;

  /// 選択中の列index(0始まり)
  /// デフォルトはnull
  int? _selectedColumnIndex;
  int? get selectedColumnIndex => _selectedColumnIndex;

  /// 駒操作のロギングインスタンス
  Loggingable _logger = NormalLogger.singleton();

  /// ボードの操作状態
  var _operationStatus = BoardState.Select;
  set operationStatus(BoardState newValue) {
    _operationStatus = newValue;
  }

  /// タイルをタップした時に呼ばれるハンドラーです。
  final List<OnTapTileEventHandler> _eventListeners = <OnTapTileEventHandler>[];

  double scale;
  double srcTileSize;
  double get destTileSize => scale * srcTileSize;

  static double defaultScale = 2.0;
  static double defaultSrcTileSize = 32.0;

  /// 選択中のタイル
  OneTile? get selectedTile {
    final rowIndex = _selectedRowIndex;
    final columnIndex = _selectedColumnIndex;
    if (rowIndex == null || columnIndex == null) {
      return null;
    }

    final tile = _getTile(rowIndex, columnIndex);
    return tile;
  }

  /// ctor
  Tile9x9({
    this.scale = 2.0,
    this.srcTileSize = 32.0,
  });

  final defaultRowCount = 9;
  final defaultColumnCount = 9;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await _prepare9x9Tile();

    await _prepareSelector();

    await add(_effectControllerObject);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  /// eventHandlerのリスナーを登録します。
  void addListener(OnTapTileEventHandler listener) {
    _eventListeners.add(listener);
  }

  /// リスナーを全て解除します。
  void removeListeners() {
    _eventListeners.removeRange(0, _eventListeners.length);
  }

  /// Tile情報を取得します。
  /// [ destinationPosition ] が盤上の範囲外の場合[ null ]を返します。
  OneTile? getTile(PiecePosition destinationPosition) {
    final row = destinationPosition.rowIndex;
    final column = destinationPosition.columnIndex;
    _logger.info('[tile9x9#getTile]: タイルを取得します. row: $row, column: $row');
    if (row == null || column == null) {
      return null;
    }
    return _getTile(row, column);
  }

  /// 成り込み可能なタイルを返します。
  List<List<bool>> getPromotionTileMatrix(PlayerType playerType) {
    if (playerType == PlayerType.Black) {
      // 先手の場合は上3段(1~3段目)のエリアを成り込み可能エリアとする。
      final tiles = List<List<bool>>.generate(
        defaultRowCount,
        (rowIndex) {
          return List<bool>.generate(defaultColumnCount, (_) => rowIndex < 3);
        },
      );
      return tiles;
    } else {
      // 後手の場合は下3段(7~9段目)のエリアを成り込み可能エリアとする。
      final tiles = List<List<bool>>.generate(
        defaultRowCount,
        (rowIndex) {
          return List<bool>.generate(defaultColumnCount, (_) => rowIndex >= 6);
        },
      );
      return tiles;
    }
  }

  /// [IPiece] を選択中のマスに設定します。
  /// 設定の成否で [bool] を返します。
  /// true: 成功, false: 失敗
  bool setPiece(IPiece piece) {
    final rowIndex = _selectedRowIndex;
    final columnIndex = _selectedColumnIndex;
    if (rowIndex == null || columnIndex == null) {
      _logger.info('[tile9x9#setPiece]: row もしくは column が null です。');
      return false;
    }

    if (_matrixTiles.length <= rowIndex ||
        _matrixTiles[rowIndex].length <= columnIndex) {
      // matrix内に収まっていない場合もfalseを返す.
      _logger.info(
          '[tile9x9#setPiece]: マス目の範囲内ではないです。 row: $rowIndex, column: $columnIndex');

      return false;
    }

    var targetOneTile = _matrixTiles[rowIndex][columnIndex];
    targetOneTile.stackedPiece = piece;
    _logger.info(
        '[tile9x9#setPiece]: row: $rowIndex, column: $columnIndex にタイルを設定しました, piece: ${targetOneTile.stackedPiece.pieceType}');
    return true;
  }

  /// 選択中のマスの [rowIndex] と [columnIndex] を変更します。
  bool changeSelectedTile(PiecePosition destination) {
    final row = destination.rowIndex;
    final column = destination.columnIndex;
    _logger.info(
        '[tile9x9#changeSelectedTile]: row: $row, column: $column が選択されました。');
    if (row == null || column == null) {
      return false;
    }

    if (row < 0 || defaultRowCount <= row) {
      return false;
    }

    if (column < 0 && defaultColumnCount <= column) {
      return false;
    }

    _selectedRowIndex = row;
    _selectedColumnIndex = column;
    return true;
  }

  /// 9x9タイルの状態をリセットします。
  void resetBoard() {
    _logger.info('[tile9x9#resetBoard]: ボードをリセットします。');
    for (var row in _matrixTiles) {
      for (var aTile in row) {
        aTile.stackedPiece = PieceFactory.createBlankPiece();
      }
    }
    _effectControllerObject.children.clear();
  }

  /// 移動可能な位置を更新します。
  /// [centerTile] を中心に左右と上下に半分の辺の長さ分更新処理をかけます。
  void configureMovablePiece(OneTile centerTile, PieceRoute movableRoutes) {
    final centerColumn = centerTile.columnIndex ?? 0;
    final centerRow = centerTile.rowIndex ?? 0;

    final halfWidth = movableRoutes.widthTileLnegth ~/ 2;

    final leftIndex = centerColumn - halfWidth;
    final topIndex = centerRow - halfWidth;

    // 計算処理を実行する
    // 左上から右下に向かって計算を行う
    for (var i = 0; i < movableRoutes.widthTileLnegth; i++) {
      final currRowIndex = topIndex + i;
      // 上下が盤面外の場合はcontinue
      if (currRowIndex < 0 || currRowIndex >= _matrixTiles.length) {
        continue;
      }

      for (var j = 0; j < movableRoutes.widthTileLnegth; j++) {
        final currColumnIndex = leftIndex + j;
        // 左右が盤面外の場合はcontinue
        if (currColumnIndex < 0 || currColumnIndex >= _matrixTiles[i].length) {
          continue;
        }

        // 中心も除く
        if (currRowIndex == centerRow && currColumnIndex == centerColumn) {
          continue;
        }

        final currTile = _matrixTiles[currRowIndex][currColumnIndex];
        final currMovableType = movableRoutes.routeMatrix[i][j];
        _updateMovableState(currMovableType, currTile, currRowIndex, centerRow,
            currColumnIndex, centerColumn);
      }
    }
  }

  /// 移動可能な場所を忘れます。
  void forgetMovablePiece() {
    for (var i = 0; i < _matrixTiles.length; i++) {
      for (var j = 0; j < _matrixTiles[i].length; j++) {
        final tile = _matrixTiles[i][j];
        tile.isMovableTile = false;
      }
    }
  }

  Future<void> startSpriteAnimation() async {
    final sprite = await Sprite.load('start_sprite.png');
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      anchor: Anchor.centerLeft,
      size: Vector2(640, 320),
      position: Vector2(0, 120),
    )
      ..setOpacity(0.0)
      ..add(OpacityEffect.fadeIn(
          EffectController(duration: 1.5, curve: Curves.bounceIn)))
      ..add(OpacityEffect.fadeOut(
          EffectController(duration: 1.5, startDelay: 3)));
    add(spriteComponent);
  }

  Future<void> startAnimation({bool isTo = true}) async {
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 24,
        color: Colors.greenAccent,
        backgroundColor: Colors.blueGrey,
      ),
    );
    final textComp = TextComponent(
      text: 'Start!',
      anchor: Anchor.centerLeft,
      position: Vector2(10, Random().nextDouble() * 100.0),
      priority: 1,
      textRenderer: textPaint,
      size: Vector2(64 * 9, 64 * 4),
      // );
    );

    if (isTo) {
      textComp
        ..add(MoveEffect.to(
          Vector2(150, 80),
          EffectController(
            duration: 1.5,
          ),
        ));
    } else {
      textComp
        ..add(MoveEffect.by(
          Vector2(150, 80),
          EffectController(
            duration: 1.5,
          ),
        ));
    }
    _effectControllerObject.add(textComp);
  }

  /// [ rowIndex ], [ columnIndex ]のタイルを取得します。
  /// 盤上の範囲外の場合はnullを返します
  OneTile? _getTile(int rowIndex, int columnIndex) {
    if (!(rowIndex >= 0 && rowIndex < defaultRowCount)) {
      return null;
    }
    if (!(columnIndex >= 0 && columnIndex < defaultColumnCount)) {
      return null;
    }

    return _matrixTiles[rowIndex][columnIndex];
  }

  /// [currMovableType] に応じて、[currTile] の移動可能フラグの更新を行います。
  void _updateMovableState(MoveType currMovableType, OneTile currTile,
      int currRowIndex, int centerRow, int currColumnIndex, int centerColumn) {
    if (currMovableType == MoveType.Movable &&
        currTile.stackedPiece.pieceType == PieceType.Blank) {
      currTile.isMovableTile = true;
    } else if (currMovableType == MoveType.Infinite) {
      // 範囲外に出るまで中心から対象座標の相対距離を移動可能距離として塗り続ける
      _setMovableTypeToInifiteTiles(
          currRowIndex, centerRow, currColumnIndex, centerColumn);
    } else {
      currTile.isMovableTile = false;
    }
  }

  /// 無限超の移動可能タイルのフラグ更新を行います。
  /// [centerRow], [centerColumn]から[currRowIndex], [currColumnIndex] の差分を端までループしてフラグを立てていきます。
  void _setMovableTypeToInifiteTiles(
      int currRowIndex, int centerRow, int currColumnIndex, int centerColumn) {
    // 範囲外に出るまで中心から対象座標の相対距離を移動可能距離として塗り続ける
    final deltaRow = currRowIndex - centerRow;
    final deltaColumn = currColumnIndex - centerColumn;
    var row = currRowIndex;
    var column = currColumnIndex;
    while (row >= 0 &&
        row < _matrixTiles.length &&
        column >= 0 &&
        column < _matrixTiles[row].length) {
      final tile = _matrixTiles[row][column];

      // 空でなければ止める
      if (tile.stackedPiece.pieceType != PieceType.Blank) {
        break;
      }

      tile.isMovableTile = true;

      row += deltaRow;
      column += deltaColumn;
    }
  }

  /// [Selector] の初期設定を行います。
  Future<void> _prepareSelector() async {
    final selectorImage = await images.load('selector.png');
    // TODO: ios or androidだと表示されないため原因を調べる
    add(_selector = Selector(destTileSize, selectorImage));
  }

  /// 9x9の初期設定を行います。
  Future<void> _prepare9x9Tile() async {
    final OnTileTapDowned onTapDowned = (info, rowIndex, columnIndex) {
      print('ontapp!!! row: $rowIndex, column: $columnIndex');
      _selector.position = info;
      _selectedRowIndex = rowIndex;
      _selectedColumnIndex = columnIndex;

      if (rowIndex == null ||
          columnIndex == null ||
          _matrixTiles.length <= rowIndex ||
          _matrixTiles[0].length <= columnIndex) {
        return;
      }

      // 将棋盤の操作オブジェクトへ伝播する。
      for (var listener in _eventListeners) {
        listener.call(_matrixTiles[rowIndex][columnIndex]);
      }
    };

    // 最初はブランクを入れておく
    final blankPiece = PieceFactory.createBlankPiece();

    /// 内部操作用フィールドの初期化処理
    _matrixTiles = <List<OneTile>>[];

    // 9x9マスのComponentを作成し、内部操作用フィールドへ1行毎に追加していく
    for (int i = 0; i < defaultRowCount; i++) {
      final rowTiles = <OneTile>[];

      for (int j = 0; j < defaultColumnCount; j++) {
        final tileImage = await loadSprite(
          'tile.png',
        );
        final oneTile = OneTile(
          onTapDowned,
          Vector2(j * destTileSize, i * destTileSize),
          destTileSize,
          tileImage,
          stackedPiece: blankPiece,
          rowIndex: i,
          columnIndex: j,
        )..anchor = Anchor.topLeft;
        await add(oneTile);

        // 操作用フィールドへ追加
        rowTiles.add(oneTile);
      }

      // ここで1行分のList<OneTile>を追加
      _matrixTiles.add(rowTiles);
    }

    // check
    assert(_matrixTiles.length == defaultRowCount);
    assert(_matrixTiles[0].length == defaultColumnCount);
  }
}
