import 'package:loggy/loggy.dart';
import 'package:test/test.dart';

void main() {
  group('Logger test', () {
    LoggyType awesome;

    setUp(() {
      Loggy.initLogger();
      awesome = TestBlocLogger();
    });

    test('Logger has name', () {
      awesome.logger.info('Test log');

      expect(awesome.logger.name != null, isTrue);
    });

    test('New logger', () {
      final _extraLogger = awesome.newLoggy('extra');

      expect(_extraLogger.fullName.contains(awesome.logger.fullName), isTrue);
    });

    test('Detached logger', () {
      final _detached = awesome.detachedLoggy('detached');

      expect(_detached.fullName.contains(awesome.logger.fullName), isFalse);
    });
  });
}

class TestBlocLogger with UiLogger {}
