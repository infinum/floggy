import 'package:logger/logger.dart';

import 'extra_loggers.dart';
import 'wtf_level.dart';

void main() {
  Loggy.initLogger(
    logPrinter: const PrettyWtfPrinter(),
    logOptions: const LogOptions(LogLevel.all),
    blacklist: [BlacklistedLogger],
  );

  ExampleNetworkLogger();
  ExampleUiLogger();
  ExampleBlackListedLogger();
  ExampleWhatLoggersCanDo();

  SmallClassWithoutLogger();
}

class SmallClassWithoutLogger {
  SmallClassWithoutLogger() {
    Loggy.root.info('You can log like this! But no class name :(');
  }
}

class ExampleNetworkLogger with NetworkLogger {
  ExampleNetworkLogger() {
    logger.debug('This is log from Network logger');
    logger.info('This is log from Network logger');
    logger.warning('This is log from Network logger');
    logger.error('This is log from Network logger');

    logger.wtf('This is log with custom log level in Network logger');
  }
}

class ExampleUiLogger with UiLogger {
  ExampleUiLogger() {
    logger.warning('This is log from UI logger');
    logger.warning('This is log from UI logger');
    logger.warning('This is log from UI logger');
    logger.warning('This is log from UI logger');

    logger.wtf('This is log with custom log level in UI logger');
  }
}

class ExampleBlackListedLogger with BlacklistedLogger {
  ExampleBlackListedLogger() {
    logger
        .info('This log is from Blacklisted logger and should not be visible!');
    logger.warning(
        'This log is from Blacklisted logger and should not be visible!');
  }
}

class ExampleWhatLoggersCanDo with ExampleLogger {
  ExampleWhatLoggersCanDo() {
    /// This will evaluate only if line is actually logged
    logger.info('Loggers can do some stuff:');
    logger.info(
        'You can pass function to the logger, it will evaluate only if log gets shown');
    logger.debug(() {
      /// You can log in log
      logger.warning('Using logger inside of the logger #WeNeedToGoDeeper');

      /// Do something here maybe?
      return [1, 2, 3, 4, 5].map((e) => e * 4).join('-');
    });

    logger.info(() {
      /// You can do what you want here!
      const _s = 0 / 0;
      return List.generate(10, (_) => _s).fold<String>('',
              (previousValue, element) => previousValue += element.toString()) +
          ' Batman';
    });

    void _insideLogger() {
      final _logger = newLogger('Test');

      /// This only works if [Logger.hierarchicalLoggingEnabled] is set to true
      // _logger.level = LogLevel(Level.all);
      _logger.debug(
          'I\'m new logger called "${_logger.name}" and my parent logger name is "${_logger.parent.name}"');
      _logger.debug(
          'Even if I\'m a new logger, I still share everything with my parent');
    }

    void _detachedLogger() {
      final _logger = detachedLogger('Detached logger');
      _logger.level = const LogOptions(LogLevel.all);
      _logger.onRecord.listen((event) {
        print(event);
      });
      _logger.debug(
          'I\'m a detached logger. I don\'t have a parent and I have no connection or shared info with root logger!');
    }

    _insideLogger();
    _detachedLogger();
  }
}
