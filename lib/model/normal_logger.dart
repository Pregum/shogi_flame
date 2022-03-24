import 'package:shogi_game/model/interface/i_log_data.dart';
import 'package:shogi_game/model/normal_log_data.dart';

import 'interface/loggingable.dart';
import 'log_type.dart';

class NormalLogger implements Loggingable {
  List<ILogData> _logData = [];

  NormalLogger._();

  NormalLogger? _ins;
  NormalLogger get singleton {
    return (_ins ??= NormalLogger._());
  }

  @override
  List<ILogData> get logData => _logData;

  @override
  void error(String message, Object? otherData) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Error);
    _logData.add(data);
  }

  @override
  void info(String message, Object? otherData) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Info);
    _logData.add(data);
  }

  @override
  void log(String message, Object? otherData) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Debug);
    _logData.add(data);
  }

  @override
  void warn(String message, Object? otherData) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Warn);
    _logData.add(data);
  }
}
