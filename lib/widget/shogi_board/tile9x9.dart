import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/util/piece_factory.dart';
import 'package:shogi_game/widget/shogi_board/selector.dart';

import 'one_tile.dart';

typedef OnTapTileEventHandler = void Function(OneTile tile);

/// 9x9の将棋盤を描画するcomponent
class Tile9x9 extends FlameGame with HasTappables {
  /// 選択マスを表示するselector
  late Selector _selector;

  /// マス単位のインスタンスを保持するフィールド
  late List<List<OneTile>> _matrixTiles;

  /// 選択中の行index(0始まり)
  /// デフォルトはnull
  int? _selectedRowIndex;

  /// 選択中の列index(0始まり)
  /// デフォルトはnull
  int? _selectedColumnIndex;

  /// タイルをタップした時に呼ばれるハンドラーです。
  final List<OnTapTileEventHandler> _eventListeners = <OnTapTileEventHandler>[];

  /// ctor
  Tile9x9();

  static const _scale = 2.0;
  static const _srcTileSize = 32.0;
  static const _destTileSize = _scale * _srcTileSize;

  static const _ROW_COUNT = 9;
  static const _COLUMN_COUNT = 9;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await _prepare9x9Tile();

    await _prepareSelector();
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

  /// [ rowIndex ], [ columnIndex ]のタイルを取得します。
  /// 盤上の範囲外の場合はnullを返します
  OneTile? _getTile(int rowIndex, int columnIndex) {
    if (!(rowIndex >= 0 && rowIndex < _ROW_COUNT)) {
      return null;
    }
    if (!(columnIndex >= 0 && columnIndex < _COLUMN_COUNT)) {
      return null;
    }

    return _matrixTiles[rowIndex][columnIndex];
  }

  /// Tile情報を取得します。
  /// [ destinationPosition ] が盤上の範囲外の場合[ null ]を返します。
  OneTile? getTile(PiecePosition destinationPosition) {
    final row = destinationPosition.row;
    final column = destinationPosition.column;
    if (row == null || column == null) {
      return null;
    }
    return _getTile(row, column);
  }

  /// 現在 [OneTile] から 対象の [OneTile] へ piece を移動させます。
  bool _movePiece(OneTile currentTile, OneTile destinationTile) {
    // 移動元のピースのtypeがblankである場合はfalseを返す。
    final currentPiece = currentTile.stackedPiece;
    if (currentPiece.pieceType == PieceType.Blank) {
      return false;
    }

    // 移動先のピースのtypeがblankでない場合はfalseを返す。
    final destnationPiece = destinationTile.stackedPiece;
    if (destnationPiece.pieceType != PieceType.Blank) {
      return false;
    }

    // TODO: この辺りに間にpieceがないかなどの細かい条件判定を追加する。

    destinationTile.stackedPiece = currentPiece;
    currentTile.stackedPiece = PieceFactory.createBlankPiece();
    return true;
  }

  /// [IPiece] を選択中のマスに設定します。
  /// 設定の成否で [bool] を返します。
  /// true: 成功, false: 失敗
  bool setPiece(IPiece piece) {
    final rowIndex = _selectedRowIndex;
    final columnIndex = _selectedColumnIndex;
    if (rowIndex == null || columnIndex == null) {
      return false;
    }

    if (_matrixTiles.length <= rowIndex ||
        _matrixTiles[rowIndex].length <= columnIndex) {
      // matrix内に収まっていない場合もfalseを返す.
      return false;
    }

    var targetOneTile = _matrixTiles[rowIndex][columnIndex];
    targetOneTile.stackedPiece = piece;
    return true;
  }

  /// 選択中のマスの [row] と [column] を変更します。
  bool changeSelectedTile(PiecePosition destination) {
    final row = destination.row;
    final column = destination.column;
    if (row == null || column == null) {
      return false;
    }

    if (row >= 0 && row < _ROW_COUNT) {
      return false;
    }

    if (column >= 0 && column < _COLUMN_COUNT) {
      return false;
    }

    _selectedRowIndex = row;
    _selectedColumnIndex = column;
    return true;
  }

  /// 9x9タイルの状態をリセットします。
  void resetBoard() {
    for (var row in _matrixTiles) {
      for (var aTile in row) {
        aTile.stackedPiece = PieceFactory.createBlankPiece();
      }
    }
  }

  /// [Selector] の初期設定を行います。
  Future<void> _prepareSelector() async {
    final selectorImage = await images.load('selector.png');
    add(_selector = Selector(_destTileSize, selectorImage));
  }

  /// 9x9の初期設定を行います。
  Future<void> _prepare9x9Tile() async {
    final OnTileTapDowned onTapDowned = (info, rowIndex, columnIndex) {
      print('ontapp!!! row: $rowIndex, column: $columnIndex');
      _selector.visible = !_selector.visible;
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
        // listener.call(_matrixTiles[0][0]);
      }
    };

    // 最初はブランクを入れておく
    final blankPiece = PieceFactory.createBlankPiece();

    /// 内部操作用フィールドの初期化処理
    _matrixTiles = <List<OneTile>>[];

    // 9x9マスのComponentを作成し、内部操作用フィールドへ1行毎に追加していく
    for (int i = 0; i < _ROW_COUNT; i++) {
      final rowTiles = <OneTile>[];

      for (int j = 0; j < _COLUMN_COUNT; j++) {
        final tileImage = await loadSprite(
          'tile.png',
        );
        final oneTile = OneTile(
          onTapDowned,
          Vector2(i * _destTileSize, j * _destTileSize),
          _destTileSize,
          tileImage,
          stackedPiece: blankPiece,
          rowIndex: i,
          columnIndex: j,
        )..anchor = Anchor.topLeft;
        add(oneTile);

        // 操作用フィールドへ追加
        rowTiles.add(oneTile);
      }

      // ここで1行分のList<OneTile>を追加
      _matrixTiles.add(rowTiles);
    }

    // check
    assert(_matrixTiles.length == _ROW_COUNT);
    assert(_matrixTiles[0].length == _COLUMN_COUNT);
  }
}
