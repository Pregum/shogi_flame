import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/bishop/sprite_bishop.dart';
import 'package:shogi_game/widget/piece/blank/blank_piece.dart';
import 'package:shogi_game/widget/piece/gold/sprite_gold.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/king/sprite_king.dart';
import 'package:shogi_game/widget/piece/knight/sprite_knight.dart';
import 'package:shogi_game/widget/piece/lance/sprite_lance.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/pawn/sprite_pawn.dart';
import 'package:shogi_game/widget/piece/rook/sprite_rook.dart';
import 'package:shogi_game/widget/piece/silver/sprite_silver.dart';

import '../model/player_type.dart';
import '../promoted_bishop/sprite_promoted_bishop.dart';
import '../promoted_knight/sprite_promoted_knight.dart';
import '../promoted_lance/sprite_promoted_lance.dart';
import '../promoted_pawn/sprite_promoted_pawn.dart';
import '../promoted_rook/sprite_promoted_rook.dart';
import '../promoted_silver/sprite_promoted_silver.dart';

/// [IPiece] のインスタンスを生成するutility
class PieceFactory {
  /// PieceTypeがBlankの [IPiece] のインスタンスを生成します。
  static IPiece createBlankPiece() {
    return BlankPiece();
  }

  /// [PieceType] に応じて [IPiece] のインスタンスを生成します。
  static Future<IPiece?> createSpritePiece(PieceType pieceType, double size,
      {PlayerType? playerType}) async {
    switch (pieceType) {
      case PieceType.King:
        final sprite = await Sprite.load('king.png');
        return SpriteKing(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.Rook:
        final sprite = await Sprite.load('rook.png');
        return SpriteRook(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.Bishop:
        final sprite = await Sprite.load('bishop.png');
        return SpriteBishop(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.GoldGeneral:
        final sprite = await Sprite.load('gold_general.png');
        return SpriteGold(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.SilverGeneral:
        final sprite = await Sprite.load('silver_general.png');
        return SpriteSilver(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.Knight:
        final sprite = await Sprite.load('knight.png');
        return SpriteKnight(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.Lance:
        final sprite = await Sprite.load('lance.png');
        return SpriteLance(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.Pawn:
        final sprite = await Sprite.load('pawn.png');
        return SpritePawn(sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.PromotedRook:
        final sprite = await Sprite.load('promoted_rook.png');
        return SpritePromotedRook(sprite: sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.PromotedBishop:
        final sprite = await Sprite.load('promoted_bishop.png');
        return SpritePromotedBishop(sprite: sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.PromotedSilver:
        final sprite = await Sprite.load('promoted_gold_general.png');
        return SpritePromotedSilver(sprite: sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.PromotedKnight:
        final sprite = await Sprite.load('promoted_gold_general.png');
        return SpritePromotedKnight(sprite: sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.PromotedLance:
        final sprite = await Sprite.load('promoted_gold_general.png');
        return SpritePromotedLance(sprite: sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.PromotedPawn:
        final sprite = await Sprite.load('promoted_pawn.png');
        return SpritePromotedPawn(sprite: sprite, playerType: playerType)
          ..size = Vector2.all(size);
      case PieceType.Blank:
        return BlankPiece();
    }
  }
}
