import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shogi_game/model/normal_logger.dart';

import 'piece_create_container.dart';

class SandboxView extends StatefulWidget {
  const SandboxView({Key? key}) : super(key: key);

  @override
  _SandboxViewState createState() => _SandboxViewState();
}

class _SandboxViewState extends State<SandboxView> {
  late final Stream stream;
  final ScrollController _scontroller = ScrollController();

  @override
  void initState() {
    super.initState();

    this.stream = NormalLogger.singleton().sc.stream;
    this.stream.listen((event) {
      print('on call log stream... length: ${event.length}');
      if (_scontroller.hasClients) {
        _scontroller.animateTo(_scontroller.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: GameWidget(game: PieceCreateContainer()),
        ),
        Flexible(
          child: StreamBuilder(
            stream: this.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                  controller: _scontroller,
                  itemBuilder: (context, index) {
                    final item = NormalLogger.singleton().logData[index];
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item.message),
                    );
                  },
                  itemCount: NormalLogger.singleton().logData.length);
            },
          ),
        ),
      ],
    );
  }
}
