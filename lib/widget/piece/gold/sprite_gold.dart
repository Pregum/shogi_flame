import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

import '../model/move_state_type.dart';

class SpriteGold extends SpriteComponent implements IPiece {
  SpriteGold(Sprite sprite, {PlayerType? playerType}) : super(sprite: sprite) {
    _playerType = playerType ?? PlayerType.Black;
  }

  static Future<SpriteGold> initialize() async {
    final sprite = await Sprite.load('gold_general.png');
    return SpriteGold(sprite);
  }

  @override
  PieceType pieceType = PieceType.GoldGeneral;

  @override
  PieceRoute get movableRoutes =>
      _movableRoutes.consideredPieceRoute(playerType);
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveStateType>>[
      <MoveStateType>[
        MoveStateType.Movable,
        MoveStateType.Movable,
        MoveStateType.Movable
      ],
      <MoveStateType>[
        MoveStateType.Movable,
        MoveStateType.UnMovable,
        MoveStateType.Movable
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.Movable,
        MoveStateType.UnMovable
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
