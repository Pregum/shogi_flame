import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

/// 桂馬のsprite
class SpriteKnight extends SpriteComponent implements IPiece {
  SpriteKnight(Sprite sprite, {PlayerType? playerType})
      : super(sprite: sprite) {
    _playerType = playerType ?? PlayerType.None;
  }

  @override
  PieceType pieceType = PieceType.Knight;

  @override
  PieceRoute get movableRoutes => _movableRoutes;
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveType>>[
      <MoveType>[
        MoveType.UnMovable,
        MoveType.Movable,
        MoveType.UnMovable,
        MoveType.Movable,
        MoveType.UnMovable
      ],
      <MoveType>[
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable
      ],
      <MoveType>[
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable
      ],
      <MoveType>[
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable
      ],
      <MoveType>[
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable,
        MoveType.UnMovable
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
