import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

import '../model/move_state_type.dart';

class SpriteRook extends SpriteComponent implements IPiece {
  SpriteRook(Sprite sprite, {PlayerType? playerType}) : super(sprite: sprite) {
    _playerType = playerType ?? PlayerType.Black;
    if (!_playerType.isBlack) {
      flipVerticallyAroundCenter();
    }
  }
  @override
  PieceType pieceType = PieceType.Rook;

  @override
  PieceRoute get movableRoutes =>
      _movableRoutes.consideredPieceRoute(playerType);
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveStateType>>[
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.Infinite,
        MoveStateType.UnMovable
      ],
      <MoveStateType>[
        MoveStateType.Infinite,
        MoveStateType.UnMovable,
        MoveStateType.Infinite
      ],
      <MoveStateType>[
        MoveStateType.UnMovable,
        MoveStateType.Infinite,
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
    if (_playerType != playerType) {
      // ここで先手・後手の向きを更新する。
      flipVerticallyAroundCenter();
    }
    _playerType = playerType;
  }
}
