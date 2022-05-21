import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';

import '../interface/i_piece.dart';
import '../model/move_state_type.dart';

class SpritePromotedBishop extends SpriteComponent implements IPiece {
  SpritePromotedBishop({super.sprite, PlayerType? playerType}) {
    _playerType = playerType ?? PlayerType.Black;
    if (!_playerType.isBlack) {
      flipVerticallyAroundCenter();
    }
  }
  @override
  PieceType pieceType = PieceType.PromotedBishop;

  late PlayerType _playerType;

  @override
  PlayerType get playerType => _playerType;

  @override
  set playerType(PlayerType playerType) {
    if (_playerType != playerType) {
      flipVerticallyAroundCenter();
    }
    _playerType = playerType;
  }

  @override
  PieceRoute get movableRoutes =>
      _movableRoutes.consideredPieceRoute(playerType);
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveStateType>>[
      <MoveStateType>[
        MoveStateType.Infinite,
        MoveStateType.Movable,
        MoveStateType.Infinite,
      ],
      <MoveStateType>[
        MoveStateType.Movable,
        MoveStateType.Movable,
        MoveStateType.Movable,
      ],
      <MoveStateType>[
        MoveStateType.Infinite,
        MoveStateType.Movable,
        MoveStateType.Infinite,
      ],
    ],
    3,
  );
}
