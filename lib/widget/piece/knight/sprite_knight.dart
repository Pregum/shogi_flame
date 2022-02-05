import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 桂馬のsprite
class SpriteKnight extends SpriteComponent implements IPiece {
  SpriteKnight(Sprite sprite) : super(sprite: sprite);

  @override
  PieceType pieceType = PieceType.Knight;

  @override
  // TODO: implement movableRoutes
  List<PieceRoute> get movableRoutes => throw UnimplementedError();
}
