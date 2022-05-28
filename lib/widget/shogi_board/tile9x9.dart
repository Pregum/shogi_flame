import 'dart:math';

import 'package:flame/effects.dart';
import 'package:flame/input.dart';
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

import '../piece/model/move_state_type.dart';
import 'board_state.dart';
import 'one_tile.dart';

typedef OnTapTileEventHandler = void Function(OneTile tile);

/// 9x9の将棋盤を描画するcomponent
class Tile9x9 extends FlameGame with HasTappables, HasPaint, DoubleTapDetector {
  /// 選択マスを表示するselector
  late Selector _selector;

  /// マス単位のインスタンスを保持するフィールド
  late List<List<OneTile>> _tileMatrix;

  late Component _effectControllerObject = Component();

  /// タイル上のpieceTypeを取得するgetter
  List<List<PieceType>> get pieceTypesOnTiles {
    final ret = _tileMatrix.map((row) {
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

  double marginTop;
  double marginLeft;

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
    this.scale = 4.0,
    this.srcTileSize = 32.0,
    this.marginTop = 0.0,
    this.marginLeft = 0.0,
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

    if (_tileMatrix.length <= rowIndex ||
        _tileMatrix[rowIndex].length <= columnIndex) {
      // matrix内に収まっていない場合もfalseを返す.
      _logger.info(
          '[tile9x9#setPiece]: マス目の範囲内ではないです。 row: $rowIndex, column: $columnIndex');

      return false;
    }

    var targetOneTile = _tileMatrix[rowIndex][columnIndex];
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

  /// 配置可能なタイルを更新します。
  void updateMovableTilesThatCanPut(IPiece piece, PlayerType actionPlayerType) {
    var movableTileMatrix = <List<bool>>[];

    if (_tileMatrix.isEmpty) {
      return;
    }
    var pawnExistColumns =
        List<bool>.generate(_tileMatrix[0].length, (_) => false);

    // ラスタ走査で、フラグをたてていく
    for (var i = 0; i < _tileMatrix.length; i++) {
      final oneLineTiles = <bool>[];
      for (var j = 0; j < _tileMatrix[i].length; j++) {
        final tile = _tileMatrix[i][j];
        final targetPiece = tile.stackedPiece;
        final isBlank = targetPiece.pieceType.isBlank;
        oneLineTiles.add(isBlank);

        // TODO: 配置後、進めない位置の処理も実装する

        // 歩の場合、同列にすでに配置されていればフラグを立てる
        if (targetPiece.pieceType == PieceType.Pawn &&
            targetPiece.playerType == actionPlayerType) {
          pawnExistColumns[j] = true;
        }
      }
      movableTileMatrix.add(oneLineTiles);
    }

    // ２歩を防ぐ為、その列は塗らないようにする。
    for (var i = 0; i < _tileMatrix.length; i++) {
      for (var j = 0; j < _tileMatrix[i].length; j++) {
        final tile = _tileMatrix[i][j];
        var willMovable = movableTileMatrix[i][j];
        if (piece.pieceType == PieceType.Pawn) {
          willMovable = willMovable && !pawnExistColumns[j];
        }
        tile.isMovableTile = willMovable;
      }
    }
  }

  /// 9x9タイルの状態をリセットします。
  void resetBoard() {
    _logger.info('[tile9x9#resetBoard]: ボードをリセットします。');
    for (var row in _tileMatrix) {
      for (var aTile in row) {
        aTile.stackedPiece = PieceFactory.createBlankPiece();
      }
    }
    _effectControllerObject.children.clear();
  }

  bool verifyCanMoveNext(OneTile endTile, IPiece movingPiece) {
    if (movingPiece.pieceType == PieceType.Blank) {
      return false;
    }

    if (movingPiece.pieceType.canBack) {
      return true;
    }

    final movableRoutes = movingPiece.movableRoutes;

    final centerCol = endTile.columnIndex ?? 0;
    final centerRow = endTile.rowIndex ?? 0;

    final halfWidth = movableRoutes.widthTileLnegth ~/ 2;

    final leftIndex = centerCol - halfWidth;
    final topIndex = centerRow - halfWidth;

    for (var i = 0; i < movableRoutes.widthTileLnegth; i++) {
      final currRowIndex = topIndex + i;

      if (currRowIndex < 0 || currRowIndex >= _tileMatrix.length) {
        continue;
      }

      for (var j = 0; j < movableRoutes.widthTileLnegth; j++) {
        final currColumnIndex = leftIndex + j;
        if (currColumnIndex < 0 || currColumnIndex >= _tileMatrix[i].length) {
          continue;
        }

        if (currRowIndex == centerRow && currColumnIndex == centerCol) {
          continue;
        }

        final currMovaleType = movableRoutes.routeMatrix[i][j];
        // １つでも移動可能なタイルが存在していればtrueを返す。
        if (currMovaleType == MoveStateType.Movable ||
            currMovaleType == MoveStateType.Infinite) {
          return true;
        }
      }
    }

    return false;
  }

  /// デフォルトの駒の配置処理を行います。
  Future<void> relocationDefaultPiecePosition() async {
    for (var i = 0; i < defaultRowCount; i++) {
      for (var j = 0; j < defaultColumnCount; j++) {
        if (i == 2) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.Pawn, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if (i == defaultRowCount - 3) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.Pawn, destTileSize,
                  playerType: PlayerType.Black)
                ?..debugMode = true)!;
        } else if ((i == 1 && j == 1)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.Rook, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if ((i == defaultRowCount - 2 && j == defaultColumnCount - 2)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.Rook, destTileSize,
                  playerType: PlayerType.Black))!;
        } else if ((i == 1 && j == defaultColumnCount - 2)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.Bishop, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if ((i == defaultRowCount - 2 && j == 1)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.Bishop, destTileSize,
                  playerType: PlayerType.Black))!;
        } else if ((i == 0 && j == 0) ||
            (i == 0 && j == defaultColumnCount - 1)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.Lance, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if ((i == defaultRowCount - 1 && j == 0) ||
            (i == defaultRowCount - 1 && j == defaultColumnCount - 1)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.Lance, destTileSize,
                  playerType: PlayerType.Black))!;
        } else if ((i == 0 && j == 1) ||
            (i == 0 && j == defaultColumnCount - 2)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.Knight, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if ((i == defaultRowCount - 1 && j == 1) ||
            (i == defaultRowCount - 1 && j == defaultColumnCount - 2)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.Knight, destTileSize,
                  playerType: PlayerType.Black))!;
        } else if ((i == 0 && j == 2) ||
            (i == 0 && j == defaultColumnCount - 3)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.SilverGeneral, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if ((i == defaultRowCount - 1 && j == 2) ||
            (i == defaultRowCount - 1 && j == defaultColumnCount - 3)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.SilverGeneral, destTileSize,
                  playerType: PlayerType.Black))!;
        } else if ((i == 0 && j == 3) ||
            (i == 0 && j == defaultColumnCount - 4)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.GoldGeneral, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if ((i == defaultRowCount - 1 && j == 3) ||
            (i == defaultRowCount - 1 && j == defaultColumnCount - 4)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.GoldGeneral, destTileSize,
                  playerType: PlayerType.Black))!;
        } else if ((i == 0 && j == 4)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                      PieceType.King, destTileSize,
                      playerType: PlayerType.White)
                    ?..y -= destTileSize)!
                  .reversePieceDirection();
        } else if ((i == defaultRowCount - 1 && j == 4)) {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.King, destTileSize,
                  playerType: PlayerType.Black))!;
        } else {
          _tileMatrix[i][j].stackedPiece =
              (await PieceFactory.createSpritePiece(
                  PieceType.Blank, destTileSize,
                  playerType: PlayerType.Black))!;
        }
      }
    }
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
      if (currRowIndex < 0 || currRowIndex >= _tileMatrix.length) {
        continue;
      }

      for (var j = 0; j < movableRoutes.widthTileLnegth; j++) {
        final currColumnIndex = leftIndex + j;
        // 左右が盤面外の場合はcontinue
        if (currColumnIndex < 0 || currColumnIndex >= _tileMatrix[i].length) {
          continue;
        }

        // 中心も除く
        if (currRowIndex == centerRow && currColumnIndex == centerColumn) {
          continue;
        }

        final currTile = _tileMatrix[currRowIndex][currColumnIndex];
        final currMovableType = movableRoutes.routeMatrix[i][j];
        _updateMovableState(currMovableType, currTile, currRowIndex, centerRow,
            currColumnIndex, centerColumn, centerTile.stackedPiece.playerType);
      }
    }
  }

  /// 移動可能な場所を忘れます。
  void forgetMovablePiece() {
    for (var i = 0; i < _tileMatrix.length; i++) {
      for (var j = 0; j < _tileMatrix[i].length; j++) {
        final tile = _tileMatrix[i][j];
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

    return _tileMatrix[rowIndex][columnIndex];
  }

  /// [currMovableType] に応じて、[currTile] の移動可能フラグの更新を行います。
  void _updateMovableState(
      MoveStateType currMovableType,
      OneTile currTile,
      int currRowIndex,
      int centerRow,
      int currColumnIndex,
      int centerColumn,
      PlayerType playerType) {
    if (currMovableType == MoveStateType.Movable &&
        (currTile.stackedPiece.pieceType == PieceType.Blank ||
            playerType != currTile.stackedPiece.playerType)) {
      currTile.isMovableTile = true;
    } else if (currMovableType == MoveStateType.Infinite) {
      // 範囲外に出るまで中心から対象座標の相対距離を移動可能距離として塗り続ける
      _setMovableTypeToInifiteTiles(
          currRowIndex, centerRow, currColumnIndex, centerColumn, playerType);
    } else {
      currTile.isMovableTile = false;
    }
  }

  /// 無限超の移動可能タイルのフラグ更新を行います。
  /// [centerRow], [centerColumn]から[currRowIndex], [currColumnIndex] の差分を端までループしてフラグを立てていきます。
  void _setMovableTypeToInifiteTiles(int currRowIndex, int centerRow,
      int currColumnIndex, int centerColumn, PlayerType playerType) {
    // 範囲外に出るまで中心から対象座標の相対距離を移動可能距離として塗り続ける
    final deltaRow = currRowIndex - centerRow;
    final deltaColumn = currColumnIndex - centerColumn;
    var row = currRowIndex;
    var column = currColumnIndex;
    while (row >= 0 &&
        row < _tileMatrix.length &&
        column >= 0 &&
        column < _tileMatrix[row].length) {
      final tile = _tileMatrix[row][column];

      // 敵の駒もしくは空でなければ止める
      if (tile.stackedPiece.playerType != PlayerType.None &&
          tile.stackedPiece.playerType != playerType) {
        tile.isMovableTile = true;
        break;
      } else if (tile.stackedPiece.pieceType != PieceType.Blank) {
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

  /// 駒の持ち主を先手・後手を入れ替えます。
  void _swapPlayerType(OneTile tile) {
    if (tile.stackedPiece.playerType == PlayerType.Black) {
      tile.stackedPiece.playerType = PlayerType.White;
    } else {
      tile.stackedPiece.playerType = PlayerType.Black;
    }
    // tile.stackedPiece.flipVerticallyAroundCenter();
  }

  /// 9x9の初期設定を行います。
  Future<void> _prepare9x9Tile() async {
    final OnTileTapDown handleOnTileTapDown =
        (info, rowIndex, columnIndex, isDoubleTap) {
      print(
          'ontapp!!! row: $rowIndex, column: $columnIndex, doubleTap: $isDoubleTap');
      _selector.position = info;
      _selectedRowIndex = rowIndex;
      _selectedColumnIndex = columnIndex;

      if (rowIndex == null ||
          columnIndex == null ||
          _tileMatrix.length <= rowIndex ||
          _tileMatrix[0].length <= columnIndex) {
        return;
      }

      if (isDoubleTap) {
        _swapPlayerType(_tileMatrix[rowIndex][columnIndex]);
      }

      // 将棋盤の操作オブジェクトへ伝播する。
      for (var listener in _eventListeners) {
        listener.call(_tileMatrix[rowIndex][columnIndex]);
      }
    };

    // 最初はブランクを入れておく
    final blankPiece = PieceFactory.createBlankPiece();

    /// 内部操作用フィールドの初期化処理
    _tileMatrix = <List<OneTile>>[];

    // 9x9マスのComponentを作成し、内部操作用フィールドへ1行毎に追加していく
    for (int i = 0; i < defaultRowCount; i++) {
      final rowTiles = <OneTile>[];

      for (int j = 0; j < defaultColumnCount; j++) {
        final tileImage = await loadSprite(
          'tile.png',
        );
        final oneTile = OneTile(
          handleOnTileTapDown,
          Vector2(marginLeft + j * destTileSize, marginTop + i * destTileSize),
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
      _tileMatrix.add(rowTiles);
    }

    // check
    assert(_tileMatrix.length == defaultRowCount);
    assert(_tileMatrix[0].length == defaultColumnCount);
  }
}
