import 'package:flame/components.dart';
import 'package:shogi_game/widget/piece/model/piece_position.dart';
import 'package:shogi_game/widget/piece/model/piece_route.dart';

import '../model/piece_type.dart';

/// 駒としての機能を表すインタフェース
abstract class IPiece extends Component {
  /// 次に移動できる場所のルートリスト
  /// PieceRouteが移動可能な１パターンです。
  List<PieceRoute> get movableRoutes;

  /// 駒の種類
  PieceType get pieceType;

  /// 駒の種類の設定
  set pieceType(PieceType type);
}
