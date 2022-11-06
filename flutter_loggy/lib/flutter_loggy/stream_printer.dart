part of flutter_loggy;

/// Stream printer will take another [LoggyPrinter] as it's [childPrinter] all logs will
/// pass through [childPrinter] as well.
///
/// This allows [LoggyStreamWidget] to display logs as well.
class StreamPrinter extends LoggyPrinter {
  StreamPrinter(this.childPrinter) : super();

  final LoggyPrinter childPrinter;
  final BehaviorSubject<List<LogRecord>> logRecord =
      BehaviorSubject<List<LogRecord>>.seeded(<LogRecord>[]);

  @override
  void onLog(LogRecord record) {
    late List<LogRecord> existingRecord;
    try {
      existingRecord = logRecord.value;
    } on ValueStreamError {
      existingRecord = <LogRecord>[];
    }

    childPrinter.onLog(record);
    logRecord.add(<LogRecord>[
      record,
      ...existingRecord,
    ]);
  }

  void dispose() {
    logRecord.close();
  }
}
