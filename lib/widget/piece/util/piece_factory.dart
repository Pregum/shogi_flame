import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/blank/blank_piece.dart';
import 'package:shogi_game/widget/piece/gold/sprite_gold.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

class PieceFactory {
  static IPiece createBlankPiece() {
    return BlankPiece();
  }

  static Future<IPiece?> createSpritePiece(PieceType pieceType) async {
    if (pieceType != PieceType.GoldGeneral) {
      throw Exception(
          'It has not been implemented except for the gold general.');
    }
    switch (pieceType) {
      case PieceType.King:
        // TODO: Handle this case.
        break;
      case PieceType.Rook:
        // TODO: Handle this case.
        break;
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
