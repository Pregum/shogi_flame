import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 歩兵のsprite
class SpritePawn extends SpriteComponent implements IPiece {
  SpritePawn(Sprite sprite) : super(sprite: sprite);

  @override
  PieceType pieceType = PieceType.Pawn;

  @override
  // TODO: implement nextMovableSqure
  bool get nextMovableSqure => throw UnimplementedError();
}
