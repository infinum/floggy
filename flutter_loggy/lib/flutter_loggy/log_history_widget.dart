part of flutter_loggy;

class LogHistoryWidget extends StatelessWidget {
  LogHistoryWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoryPrinter _printer = Loggy.currentPrinter is HistoryPrinter ? Loggy.currentPrinter : null;

    if (_printer == null) {
      return Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning),
              SizedBox(
                width: 12.0,
              ),
              Text(
                'Printer is not set as HistoryLogger!',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      child: StreamBuilder<List<LogRecord>>(
        stream: _printer.logRecord,
        builder: (context, records) {
          if (!records.hasData) {
            return Container();
          }

          return ListView(
            reverse: true,
            children: records.data.reversed.map((e) => LogItem(e)).toList(),
          );
        },
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  LogItem(this.record, {Key key}) : super(key: key);

  final LogRecord record;

  @override
  Widget build(BuildContext context) {
    Color logColor = _getLogColor();
    final _time = record.time.toIso8601String().split('T')[1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _time,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: logColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                    ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                record.message,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: logColor,
                      fontWeight: _getTextWeight(),
                      fontSize: 16.0,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                record.level.name,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: logColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                record.loggerName,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: logColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
              ),
            ],
          ),
          _ShowStack(record)
        ],
      ),
    );
  }

  FontWeight _getTextWeight() {
    switch (record.level) {
      case LogLevel.error:
        return FontWeight.w700;
      case LogLevel.debug:
        return FontWeight.w300;
      case LogLevel.info:
        return FontWeight.w300;
      case LogLevel.warning:
        return FontWeight.w400;
    }

    return FontWeight.w300;
  }

  Color _getLogColor() {
    switch (record.level) {
      case LogLevel.error:
        return Colors.redAccent;
      case LogLevel.debug:
        return Colors.lightBlue;
      case LogLevel.info:
        return Colors.lightGreen;
      case LogLevel.warning:
        return Colors.yellow;
    }

    return Colors.white;
  }
}

final List<LogRecord> _shownRecords = <LogRecord>[];

class _ShowStack extends StatefulWidget {
  _ShowStack(this.record, {Key key}) : super(key: key);

  final LogRecord record;

  @override
  __ShowStackState createState() => __ShowStackState();
}

class __ShowStackState extends State<_ShowStack> {
  @override
  Widget build(BuildContext context) {
    if (widget.record.stackTrace == null) {
      return SizedBox.shrink();
    }

    final _stackString = widget.record.stackTrace.toString().split('\n');

    return Container(
      padding: const EdgeInsets.only(top: 12.0),
      child: GestureDetector(
        key: ValueKey(widget.record.time),
        onTap: () {
          setState(() {
            if (_shownRecords.contains(widget.record)) {
              _shownRecords.remove(widget.record);
            } else {
              _shownRecords.add(widget.record);
            }
          });
        },
        child: Column(
          children: [
            AnimatedCrossFade(
              firstChild: Container(
                height: 40.0,
                child: Center(
                  child: Text(
                    '▼ EXPAND ▼',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                  ),
                ),
              ),
              secondChild: Container(
                height: 40.0,
                child: Center(
                  child: Text(
                    '▲ COLLAPSE ▲',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                  ),
                ),
              ),
              duration: Duration(milliseconds: 250),
              crossFadeState:
                  _shownRecords.contains(widget.record) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
            AnimatedCrossFade(
              firstChild: SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              secondChild: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _stackString
                      .map(
                        (e) => Text(
                          e.replaceAll(RegExp(' +'), '  '),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.redAccent.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                        ),
                      )
                      .toList(),
                ),
              ),
              duration: Duration(milliseconds: 250),
              crossFadeState:
                  _shownRecords.contains(widget.record) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}
