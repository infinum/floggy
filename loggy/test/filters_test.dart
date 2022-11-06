import 'package:loggy/loggy.dart';
import 'package:test/test.dart';

import 'test_customizations.dart';

void main() {
  group('Loggy filters test', () {
    group('Whitelist filter', () {
      test('Empty filter', () async {
        final testPrinter = TestPrinter();
        Loggy.initLoggy(
            logPrinter: testPrinter, filters: [WhitelistFilter([])]);
        final whitelistEmpty = TestBlocLoggy();

        whitelistEmpty.loggy.info('Test log');

        // Nothing was whitelisted, we shouldn't see our log in the stream
        expect(testPrinter.recordCalls, equals(0));
      });

      test('WhitelistLoggy', () async {
        final testPrinter = TestPrinter();

        Loggy.initLoggy(logPrinter: testPrinter, filters: [
          WhitelistFilter([WhitelistLoggy])
        ]);

        final testLoggy = TestBlocLoggy();
        final whiteListLoggy = WhitelistTestBlocLoggy();

        testLoggy.loggy.info('Test log');
        testLoggy.loggy.info('Test log');
        whiteListLoggy.loggy.info('Whitelist log');

        // Only whitelist loggy should be shown
        expect(testPrinter.recordCalls, equals(1));
      });
    });
    group('Blacklist filter', () {
      test('Empty filter', () async {
        final testPrinter = TestPrinter();
        Loggy.initLoggy(
            logPrinter: testPrinter, filters: [BlacklistFilter([])]);
        final blacklistEmpty = TestBlocLoggy();

        blacklistEmpty.loggy.info('Test log');

        // Nothing was blacklisted, we should see our log in the stream
        expect(testPrinter.recordCalls, equals(1));
      });

      test('BlacklistLoggy', () async {
        final testPrinter = TestPrinter();
        Loggy.initLoggy(logPrinter: testPrinter, filters: [
          BlacklistFilter([BlacklistLoggy])
        ]);

        final testLoggy = TestBlocLoggy();
        final blacklistLoggy = BlacklistTestBlocLoggy();

        testLoggy.loggy.info('Test log');
        blacklistLoggy.loggy.info('Blacklist log');
        blacklistLoggy.loggy.info('Blacklist log');

        // Only test loggy should be shown
        expect(testPrinter.recordCalls, equals(1));
      });
    });
    group('Custom level filter', () {
      test('Empty filter', () async {
        final testPrinter = TestPrinter();
        Loggy.initLoggy(
            logPrinter: testPrinter,
            filters: [CustomLevelFilter(LogLevel.error, [])]);
        final customLevelFilter = TestBlocLoggy();

        customLevelFilter.loggy.info('Test log');

        expect(testPrinter.recordCalls, equals(1));
      });

      test('Custom level', () async {
        final testPrinter = TestPrinter();
        Loggy.initLoggy(logPrinter: testPrinter, filters: [
          CustomLevelFilter(LogLevel.warning, [BlacklistLoggy])
        ]);

        final testLoggy = TestBlocLoggy();
        final customLevel = BlacklistTestBlocLoggy();

        testLoggy.loggy.info('Test log');
        testLoggy.loggy.info('Test log');
        customLevel.loggy.warning('Custom level log');
        customLevel.loggy.info('Custom level log');

        expect(testPrinter.recordCalls, equals(3));
      });
    });
  });
}
