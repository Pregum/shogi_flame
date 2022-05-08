import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../piece/model/piece_movement.dart';

class OperatorHistoryTable extends FlameGame {
  Stream<Iterable<PieceMovement>> stream;

  OperatorHistoryTable({required this.stream}) {
    stream.listen((event) async {
      children.clear();
      print('event.length: ${event.length}');
      final textStyle = TextStyle(fontSize: 15, color: Colors.white);
      final textPaint = TextPaint(style: textStyle);
      double? prevBottom;
      for (var i = 0; i < event.length; i++) {
        final t = event.elementAt(i);
        final startText = t.movingStartPosition.toString();
        final endText = t.movingEndPosition.toString();
        final text = [startText, endText].join(' / ');
        final cell = OperatorHistoryCell(text: text, anchor: Anchor.centerLeft)
          ..topLeftPosition =
              Vector2(10, (prevBottom ?? 64 * 10 + 64 * i.toDouble()))
          ..textRenderer = textPaint;
        prevBottom = cell.height + cell.y;

        await add(cell);
      }
    });
  }

  @override
  Future<void>? onLoad() {
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

class OperatorHistoryCell extends TextComponent {
  OperatorHistoryCell({required String text, Anchor? anchor, Vector2? size})
      : super(
          text: text,
          anchor: anchor ?? Anchor.center,
          size: size ?? Vector2.all(32),
        );

  @override
  Future<void>? onLoad() {
    return super.onLoad();
  }
}
