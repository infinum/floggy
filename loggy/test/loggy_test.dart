import 'package:loggy/loggy.dart';
import 'package:test/test.dart';

import 'test_customizations.dart';

void main() {
  group('Loggy test', () {
    LoggyType loggy;

    setUp(() {
      Loggy.initLoggy();
      loggy = TestBlocLoggy();
    });

    test('Loggy has name', () {
      expect(loggy.loggy.name != null, isTrue);
    });

    test('New logger has parent name in title', () {
      final _extraLoggy = loggy.newLoggy('extra');
      expect(_extraLoggy.fullName.contains(loggy.loggy.fullName), isTrue);
    });

    test('Detached logger has no parent', () {
      final _detached = loggy.detachedLoggy('detached');
      expect(_detached.fullName.contains(loggy.loggy.fullName), isFalse);
    });
  });
  group('Detached Loggy', () {
    test('Detached loggy has separate printer', () {
      final _mainPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: _mainPrinter);

      final _log = TestBlocLoggy();

      final _detached = _log.detachedLoggy('detached');
      final _testPrinter = TestPrinter();

      _detached.printer = _testPrinter;

      _detached.info('Detached message');

      expect(_testPrinter.recordCalls, 1);
      expect(_mainPrinter.recordCalls, 0);
    });

    test('Detached loggy is not following parent filters', () {
      final _mainPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: _mainPrinter, filters: [WhitelistFilter([])]);

      final _log = TestBlocLoggy();
      final _detached = _log.detachedLoggy('detached');
      final _testPrinter = TestPrinter();

      _detached.printer = _testPrinter;

      _detached.info('Detached message');

      expect(_testPrinter.recordCalls, 1);
      expect(_mainPrinter.recordCalls, 0);
    });

    test('Detached loggy is not following parent levels', () {
      final _mainPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: _mainPrinter, logOptions: LogOptions(LogLevel.off));

      final _log = TestBlocLoggy();
      final _detached = _log.detachedLoggy('detached');
      final _testPrinter = TestPrinter();

      _detached.printer = _testPrinter;

      _detached.info('Detached message');

      expect(_testPrinter.recordCalls, 1);
      expect(_mainPrinter.recordCalls, 0);
    });
  });
  group('Named Loggy test', () {
    test('Named loggy uses same printer as parent', () {
      final _testPrinter = TestPrinter();
      Loggy.initLoggy(
        logPrinter: _testPrinter,
      );
      final _log = TestBlocLoggy();
      final _named = _log.newLoggy('namedLoggy');

      _named.info('Named message');
      _log.loggy.info('Named message');

      expect(_testPrinter.recordCalls, 2);
    });

    test('Named loggy is following parent filters', () {
      final _testPrinter = TestPrinter();
      Loggy.initLoggy(
        logPrinter: _testPrinter,
        filters: [
          BlacklistFilter([UiLoggy])
        ],
      );

      final _log = TestBlocLoggy();
      final _named = _log.newLoggy('namedLoggy');

      _named.info('Named message');
      _log.loggy.info('Named message');

      expect(_testPrinter.recordCalls, 0);
    });

    test('Named loggy is following parent levels', () {
      final _testPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: _testPrinter, logOptions: LogOptions(LogLevel.off));
      final _log = TestBlocLoggy();
      final _named = _log.newLoggy('namedLoggy');

      _named.info('Named message');
      _log.loggy.info('Named message');

      expect(_testPrinter.recordCalls, 0);
    });
  });
}
