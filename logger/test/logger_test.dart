import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    LoggerType awesome;

    setUp(() {
      awesome = TestBlocLogger();
    });

    test('First Test', () {
      awesome.logger.info('Test log');

      expect(awesome.logger.name != null, isTrue);
    });
  });
}

class TestBlocLogger with UiLogger {}
