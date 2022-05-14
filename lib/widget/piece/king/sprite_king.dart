import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

/// 王将を表すクラス
class SpriteKing extends SpriteComponent implements IPiece {
  SpriteKing(Sprite sprite, {PlayerType? playerType}) : super(sprite: sprite) {
    _playerType = playerType ?? PlayerType.Black;
  }

  @override
  PieceType pieceType = PieceType.King;

  @override
  PieceRoute get movableRoutes => _movableRoutes;
  PieceRoute _movableRoutes = PieceRoute(
    <List<MoveType>>[
      <MoveType>[MoveType.Movable, MoveType.Movable, MoveType.Movable],
      <MoveType>[MoveType.Movable, MoveType.Movable, MoveType.Movable],
      <MoveType>[MoveType.Movable, MoveType.Movable, MoveType.Movable],
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
