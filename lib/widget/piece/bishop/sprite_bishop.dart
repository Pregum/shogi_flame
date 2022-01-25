import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 角行のsprite
class SpriteBishop extends SpriteComponent implements IPiece {
  SpriteBishop(Sprite sprite) : super(sprite: sprite);

  static Future<SpriteBishop> initialize() async {
    final sprite = await Sprite.load('gold_general.png');
    return SpriteBishop(sprite);
  }

  @override
  PieceType pieceType = PieceType.GoldGeneral;

  @override
  // TODO: implement nextMovableSqure
  bool get nextMovableSqure => throw UnimplementedError();
}
