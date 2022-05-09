import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/example/kifu_edit_container.dart';

class KifuEditView extends StatefulWidget {
  const KifuEditView({Key? key}) : super(key: key);

  @override
  State<KifuEditView> createState() => _KifuEditViewState();
}

class _KifuEditViewState extends State<KifuEditView> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: KifuEditContainer());
  }
}
