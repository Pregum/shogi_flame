import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

class SpriteRook extends SpriteComponent implements IPiece {
  SpriteRook(Sprite sprite, {PlayerType? playerType}) : super(sprite: sprite) {
    _playerType = playerType ?? PlayerType.None;
  }
  @override
  PieceType pieceType = PieceType.Rook;

  @override
  PieceRoute get movableRoutes => _movableRoutes;
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveType>>[
      <MoveType>[MoveType.UnMovable, MoveType.Infinite, MoveType.UnMovable],
      <MoveType>[MoveType.Infinite, MoveType.UnMovable, MoveType.Infinite],
      <MoveType>[MoveType.UnMovable, MoveType.Infinite, MoveType.UnMovable],
    ],
    3,
  );

  @override
  PlayerType get playerType => _playerType;
  late PlayerType _playerType;

  @override
  set playerType(PlayerType playerType) {
    _playerType = playerType;
  }
}
