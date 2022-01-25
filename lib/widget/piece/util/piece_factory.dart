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

/// [IPiece] のインスタンスを生成するutility
class PieceFactory {
  /// PieceTypeがBlankの [IPiece] のインスタンスを生成します。
  static IPiece createBlankPiece() {
    return BlankPiece();
  }

  /// [PieceType] に応じて [IPiece] のインスタンスを生成します。
  static Future<IPiece?> createSpritePiece(PieceType pieceType) async {
    switch (pieceType) {
      case PieceType.King:
        final sprite = await Sprite.load('king.png');
        return SpriteKing(sprite);
      case PieceType.Rook:
        final sprite = await Sprite.load('rook.png');
        return SpriteRook(sprite);
      case PieceType.Bishop:
        final sprite = await Sprite.load('bishop.png');
        return SpriteBishop(sprite);
      case PieceType.GoldGeneral:
        final sprite = await Sprite.load('gold_general.png');
        return SpriteGold(sprite);
      case PieceType.SilverGeneral:
        final sprite = await Sprite.load('silver_general.png');
        return SpriteSilver(sprite);
      case PieceType.Knight:
        final sprite = await Sprite.load('knight.png');
        return SpriteKnight(sprite);
      case PieceType.Lance:
        final sprite = await Sprite.load('lance.png');
        return SpriteLance(sprite);
      case PieceType.Pawn:
        final sprite = await Sprite.load('pawn.png');
        return SpritePawn(sprite);
      case PieceType.PromotedRook:
        // TODO: Handle this case.
        break;
      case PieceType.PromotedBishop:
        // TODO: Handle this case.
        break;
      case PieceType.PromotedSilver:
        // TODO: Handle this case.
        break;
      case PieceType.PromotedKnight:
        // TODO: Handle this case.
        break;
      case PieceType.PromotedLance:
        // TODO: Handle this case.
        break;
      case PieceType.PromotedPawn:
        // TODO: Handle this case.
        break;
      case PieceType.Blank:
        return BlankPiece();
    }
  }
}
