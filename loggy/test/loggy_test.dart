import 'package:loggy/loggy.dart';
import 'package:test/test.dart';

import 'test_customizations.dart';

void main() {
  group('Loggy test', () {
    late LoggyType loggy;

    setUp(() {
      Loggy.initLoggy();
      loggy = TestBlocLoggy();
    });

    test('New logger has parent name in title', () {
      final extraLoggy = loggy.newLoggy('extra');
      expect(extraLoggy.fullName.contains(loggy.loggy.fullName), isTrue);
    });

    test('Detached logger has no parent', () {
      final detached = loggy.detachedLoggy('detached');
      expect(detached.fullName.contains(loggy.loggy.fullName), isFalse);
    });
  });
  group('Detached Loggy', () {
    test('Detached loggy has separate printer', () {
      final mainPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: mainPrinter);

      final log = TestBlocLoggy();

      final testPrinter = TestPrinter();
      final detached = log.detachedLoggy('detached', logPrinter: testPrinter);

      detached.info('Detached message');

      expect(testPrinter.recordCalls, 1);
      expect(mainPrinter.recordCalls, 0);
    });

    test('Detached loggy is not following parent filters', () {
      final mainPrinter = TestPrinter();
      Loggy.initLoggy(logPrinter: mainPrinter, filters: [WhitelistFilter([])]);

      final log = TestBlocLoggy();
      final testPrinter = TestPrinter();
      final detached = log.detachedLoggy('detached', logPrinter: testPrinter);

      detached.info('Detached message');

      expect(testPrinter.recordCalls, 1);
      expect(mainPrinter.recordCalls, 0);
    });

    test('Detached loggy is not following parent levels', () {
      final mainPrinter = TestPrinter();
      Loggy.initLoggy(
          logPrinter: mainPrinter, logOptions: LogOptions(LogLevel.off));

      final log = TestBlocLoggy();
      final testPrinter = TestPrinter();
      final detached = log.detachedLoggy('detached', logPrinter: testPrinter);

      detached.info('Detached message');

      expect(testPrinter.recordCalls, 1);
      expect(mainPrinter.recordCalls, 0);
    });
  });
  group('Named Loggy test', () {
    test('Named loggy uses same printer as parent', () {
      final testPrinter = TestPrinter();
      Loggy.initLoggy(
        logPrinter: testPrinter,
      );
      final log = TestBlocLoggy();
      final named = log.newLoggy('namedLoggy');

      named.info('Named message');
      log.loggy.info('Named message');

      expect(testPrinter.recordCalls, 2);
    });

    test('Named loggy is following parent filters', () {
      final testPrinter = TestPrinter();
      Loggy.initLoggy(
        logPrinter: testPrinter,
        filters: [
          BlacklistFilter([UiLoggy])
        ],
      );

      final log = TestBlocLoggy();
      final named = log.newLoggy('namedLoggy');

      named.info('Named message');
      log.loggy.info('Named message');

      expect(testPrinter.recordCalls, 0);
    });

    test('Named loggy is following parent levels', () {
      final testPrinter = TestPrinter();
      Loggy.initLoggy(
          logPrinter: testPrinter, logOptions: LogOptions(LogLevel.off));
      final log = TestBlocLoggy();
      final named = log.newLoggy('namedLoggy');

      named.info('Named message');
      log.loggy.info('Named message');

      expect(testPrinter.recordCalls, 0);
    });
  });
}
