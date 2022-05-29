import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';

import '../interface/i_piece.dart';
import '../model/move_state_type.dart';

class SpritePromotedKnight extends SpriteComponent implements IPiece {
  SpritePromotedKnight({super.sprite, PlayerType? playerType}) {
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
      flipHorizontallyAroundCenter();
    }
    _playerType = playerType;
  }
}
