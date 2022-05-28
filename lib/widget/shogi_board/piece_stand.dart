import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../piece/interface/i_piece.dart';
import '../piece/model/piece_type.dart';
import '../piece/model/player_type.dart';
import '../piece/util/piece_factory.dart';

/// タップされた[piece] を引数で渡されたcallbackに渡します。
typedef OnTapPiece = void Function(IPiece piece);

/// 駒台
class PieceStand extends PositionComponent {
  /// 駒台を所持しているplayer typeです。
  final PlayerType playerType;

  /// 駒を保持するholderです。
  Map<PieceType, List<IPiece>> _pieceHolder = Map<PieceType, List<IPiece>>();

  late ShapeComponent _standComponent;

  /// タップされた時のコールバック
  OnTapPiece? callback;

  final TextPaint textConfig = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 20),
  );

  /// デフォルトの駒のサイズ
  static final double defaultPieceSize = 64.0;

  /// ctor
  PieceStand({required this.playerType, super.size, this.callback}) {
    debugMode = true;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await _preparePieceStand();
  }

  /// 駒台の生成を行います。
  Future<void> _preparePieceStand() async {
    // 行うこと
    // holderの初期化
    _pieceHolder = Map<PieceType, List<IPiece>>();
    // 駒台の描画
    add(
      _standComponent = RectangleComponent(
        size: super.size,
        paint: Paint()..color = Color.fromARGB(255, 255, 165, 20),
      ),
    );
  }

  /// [piece]を駒台に追加します。
  void pushPiece(IPiece piece) {
    if (_pieceHolder.containsKey(piece.pieceType)) {
      _pieceHolder[piece.pieceType]?.add(piece);
    } else {
      _pieceHolder[piece.pieceType] = <IPiece>[piece];
    }
    _updatePieceStandLayout();
  }

  /// 駒台の駒をクリアします。
  void clear() {
    _pieceHolder.clear();
    children.clear();
  }

  /// 駒を排出する。
  /// 排出したコマはリストから削除されます。
  IPiece? popPiece(PieceType gavenPieceType) {
    if (!_pieceHolder.containsKey(gavenPieceType) ||
        (_pieceHolder[gavenPieceType]?.isEmpty ?? true)) {
      return null;
    }

    // 存在する場合は、１つ目のpieceを渡す
    final last = _pieceHolder[gavenPieceType]?.removeLast();
    _updatePieceStandLayout();
    return last;
  }

  Future<void> _updatePieceStandLayout() async {
    // ここでレイアウトの更新を行います。
    children.clear();
    int index = 0;
    for (var entry in _pieceHolder.entries) {
      if (entry.value.isEmpty) {
        continue;
      }

      final piece = await PieceFactory.createSpritePiece(
          entry.value.first.pieceType, defaultPieceSize,
          playerType: PlayerType.Black);

      if (piece == null) {
        continue;
      }

      await piece.add(TextComponent(text: entry.value.length.toString())
        ..topLeftPosition = Vector2(48.0, 10));
      await add(
        ButtonComponent(
          button: piece,
          size: piece.size,
          onPressed: () async {
            final replica = await piece.clone();
            replica?.children
                .where((value) => value is TextComponent)
                .forEach((labelComp) {
              labelComp.removeFromParent();
            });
            replica?.playerType = playerType;
            print('tap piece: ${replica?.pieceType}');
            callback?.call(replica!);
          },
        )..topLeftPosition = Vector2(index * defaultPieceSize, 0),
      );
      index++;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
