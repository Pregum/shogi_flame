import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TimelimitProgressBar extends PositionComponent {
  double remainSeconds;
  late Timer _timer;
  void Function()? onTick;

  TimelimitProgressBar({
    this.remainSeconds = 5.0,
    this.onTick,
    super.anchor,
    super.angle,
    super.position,
    super.priority,
    super.scale,
    super.size,
  }) {
    this._timer = Timer(
      this.remainSeconds,
      onTick: () {
        onTick?.call();
        _timer.stop();
      },
    );
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_timer.finished) {
      _timer.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final tickingWidth = width * (_timer.current / remainSeconds);
    final currentSquare = Vector2(tickingWidth, 50);
    print('curr square: $currentSquare, ');
    canvas.drawRect(
        currentSquare.toRect(), Paint()..color = Colors.orangeAccent);

    if (!_timer.finished) {
      final textConfig =
          TextPaint(style: const TextStyle(color: Colors.white, fontSize: 15));
      textConfig.render(
          canvas, _timer.current.toStringAsFixed(2), Vector2(60, 25));
    }
  }

  void startTimer() {
    print('start!!!');
    _timer.start();
  }

  void stopTimer() {
    _timer.stop();
  }

  void resetTimer() {
    _timer.reset();
  }
}
