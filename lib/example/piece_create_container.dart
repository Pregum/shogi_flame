import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class PieceCreateContainer extends FlameGame {
  PieceCreateContainer() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // ひとまず金銀あたりの駒生成ボタンを表示する
    // TODO: 将棋盤のマスタップ時、マスのインスタンスがないため、callbackもしくはsetメソッドを作成する。
    // もしくはstreamを作っておいて、selectorが選択された時に呼ばれるstreamを監視しておく手もある.
    final goldGeneralButton = _PieceCreateButton('Gold', () {});
  }
}

class _PieceCreateButton extends TextComponent with Tappable {
  late VoidCallback callback;

  _PieceCreateButton(String text, this.callback) : super(text: text);

  @override
  bool onTapDown(TapDownInfo info) {
    callback();
    return true;
  }
}
