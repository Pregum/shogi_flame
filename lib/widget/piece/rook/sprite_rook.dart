import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

class SpriteRook extends SpriteComponent implements IPiece {
  SpriteRook(Sprite sprite) : super(sprite: sprite);
  @override
  PieceType pieceType = PieceType.Rook;

  @override
  // TODO: implement movableRoutes
  List<PieceRoute> get movableRoutes => throw UnimplementedError();
}
