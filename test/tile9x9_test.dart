import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shogi_game/example/piece_create_container.dart';
import 'package:shogi_game/example/sandbox_view.dart';
import 'package:shogi_game/widget/operator/board_operator.dart';
import 'package:shogi_game/widget/shogi_board/one_tile.dart';
import 'package:shogi_game/widget/shogi_board/tile9x9.dart';

final board = Tile9x9(scale: 2.0, srcTileSize: 32.0);
// final boardOperator = BoardOperator(board);
// final testee = FlameTester(
//   () {
//     return PieceCreateContainer();
//   },
//   gameSize: Vector2(1400, 800),
// );

final boardTester = FlameTester(() => board, gameSize: Vector2(1400, 800));

void main() {
  group('game tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {});

    tearDown(() {});

    // testee.testGameWidget('tile9x9作成確認テスト', verify: (game, tester) async {
    //   // expect(find.byGame<PieceCreateContainer>(), findsOneWidget);
    //   expect(1, 1);
    // }, setUp: (game, tester) async {});
    // Testwidget
    test('sample test', () {
      expect(1, 1);
    });

    boardTester.testGameWidget('found tile9x9 is one test',
        verify: (game, tester) async {
      expect(find.byGame<Tile9x9>(), findsOneWidget);
    });

    // boardTester.testGameWidget("found OneTile instance's num is 81.",
    //     verify: (game, tester) async {
    //   await tester.tapAt(const Offset(72, 32));
    //   await tester.pump(const Duration(seconds: 1));
    //   expect(game.selectedColumnIndex, 1);
    //   expect(game.selectedRowIndex, 0);
    // });
  });
}
