import 'package:flame/components.dart';

class AsciiGold extends TextComponent {
  AsciiGold({String? text})
      : super(
          text: text ?? 'gold',
          anchor: Anchor.topLeft,
          size: Vector2.all(64.0),
        );
}
