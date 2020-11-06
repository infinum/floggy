part of loggy;

/// Whether to allow fine-grain logging and configuration of loggers in a
/// hierarchy.
///
/// When false, all hierarchical logging instead is merged in the root logger.
bool hierarchicalLoggingEnabled = false;

/// The default [LogLevel].
const defaultLevel = LogOptions(LogLevel.all);

/// Use a [Loggy] to log debug messages.
///
/// [Loggy]s are named using a hierarchical dot-separated name convention,
/// and their types are used to [_whitelist] or [_blacklist] specific logger types.
/// Loggy can be any type so end user can have as many or as little different [Loggy]
/// types as they want.
class Loggy<T extends LoggyType> {
  /// Singleton constructor. Calling `new Loggy(name)` will return the same
  /// actual instance whenever it is called with the same string name.
  factory Loggy(String name) =>
      _loggers.putIfAbsent(name, () => Loggy<T>._named(name)) as Loggy<T>;

  /// Creates a new detached [Loggy].
  ///
  /// Returns a new [Loggy] instance (unlike `new Loggy`, which returns a
  /// [Loggy] singleton), which doesn't have any parent or children,
  /// and is not a part of the global hierarchical loggers structure.
  ///
  /// It can be useful when you just need a local short-living logger,
  /// which you'd like to be garbage-collected later.
  factory Loggy.detached(String name) =>
      Loggy<T>._internal(name, null, <String, Loggy>{});

  factory Loggy._named(String name) {
    if (name.startsWith('.')) {
      throw ArgumentError("name shouldn't start with a '.'");
    }
    // Split hierarchical names (separated with '.').
    final dot = name.lastIndexOf('.');
    Loggy _parent;
    String thisName;
    if (dot == -1) {
      if (name != '') {
        _parent = Loggy('');
      }

      thisName = name;
    } else {
      _parent = Loggy(name.substring(0, dot));
      thisName = name.substring(dot + 1);
    }
    return Loggy<T>._internal(thisName, _parent, <String, Loggy>{});
  }

  Loggy._internal(this.name, this._parent, Map<String, Loggy> children)
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
  String get fullName => (_parent == null || _parent.name == '')
      ? name
      : '${_parent.fullName}.$name';

  /// Parent of this logger in the hierarchy of loggers.
  final Loggy _parent;

  /// Logging [LogLevel] used for entries generated on this logger.
  LogOptions _level = defaultLevel;

  /// List of [Type] types that are whitelisted.
  ///
  ///Only [Loggy] with type [Type] will be logged
  List<Type> _whitelist = <Type>[];

  /// List of [Type] types that are blacklisted.
  ///
  /// Only [Loggy] with type [Type] will NOT be logged
  List<Type> _blacklist = <Type>[];

  final Map<String, Loggy> _children;

  /// Children in the hierarchy of loggers, indexed by their simple names.
  final Map<String, Loggy> children;

  /// Controller used to notify when log entries are added to this logger.
  StreamController<LogRecord> _controller;

  Loggy get parent {
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

  /// Override the level for this particular [Loggy] and its children.
  set level(LogOptions value) {
    if (!hierarchicalLoggingEnabled && _parent != null) {
      throw UnsupportedError(
          'Please set "hierarchicalLoggingEnabled" to true if you want to '
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

  bool _isLoggable(LogLevel value) {
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
  /// message at a predefined level (e.g. [LogLevel.info], [LogLevel.warning], etc)
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
  void log(LogLevel logLevel, dynamic message,
      [Object error, StackTrace stackTrace, Zone zone, Frame callerFrame]) {
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

      if (stackTrace == null &&
          logLevel.priority >= level.stackTraceLevel.priority) {
        stackTrace = StackTrace.current;
        error ??= 'autogenerated stack trace for $logLevel $msg';
      }

      zone ??= Zone.current;
      callerFrame ??= _getCallerFrame();

      final record = LogRecord(logLevel, msg, fullName, error, stackTrace, zone,
          object, callerFrame);

      if (_parent == null) {
        _publish(record);
      } else if (!hierarchicalLoggingEnabled) {
        root._publish(record);
      } else {
        Loggy<dynamic> target = this;
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

  void debug(dynamic message, [Object error, StackTrace stackTrace]) =>
      log(LogLevel.debug, message, error, stackTrace);
  void info(dynamic message, [Object error, StackTrace stackTrace]) =>
      log(LogLevel.info, message, error, stackTrace);
  void warning(dynamic message, [Object error, StackTrace stackTrace]) =>
      log(LogLevel.warning, message, error, stackTrace);
  void error(dynamic message, [Object error, StackTrace stackTrace]) =>
      log(LogLevel.error, message, error, stackTrace);

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

  static final Loggy root = Loggy('');
  static final Map<String, Loggy> _loggers = <String, Loggy>{};

  static void initLoggy({
    LogPrinter logPrinter = const DefaultPrinter(),
    LogOptions logOptions = defaultLevel,
    List<Type> whitelist = const [],
    List<Type> blacklist = const [],
  }) {
    assert(whitelist.isEmpty || blacklist.isEmpty,
        'You can\'t pass blacklist and whitelist');

    Loggy.root.level = logOptions;
    Loggy.root.whitelist = whitelist;
    Loggy.root.blacklist = blacklist;
    Loggy.root.onRecord.listen(logPrinter.onLog);
  }
}
