import 'package:flutter/material.dart';

import 'example/sandbox_view.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      home: Scaffold(body: SandboxView()
          // body: GameWidget(
          //   game: Tile9x9(),
          // ),
          ),
    ),
  );
}
