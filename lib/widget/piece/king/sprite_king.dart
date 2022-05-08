import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 王将を表すクラス
class SpriteKing extends SpriteComponent implements IPiece {
  SpriteKing(Sprite sprite) : super(sprite: sprite);

  @override
  PieceType pieceType = PieceType.King;

  @override
  PieceRoute get movableRoutes => _movableRoutes;
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveType>>[
      <MoveType>[MoveType.Movable, MoveType.Movable, MoveType.Movable],
      <MoveType>[MoveType.Movable, MoveType.Movable, MoveType.Movable],
      <MoveType>[MoveType.Movable, MoveType.Movable, MoveType.Movable],
    ],
    3,
  );
}
