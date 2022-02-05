import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/interface/i_piece.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';
import 'package:shogi_game/widget/piece/model/piece_type.dart';

class SpriteGold extends SpriteComponent implements IPiece {
  SpriteGold(Sprite sprite) : super(sprite: sprite);

  static Future<SpriteGold> initialize() async {
    final sprite = await Sprite.load('gold_general.png');
    return SpriteGold(sprite);
  }

  @override
  PieceType pieceType = PieceType.GoldGeneral;

  @override
  // TODO: implement movableRoutes
  List<PieceRoute> get movableRoutes => throw UnimplementedError();
}
