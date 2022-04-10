import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 香車のsprite
class SpriteLance extends SpriteComponent implements IPiece {
  SpriteLance(Sprite sprite) : super(sprite: sprite);

  @override
  PieceType pieceType = PieceType.Lance;

  @override
  // TODO: implement movableRoutes
  PieceRoute get movableRoutes => throw UnimplementedError();
}
