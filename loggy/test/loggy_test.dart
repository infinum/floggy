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
      Loggy.initLoggy(filters: [WhitelistFilter([])]);
      final awesome = TestBlocLoggy();

      final streamSize = <LogRecord>[];
      Loggy.root.onRecord.listen((event) => streamSize.add(event));

      awesome.loggy.info('Test log');

      // Nothing was whitelisted, we shouldn't see our log in the stream
      expect(streamSize.length, equals(0));
    });

    test('Whitelist filter', () async {
      Loggy.initLoggy(filters: [
        WhitelistFilter([WhitelistLoggy])
      ]);

      final testLoggy = TestBlocLoggy();
      final whiteListLoggy = WhitelistTestBlocLoggy();

      final streamSize = <LogRecord>[];
      Loggy.root.onRecord.listen((event) => streamSize.add(event));

      testLoggy.loggy.info('Test log');
      whiteListLoggy.loggy.info('Whitelist log');

      // Only whitelist loggy should be shown
      expect(streamSize.length, equals(1));
    });

    test('Blacklist empty filter', () async {
      Loggy.initLoggy(filters: [BlacklistFilter([])]);

      final awesome = TestBlocLoggy();

      final streamSize = <LogRecord>[];
      Loggy.root.onRecord.listen((event) => streamSize.add(event));

      awesome.loggy.info('Test log');

      // Nothing was blacklisted, we should see our log in the stream
      expect(streamSize.length, equals(1));
    });

    test('Blacklist filter', () async {
      Loggy.initLoggy(filters: [
        WhitelistFilter([BlacklistLoggy])
      ]);

      final testLoggy = TestBlocLoggy();
      final blacklistLoggy = BlacklistTestBlocLoggy();

      final streamSize = <LogRecord>[];
      Loggy.root.onRecord.listen((event) => streamSize.add(event));

      testLoggy.loggy.info('Test log');
      blacklistLoggy.loggy.info('Blacklist log');

      // Only log not in blacklist should be shown
      expect(streamSize.length, equals(1));
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
