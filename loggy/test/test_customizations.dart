import 'package:loggy/loggy.dart';

class TestBlocLoggy with UiLoggy {}

class WhitelistTestBlocLoggy with WhitelistLoggy {}

class BlacklistTestBlocLoggy with BlacklistLoggy {}

mixin WhitelistLoggy implements LoggyType {
  @override
  Loggy<WhitelistLoggy> get loggy => Loggy<WhitelistLoggy>('WhitelistLoggy');
}

mixin BlacklistLoggy implements LoggyType {
  @override
  Loggy<BlacklistLoggy> get loggy => Loggy<BlacklistLoggy>('BlacklistLoggy');
}

/// Custom printer for testing, don't care about printing, just get number of logs passed
class TestPrinter extends LoggyPrinter {
  final List<LogRecord> _records = <LogRecord>[];

  @override
  void onLog(LogRecord record) {
    _records.add(record);
  }

  int get recordCalls => _records.length;
}
