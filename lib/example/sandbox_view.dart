import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'piece_create_container.dart';

class SandboxView extends StatefulWidget {
  const SandboxView({Key? key}) : super(key: key);

  @override
  _SandboxViewState createState() => _SandboxViewState();
}

class _SandboxViewState extends State<SandboxView> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: PieceCreateContainer());
  }
}
