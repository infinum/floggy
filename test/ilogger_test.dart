import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    LoggerType awesome;

    setUp(() {
      awesome = TestBlocLogger();
    });

    test('First Test', () {
      awesome.log.info('Test log');

      expect(awesome.log.name != null, isTrue);
    });
  });
}

class TestBlocLogger with UiLogger {}
