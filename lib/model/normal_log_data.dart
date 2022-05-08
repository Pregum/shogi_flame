import 'package:shogi_game/model/log_type.dart';

import 'interface/i_log_data.dart';

class NormalLogData implements ILogData {
  @override
  int? id;

  @override
  String message;

  @override
  Object? otherData;

  LogType logType;

  NormalLogData({
    required this.message,
    this.id,
    this.otherData,
    required this.logType,
  });
}
