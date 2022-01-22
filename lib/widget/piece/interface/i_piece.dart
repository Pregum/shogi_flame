import 'package:flame/components.dart';

import '../model/piece_type.dart';

/// 駒としての機能を表すインタフェース
abstract class IPiece extends Component {
  /// 次に移動できる場所
  /// TODO: 実装方針が固まっていないので、考える
  /// e.g.) nxnの2重配列で表示できるマスを表現する？
  bool get nextMovableSqure;

  /// 駒の種類
  PieceType get pieceType;

  /// 駒の種類の設定
  set pieceType(PieceType type);
}
