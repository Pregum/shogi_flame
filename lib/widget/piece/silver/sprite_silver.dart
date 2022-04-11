import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 銀将のsprite
class SpriteSilver extends SpriteComponent implements IPiece {
  SpriteSilver(Sprite sprite) : super(sprite: sprite);

  @override
  PieceType pieceType = PieceType.SilverGeneral;

  @override
  PieceRoute get movableRoutes => _movableRoutes;
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveType>>[
      <MoveType>[MoveType.Movable, MoveType.Movable, MoveType.Movable],
      <MoveType>[MoveType.UnMovable, MoveType.UnMovable, MoveType.UnMovable],
      <MoveType>[MoveType.Movable, MoveType.UnMovable, MoveType.Movable],
    ],
    3,
  );
}
