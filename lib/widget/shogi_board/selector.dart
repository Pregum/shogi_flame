import 'dart:ui';

import 'package:flame/components.dart';

/// 選択マスを表すcomponent
class Selector extends SpriteComponent {
  /// 表示されているかどうか.
  /// trueに設定すると表示されます.
  bool visible = true;

  /// ctor
  Selector(double s, Image img)
      : super(
          sprite: Sprite(img, srcSize: Vector2.all(32.0)),
          size: Vector2.all(s),
        );

  @override
  void render(Canvas canvas) {
    if (!visible) {
      return;
    }

    super.render(canvas);
  }
}
