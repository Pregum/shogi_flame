import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:shogi_game/example/kifu_edit_view.dart';
import 'package:shogi_game/example/piece_create_container.dart';
import 'package:shogi_game/example/quiz_view.dart';

import '../example/sandbox_view.dart';

void addStrories(Dashbook dashbook) {
  dashbook.storiesOf('Sample Widgets')
    ..add(
      'Tile9x9',
      (_) => SandboxView(),
    )
    ..add('Kifu generator', (_) => KifuEditView())
    ..add('Quiz view', (_) => QuizView());
}
