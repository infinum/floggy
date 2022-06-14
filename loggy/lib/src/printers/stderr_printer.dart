part of loggy;

class StderrPrinter extends LoggyPrinter {
  const StderrPrinter() : super();

  @override
  void onLog(LogRecord record) => stderr.writeln(record);
}
