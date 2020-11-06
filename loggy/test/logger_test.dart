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
      awesome.logger.info('Test log');

      expect(awesome.logger.name != null, isTrue);
    });

    test('New logger', () {
      final _extraLoggy = awesome.newLoggy('extra');

      expect(_extraLoggy.fullName.contains(awesome.logger.fullName), isTrue);
    });

    test('Detached logger', () {
      final _detached = awesome.detachedLoggy('detached');

      expect(_detached.fullName.contains(awesome.logger.fullName), isFalse);
    });
  });
}

class TestBlocLoggy with UiLoggy {}
