import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group('Logger test', () {
    LoggerType awesome;

    setUp(() {
      Logger.initLogger();
      awesome = TestBlocLogger();
    });

    test('Logger has name', () {
      awesome.logger.info('Test log');

      expect(awesome.logger.name != null, isTrue);
    });

    test('New logger', () {
      final _extraLogger = awesome.newLogger('extra');

      expect(_extraLogger.fullName.contains(awesome.logger.fullName), isTrue);
    });

    test('Detached logger', () {
      final _detached = awesome.detachedLogger('detached');

      expect(_detached.fullName.contains(awesome.logger.fullName), isFalse);
    });
  });
}

class TestBlocLogger with UiLogger {}
