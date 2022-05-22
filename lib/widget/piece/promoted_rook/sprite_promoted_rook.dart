import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';

import '../interface/i_piece.dart';
import '../model/move_state_type.dart';

class SpritePromotedRook extends SpriteComponent implements IPiece {
  SpritePromotedRook({super.sprite, PlayerType? playerType}) {
    _playerType = playerType ?? PlayerType.Black;
    if (!_playerType.isBlack) {
      flipVerticallyAroundCenter();
    }
  }
  @override
  PieceType pieceType = PieceType.PromotedRook;

  @override
  PlayerType get playerType => _playerType;
  late PlayerType _playerType;

  @override
  PieceRoute get movableRoutes => PieceRoute(
        <List<MoveStateType>>[
          <MoveStateType>[
            MoveStateType.Movable,
            MoveStateType.Infinite,
            MoveStateType.Movable,
          ],
          <MoveStateType>[
            MoveStateType.Infinite,
            MoveStateType.Infinite,
            MoveStateType.Infinite,
          ],
          <MoveStateType>[
            MoveStateType.Movable,
            MoveStateType.Infinite,
            MoveStateType.Movable,
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
