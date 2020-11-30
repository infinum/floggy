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
      LoggyType awesome;
      Loggy.initLoggy(filters: [WhitelistFilter([])]);

      awesome = TestBlocLoggy();

      final streamSize = <LogRecord>[];
      awesome.loggy.onRecord.listen((event) => streamSize.add(event));

      awesome.loggy.info('Test log');

      // Nothing was whitelisted, we shouldn't see our log in the stream
      expect(streamSize.length, equals(0));
    });

    test('Blacklist empty filter', () async {
      LoggyType awesome;
      Loggy.initLoggy(filters: [BlacklistFilter([])]);

      awesome = TestBlocLoggy();

      final streamSize = <LogRecord>[];
      awesome.loggy.onRecord.listen((event) => streamSize.add(event));

      awesome.loggy.info('Test log');

      // Nothing was blacklisted, we should see our log in the stream
      expect(streamSize.length, equals(1));
    });
  });
}

class TestBlocLoggy with UiLoggy {}
