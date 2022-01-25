import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 銀将のsprite
class SpriteSilver extends SpriteComponent implements IPiece {
  SpriteSilver(Sprite sprite) : super(sprite: sprite);

  @override
  PieceType pieceType = PieceType.SilverGeneral;

  @override
  // TODO: implement nextMovableSqure
  bool get nextMovableSqure => throw UnimplementedError();
}
