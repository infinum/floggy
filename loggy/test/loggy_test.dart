import 'package:loggy/loggy.dart';
import 'package:test/test.dart';

void main() {
  group('Loggy test', () {
    LoggyType awesome;

    setUp(() {
      Loggy.initLoggy();
      awesome = TestBlocLoggy();
    });

    test('Loggy has name', () {
      awesome.loggy.info('Test log');

      expect(awesome.loggy.name != null, isTrue);
    });

    test('New logger', () {
      final _extraLoggy = awesome.newLoggy('extra');

      expect(_extraLoggy.fullName.contains(awesome.loggy.fullName), isTrue);
    });

    test('Detached logger', () {
      final _detached = awesome.detachedLoggy('detached');

      expect(_detached.fullName.contains(awesome.loggy.fullName), isFalse);
    });
  });

  group('Loggy filters test', () {
    test('Whitelist empty filter', () async {
      final _testPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: _testPrinter, filters: [WhitelistFilter([])]);
      final whitelistEmpty = TestBlocLoggy();

      whitelistEmpty.loggy.info('Test log');

      // Nothing was whitelisted, we shouldn't see our log in the stream
      expect(_testPrinter.recordCalls, equals(0));
    });

    test('Whitelist filter', () async {
      final _testPrinter = TestPrinter();

      Loggy.initLoggy(logPrinter: _testPrinter, filters: [
        WhitelistFilter([WhitelistLoggy])
      ]);

      final testLoggy = TestBlocLoggy();
      final whiteListLoggy = WhitelistTestBlocLoggy();

      testLoggy.loggy.info('Test log');
      whiteListLoggy.loggy.info('Whitelist log');

      // Only whitelist loggy should be shown
      expect(_testPrinter.recordCalls, equals(1));
    });

    test('Blacklist empty filter', () async {
      final _testPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: _testPrinter, filters: [BlacklistFilter([])]);
      final blacklistEmpty = TestBlocLoggy();

      blacklistEmpty.loggy.info('Test log');

      // Nothing was blacklisted, we should see our log in the stream
      expect(_testPrinter.recordCalls, equals(1));
    });

    test('Blacklist filter', () async {
      final _testPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: _testPrinter, filters: [
        WhitelistFilter([BlacklistLoggy])
      ]);

      final testLoggy = TestBlocLoggy();
      final blacklistLoggy = BlacklistTestBlocLoggy();

      testLoggy.loggy.info('Test log');
      blacklistLoggy.loggy.info('Blacklist log');

      // Only log not in blacklist should be shown
      expect(_testPrinter.recordCalls, equals(1));
    });
  });

  group('Detached Loggy test', () {
    test('Detached loggy', () {
      Loggy.initLoggy();
      final _log = TestBlocLoggy();

      final _detached = _log.detachedLoggy('detached');

      final _testPrinter = TestPrinter();
      _detached.printer = _testPrinter;

      _detached.info('Detached message');

      expect(_testPrinter.recordCalls, 1);
    });

    test('Detached loggy is not following root filters', () {
      Loggy.initLoggy(filters: [WhitelistFilter([])]);
      final _log = TestBlocLoggy();

      final _detached = _log.detachedLoggy('detached');

      final _testPrinter = TestPrinter();
      _detached.printer = _testPrinter;

      _detached.info('Detached message');

      expect(_testPrinter.recordCalls, 1);
    });

    test('Detached loggy is not following root levels', () {
      Loggy.initLoggy(logOptions: LogOptions(LogLevel.off));
      final _log = TestBlocLoggy();

      final _detached = _log.detachedLoggy('detached');

      final _testPrinter = TestPrinter();
      _detached.printer = _testPrinter;

      _detached.info('Detached message');

      expect(_testPrinter.recordCalls, 1);
    });
  });
}

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

class TestPrinter extends LogPrinter {
  final List<LogRecord> _records = <LogRecord>[];

  @override
  void onLog(LogRecord record) {
    _records.add(record);
  }

  int get recordCalls => _records.length;
}
