import 'package:loggy/loggy.dart';

import 'extra_loggers.dart';
import 'socket_level.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(),
    logOptions: const LogOptions(
      LogLevel.all,
      // includeCallerInfo: false,
      // stackTraceLevel: LogLevel.error,
    ),
    filters: [
      BlacklistFilter([BlacklistedLoggy]),
    ],
  );

  MyApp();

  ExampleNetworkLoggy();
  ExampleUiLoggy();
  ExampleBlackListedLoggy();
  ExampleWhatLoggyCanDo();

  SmallClassWithoutLoggy();
}

class SmallClassWithoutLoggy {
  SmallClassWithoutLoggy() {
    Loggy.root.info('You can log like this! But no class name :(');
  }
}

class ExampleNetworkLoggy with NetworkLoggy {
  ExampleNetworkLoggy() {
    loggy.debug('This is log from Network logger');
    loggy.info('This is log from Network logger');
    loggy.warning('This is log from Network logger');
    loggy.error('This is log from Network logger');

    loggy.socket('This is log with custom log level in Network logger');
  }
}

class ExampleUiLoggy with UiLoggy {
  ExampleUiLoggy() {
    loggy.warning('This is log from UI logger');
    loggy.warning('This is log from UI logger');
    loggy.warning('This is log from UI logger');
    loggy.warning('This is log from UI logger');

    loggy.socket('This is log with custom log level in UI logger');
  }
}

class MyApp with UiLoggy {
  MyApp() {
    loggy.debug('This is debug message');
    loggy.info('This is info message');
    loggy.warning('This is warning message');
    loggy.error('This is error message');
  }
}

class ExampleBlackListedLoggy with BlacklistedLoggy {
  ExampleBlackListedLoggy() {
    loggy.info('This log is from Blacklisted logger and should not be visible!');
    loggy.warning('This log is from Blacklisted logger and should not be visible!');
  }
}

class ExampleWhatLoggyCanDo with ExampleLoggy {
  ExampleWhatLoggyCanDo() {
    /// This will evaluate only if line is actually logged
    loggy.info('Loggys can do some stuff:');
    loggy.info('You can pass function to the logger, it will evaluate only if log gets shown');
    loggy.debug(() {
      /// You can log in log
      loggy.warning('Using logger inside of the logger #WeNeedToGoDeeper');

      /// Do something here maybe?
      return [1, 2, 3, 4, 5].map((e) => e * 4).join('-');
    });

    loggy.info(() {
      /// You can do what you want here!
      const _s = 0 / 0;
      return List.generate(10, (_) => _s)
              .fold<String>('', (previousValue, element) => previousValue += element.toString()) +
          ' Batman';
    });

    void _insideLoggy() {
      final _logger = newLoggy('Test');

      /// This only works if [Loggy.hierarchicalLoggingEnabled] is set to true
      // _logger.level = LogLevel(Level.all);
      _logger.debug('I\'m new logger called "${_logger.name}" and my parent logger name is "${_logger.parent.name}"');
      _logger.debug('Even if I\'m a new logger, I still share everything with my parent');
    }

    void _detachedLoggy() {
      final _logger = detachedLoggy('Detached logger');
      _logger.level = const LogOptions(LogLevel.all);
      _logger.onRecord.listen((event) {
        print(event);
      });
      _logger.debug(
          'I\'m a detached logger. I don\'t have a parent and I have no connection or shared info with root logger!');
    }

    _insideLoggy();
    _detachedLoggy();
  }
}
