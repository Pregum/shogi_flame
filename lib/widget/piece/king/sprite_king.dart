import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

/// 王将を表すクラス
class SpriteKing extends SpriteComponent implements IPiece {
  SpriteKing(Sprite sprite) : super(sprite: sprite);

  @override
  PieceType pieceType = PieceType.King;

  @override
  // TODO: implement nextMovableSqure
  bool get nextMovableSqure => throw UnimplementedError();
}
