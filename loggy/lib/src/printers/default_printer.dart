part of loggy;

class DefaultPrinter extends LogPrinter {
  const DefaultPrinter() : super();

  @override
  void onLog(LogRecord record) => print(record);
}
