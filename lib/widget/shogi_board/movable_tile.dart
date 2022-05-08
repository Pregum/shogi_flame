import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MovableTile extends SpriteComponent {
  bool isVisible = false;

  MovableTile(double s, Sprite spriteImage)
      : super(
            sprite: spriteImage,
            size: Vector2.all(s),
            anchor: Anchor.topLeft,
            paint: Paint()..color.withOpacity(0.8));

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    if (!isVisible) {
      return;
    }

    super.render(canvas);
  }
}
