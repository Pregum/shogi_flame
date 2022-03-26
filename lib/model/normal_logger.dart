import 'dart:async';

import 'package:shogi_game/model/interface/i_log_data.dart';
import 'package:shogi_game/model/normal_log_data.dart';

import 'interface/loggingable.dart';
import 'log_type.dart';

class NormalLogger implements Loggingable {
  List<ILogData> _logData = [];

  NormalLogger._();

  static NormalLogger? _ins;
  factory NormalLogger.singleton() {
    return (_ins ??= NormalLogger._());
  }

  final sc = StreamController<List<ILogData>>.broadcast();

  void dispose() {
    this.sc.close();
  }

  @override
  List<ILogData> get logData => _logData;

  @override
  void error(String message, {Object? otherData}) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Error);
    _logData.add(data);
    sc.sink.add(logData);
  }

  @override
  void info(String message, {Object? otherData}) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Info);
    _logData.add(data);
    sc.sink.add(logData);
  }

  @override
  void debug(String message, {Object? otherData}) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Debug);
    _logData.add(data);
    sc.sink.add(logData);
  }

  @override
  void warn(String message, {Object? otherData}) {
    final data = NormalLogData(
        message: message, otherData: otherData, logType: LogType.Warn);
    _logData.add(data);
    sc.sink.add(logData);
  }
}
