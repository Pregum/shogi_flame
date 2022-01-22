import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

class BlankPiece extends Component implements IPiece {
  @override
  PieceType pieceType = PieceType.Blank;

  @override
  bool get nextMovableSqure => false;
}
