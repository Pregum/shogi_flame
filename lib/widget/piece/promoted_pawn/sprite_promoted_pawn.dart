import 'package:flame/components.dart';

import '../interface/i_piece.dart';
import '../model/move_state_type.dart';
import '../model/piece_route.dart';
import '../model/piece_type.dart';
import '../model/player_type.dart';

class SpritePromotedPawn extends SpriteComponent implements IPiece {
  SpritePromotedPawn({super.sprite, PlayerType? playerType}) {
    _playerType = playerType ?? PlayerType.Black;
    if (!_playerType.isBlack) {
      flipVerticallyAroundCenter();
    }
  }
  @override
  PieceType pieceType = PieceType.PromotedKnight;

  @override
  PlayerType get playerType => _playerType;
  late PlayerType _playerType;

  @override
  PieceRoute get movableRoutes =>
      _movableRoutes.consideredPieceRoute(playerType);
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveStateType>>[
      [
        MoveStateType.Movable,
        MoveStateType.Movable,
        MoveStateType.Movable,
      ],
      <MoveStateType>[
        MoveStateType.Movable,
        MoveStateType.Movable,
        MoveStateType.Movable,
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.Movable,
        MoveStateType.UnMovable,
      ],
    ],
    3,
  );

  @override
  set playerType(PlayerType playerType) {
    if (_playerType != playerType) {
      flipVerticallyAroundCenter();
    }
    _playerType = playerType;
  }
}
