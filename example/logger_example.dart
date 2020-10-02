import 'package:logger/logger.dart';

void main() {
  Logger.initLogger(
    logPrinter: const PrettyPrinter(),
    logLevel: const LogLevel(
      Level.all,
      includeCallerInfo: true,
    ),
    blacklist: [BlacklistedLogger],
  );

  ExampleNetworkLogger();
  ExampleUiLogger();
  ExampleBlackListedLogger();
  ExampleWhatLoggersCanDo();
}

class ExampleNetworkLogger with NetworkLogger {
  ExampleNetworkLogger() {
    log.debug('This is log from Network logger');
    log.info('This is log from Network logger');
    log.warning('This is log from Network logger');
    log.error('This is log from Network logger');
  }
}

class ExampleUiLogger with UiLogger {
  ExampleUiLogger() {
    log.warning('This is log from UI logger');
    log.warning('This is log from UI logger');
    log.warning('This is log from UI logger');
    log.warning('This is log from UI logger');
  }
}

class ExampleBlackListedLogger with BlacklistedLogger {
  ExampleBlackListedLogger() {
    log.info('This log is from Blacklisted logger!');
    log.warning('This log is from Blacklisted logger!');
  }
}

class ExampleWhatLoggersCanDo with ExampleLogger {
  ExampleWhatLoggersCanDo() {
    /// This will evaluate only if line is actually logged
    log.debug(() {
      /// You can log in log
      log.warning('Proof!');

      /// Do something here maybe?
      return [1, 2, 3, 4, 5].map((e) => e * 4).join('-');
    });

    void _insideLogger() {
      final _logger = logger('Test');

      /// This only works if [Logger.hierarchicalLoggingEnabled] is set to true
      // _logger.level = LogLevel(Level.all);
      _logger.debug('This is from inside function!');
      _logger.parent.debug('This is from inside function!');
    }

    void _detachedLogger() {
      final _logger = detachedLogger('Detached logger');
      _logger.level = const LogLevel(Level.all);
      _logger.onRecord.listen((event) {
        print(event);
      });
      _logger.debug('This is detached logger from inside the function, no connection or shared info from root logger!');
    }

    _insideLogger();
    _detachedLogger();
  }
}
