import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';
import 'package:shogi_game/widget/piece/model/player_type.dart';

/// 空のマスを表す駒
class BlankPiece extends PositionComponent implements IPiece {
  @override
  PieceType pieceType = PieceType.Blank;

  @override
  PieceRoute get movableRoutes => _movableRoutes;
  PieceRoute _movableRoutes = PieceRoute(<List<MoveType>>[], 1);

  @override
  PlayerType get playerType => PlayerType.None;

  @override
  set playerType(PlayerType playerType) {}
}
