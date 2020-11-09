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
}

class TestBlocLoggy with UiLoggy {}
