part of logger;

/// Whether to allow fine-grain logging and configuration of loggers in a
/// hierarchy.
///
/// When false, all hierarchical logging instead is merged in the root logger.
bool hierarchicalLoggingEnabled = false;

/// The default [Level].
const defaultLevel = LogOptions(Level.all);

/// Use a [Logger] to log debug messages.
///
/// [Logger]s are named using a hierarchical dot-separated name convention,
/// and their types are used to [_whitelist] or [_blacklist] specific logger types.
/// Logger can be any type so end user can have as many or as little different [Logger]
/// types as they want.
class Logger<T extends LoggerType> {
  /// Singleton constructor. Calling `new Logger(name)` will return the same
  /// actual instance whenever it is called with the same string name.
  factory Logger(String name) => _loggers.putIfAbsent(name, () => Logger<T>._named(name)) as Logger<T>;

  /// Creates a new detached [Logger].
  ///
  /// Returns a new [Logger] instance (unlike `new Logger`, which returns a
  /// [Logger] singleton), which doesn't have any parent or children,
  /// and is not a part of the global hierarchical loggers structure.
  ///
  /// It can be useful when you just need a local short-living logger,
  /// which you'd like to be garbage-collected later.
  factory Logger.detached(String name) => Logger<T>._internal(name, null, <String, Logger>{});

  factory Logger._named(String name) {
    if (name.startsWith('.')) {
      throw ArgumentError("name shouldn't start with a '.'");
    }
    // Split hierarchical names (separated with '.').
    final dot = name.lastIndexOf('.');
    Logger _parent;
    String thisName;
    if (dot == -1) {
      if (name != '') {
        _parent = Logger('');
      }

      thisName = name;
    } else {
      _parent = Logger(name.substring(0, dot));
      thisName = name.substring(dot + 1);
    }
    return Logger<T>._internal(thisName, _parent, <String, Logger>{});
  }

  Logger._internal(this.name, this._parent, Map<String, Logger> children)
      : _children = children,
        children = UnmodifiableMapView(children) {
    if (_parent == null) {
      _level = defaultLevel;
    } else {
      _parent._children[name] = this;
    }
  }

  /// Simple name of this logger.
  final String name;

  /// The full name of this logger, which includes the parent's full name.
  String get fullName => (_parent == null || _parent.name == '') ? name : '${_parent.fullName}.$name';

  /// Parent of this logger in the hierarchy of loggers.
  final Logger _parent;

  /// Logging [Level] used for entries generated on this logger.
  LogOptions _level;

  /// List of [Type] types that are whitelisted.
  ///
  ///Only [Logger] with type [Type] will be logged
  List<Type> _whitelist;

  /// List of [Type] types that are blacklisted.
  ///
  /// Only [Logger] with type [Type] will NOT be logged
  List<Type> _blacklist;

  final Map<String, Logger> _children;

  /// Children in the hierarchy of loggers, indexed by their simple names.
  final Map<String, Logger> children;

  /// Controller used to notify when log entries are added to this logger.
  StreamController<LogRecord> _controller;

  Logger get parent {
    if (_parent != null) {
      return _parent;
    }

    return this;
  }

  /// Effective level considering the levels established in this logger's
  /// parents (when [hierarchicalLoggingEnabled] is true).
  LogOptions get level {
    LogOptions effectiveLevel;

    if (_parent == null) {
      // We're either the root logger or a detached logger.  Return our own
      // level.
      effectiveLevel = _level;
    } else if (!hierarchicalLoggingEnabled) {
      effectiveLevel = root._level;
    } else {
      effectiveLevel = _level ?? _parent.level;
    }

    assert(effectiveLevel != null);
    return effectiveLevel;
  }

  /// Override the level for this particular [Logger] and its children.
  set level(LogOptions value) {
    if (!hierarchicalLoggingEnabled && _parent != null) {
      throw UnsupportedError('Please set "hierarchicalLoggingEnabled" to true if you want to '
          'change the level on a non-root logger.');
    }
    _level = value;
  }

  /// Put logger types on whitelist.
  /// This will only send logs from passed types
  set whitelist(List<Type> whitelist) {
    _whitelist = whitelist;
  }

  /// Put logger types on blacklist.
  /// This will send all logs except from passed types
  set blacklist(List<Type> blacklist) {
    _blacklist = blacklist;
  }

  /// Connect to logger stream
  Stream<LogRecord> get onRecord => _getStream();

  void clearListeners() {
    if (hierarchicalLoggingEnabled || _parent == null) {
      if (_controller != null) {
        _controller.close();
        _controller = null;
      }
    } else {
      root.clearListeners();
    }
  }

  bool _isLoggable(Level value) {
    if (value.priority >= level.logLevel.priority) {
      if ((root._whitelist.isEmpty || root._whitelist.contains(T)) &&
          (root._blacklist.isEmpty || !root._blacklist.contains(T))) {
        return true;
      }
    }

    return false;
  }

  /// Adds a log record for a [message] at a particular [logLevel] if
  /// `isLoggable(logLevel)` is true.
  ///
  /// Use this method to create log entries for user-defined levels. To record a
  /// message at a predefined level (e.g. [Level.info], [Level.warning], etc)
  /// you can use their specialized methods instead (e.g. [info], [warning],
  /// etc).
  ///
  /// If [message] is a [Function], it will be lazy evaluated. Additionally, if
  /// [message] or its evaluated value is not a [String], then 'toString()' will
  /// be called on the object and the result will be logged. The log record will
  /// contain a field holding the original object.
  ///
  /// The log record will also contain a field for the zone in which this call
  /// was made. This can be advantageous if a log listener wants to handler
  /// records of different zones differently (e.g. group log records by HTTP
  /// request if each HTTP request handler runs in it's own zone).
  void log(Level logLevel, dynamic message, [Object error, StackTrace stackTrace, Zone zone, Frame callerFrame]) {
    Object object;
    if (_isLoggable(logLevel)) {
      if (message is Function) {
        message = message();
      }

      String msg;
      if (message is String) {
        msg = message;
      } else {
        msg = message.toString();
        object = message;
      }

      if (stackTrace == null && logLevel.priority >= level.stackTraceLevel.priority) {
        stackTrace = StackTrace.current;
        error ??= 'autogenerated stack trace for $logLevel $msg';
      }

      zone ??= Zone.current;
      callerFrame ??= _getCallerFrame();

      final record = LogRecord(logLevel, msg, fullName, error, stackTrace, zone, object, callerFrame);

      if (_parent == null) {
        _publish(record);
      } else if (!hierarchicalLoggingEnabled) {
        root._publish(record);
      } else {
        Logger<dynamic> target = this;
        while (target != null) {
          target._publish(record);
          target = target._parent;
        }
      }
    }
  }

  Frame _getCallerFrame() {
    if (!level.includeCallerInfo) {
      return null;
    }

    const _level = 3;
    // Expensive
    final frames = Trace.current(_level).frames;
    return frames.isEmpty ? null : frames.first;
  }

  void debug(dynamic message, [Object error, StackTrace stackTrace]) => log(Level.debug, message, error, stackTrace);
  void info(dynamic message, [Object error, StackTrace stackTrace]) => log(Level.info, message, error, stackTrace);
  void warning(dynamic message, [Object error, StackTrace stackTrace]) =>
      log(Level.warning, message, error, stackTrace);
  void error(dynamic message, [Object error, StackTrace stackTrace]) => log(Level.error, message, error, stackTrace);

  Stream<LogRecord> _getStream() {
    if (hierarchicalLoggingEnabled || _parent == null) {
      _controller ??= StreamController<LogRecord>.broadcast(sync: true);
      return _controller.stream;
    } else {
      return root._getStream();
    }
  }

  void _publish(LogRecord record) {
    if (_controller != null) {
      _controller.add(record);
    }
  }

  static final Logger root = Logger('');
  static final Map<String, Logger> _loggers = <String, Logger>{};

  static void initLogger({
    LogPrinter logPrinter = const DefaultPrinter(),
    LogOptions logLevel = defaultLevel,
    List<Type> whitelist = const [],
    List<Type> blacklist = const [],
  }) {
    Logger.root.level = logLevel;
    Logger.root.whitelist = whitelist;
    Logger.root.blacklist = blacklist;
    Logger.root.onRecord.listen(logPrinter.onLog);
  }
}
