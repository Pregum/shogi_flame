import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

import '../model/move_state_type.dart';

/// 角行のsprite
class SpriteBishop extends SpriteComponent implements IPiece {
  SpriteBishop(Sprite sprite, {PlayerType? playerType})
      : super(sprite: sprite) {
    _playerType = playerType ?? PlayerType.Black;
  }

  static Future<SpriteBishop> initialize() async {
    final sprite = await Sprite.load('gold_general.png');
    return SpriteBishop(sprite);
  }

  @override
  PieceType pieceType = PieceType.GoldGeneral;

  @override
  PieceRoute get movableRoutes => _movableRoutes;
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveStateType>>[
      <MoveStateType>[
        MoveStateType.Infinite,
        MoveStateType.UnMovable,
        MoveStateType.Infinite
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.UnMovable,
        MoveStateType.UnMovable
      ],
      <MoveStateType>[
        MoveStateType.Infinite,
        MoveStateType.UnMovable,
        MoveStateType.Infinite
      ],
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
