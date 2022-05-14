import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

import '../model/move_state_type.dart';

/// 桂馬のsprite
class SpriteKnight extends SpriteComponent implements IPiece {
  SpriteKnight(Sprite sprite, {PlayerType? playerType})
      : super(sprite: sprite) {
    _playerType = playerType ?? PlayerType.None;
  }

  @override
  PieceType pieceType = PieceType.Knight;

  @override
  PieceRoute get movableRoutes =>
      _movableRoutes.consideredPieceRoute(playerType);
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveStateType>>[
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.Movable,
        MoveStateType.UnMovable,
        MoveStateType.Movable,
        MoveStateType.UnMovable
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable
      ],
    ],
    5,
  );

  @override
  PlayerType get playerType => _playerType;
  late PlayerType _playerType;

  @override
  set playerType(PlayerType playerType) {
    _playerType = playerType;
  }
}
