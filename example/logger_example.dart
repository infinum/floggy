import 'package:logger/logger.dart';

import 'extra_loggers.dart';
import 'wtf_level.dart';

void main() {
  Logger.initLogger(
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
    Logger.root.info('You can log like this! But no class name :(');
  }
}

class ExampleNetworkLogger with NetworkLogger {
  ExampleNetworkLogger() {
    log.debug('This is log from Network logger');
    log.info('This is log from Network logger');
    log.warning('This is log from Network logger');
    log.error('This is log from Network logger');

    log.wtf('This is log with custom log level in Network logger');
  }
}

class ExampleUiLogger with UiLogger {
  ExampleUiLogger() {
    log.warning('This is log from UI logger');
    log.warning('This is log from UI logger');
    log.warning('This is log from UI logger');
    log.warning('This is log from UI logger');

    log.wtf('This is log with custom log level in UI logger');
  }
}

class ExampleBlackListedLogger with BlacklistedLogger {
  ExampleBlackListedLogger() {
    log.info('This log is from Blacklisted logger and should not be visible!');
    log.warning('This log is from Blacklisted logger and should not be visible!');
  }
}

class ExampleWhatLoggersCanDo with ExampleLogger {
  ExampleWhatLoggersCanDo() {
    /// This will evaluate only if line is actually logged
    log.info('Loggers can do some stuff:');
    log.info('You can pass function to the logger, it will evaluate only if log gets shown');
    log.debug(() {
      /// You can log in log
      log.warning('Using logger inside of the logger #WeNeedToGoDeeper');

      /// Do something here maybe?
      return [1, 2, 3, 4, 5].map((e) => e * 4).join('-');
    });

    log.info(() {
      /// You can do what you want here!
      const _s = 0 / 0;
      return List.generate(10, (_) => _s)
              .fold<String>('', (previousValue, element) => previousValue += element.toString()) +
          ' Batman';
    });

    void _insideLogger() {
      final _logger = logger('Test');

      /// This only works if [Logger.hierarchicalLoggingEnabled] is set to true
      // _logger.level = LogLevel(Level.all);
      _logger.debug('I\'m new logger called "${_logger.name}" and my parent logger name is "${_logger.parent.name}"');
      _logger.debug('Even if I\'m a new logger, I still share everything with my parent');
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
