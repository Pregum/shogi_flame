import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/blank/blank_piece.dart';
import 'package:shogi_game/widget/piece/gold/sprite_gold.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/king/sprite_king.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/rook/sprite_rook.dart';

/// [IPiece] のインスタンスを生成するutility
class PieceFactory {
  /// PieceTypeがBlankの [IPiece] のインスタンスを生成します。
  static IPiece createBlankPiece() {
    return BlankPiece();
  }

  /// [PieceType] に応じて [IPiece] のインスタンスを生成します。
  static Future<IPiece?> createSpritePiece(PieceType pieceType) async {
    if (pieceType != PieceType.GoldGeneral) {
      throw Exception(
          'It has not been implemented except for the gold general.');
    }
    switch (pieceType) {
      case PieceType.King:
        final sprite = await Sprite.load('king.png');
        return SpriteKing(sprite);
      case PieceType.Rook:
        final sprite = await Sprite.load('rook.png');
        return SpriteRook(sprite);
      case PieceType.Bishop:
        // TODO: Handle this case.
        break;
      case PieceType.GoldGeneral:
        var sprite = await Sprite.load('gold_general.png');
        return SpriteGold(sprite);
      case PieceType.SilverGeneral:
        // TODO: Handle this case.
        break;
      case PieceType.Knight:
        // TODO: Handle this case.
        break;
      case PieceType.Lance:
        // TODO: Handle this case.
        break;
      case PieceType.Pawn:
        // TODO: Handle this case.
        break;
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
