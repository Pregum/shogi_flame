import 'package:shogi_game/model/interface/i_log_data.dart';

/// ログが残せるinterfaceです。
abstract class Loggingable {
  /// 情報としてログを残します。
  void info(String message, Object? otherData);

  /// [info] と同等です。
  void log(String message, Object? otherData);

  /// エラーが発生した時に使用します。
  void error(String message, Object? otherData);

  /// 動作には問題ないですが、修正が必要な情報をログに残す際に使用します。
  void warn(String message, Object? otherData);

  List<ILogData> get logData;
}
