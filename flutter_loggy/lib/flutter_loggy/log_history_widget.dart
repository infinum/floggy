part of flutter_loggy;

class LogHistoryWidget extends StatelessWidget {
  LogHistoryWidget({
    this.showFilters = true,
    Key key,
  }) : super(key: key);

  bool showFilters;

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
      child: Column(
        children: [
          // if (showFilters)
          //   Row(
          //     children: [],
          //   ),
          Expanded(
            child: StreamBuilder<List<LogRecord>>(
              stream: _printer.logRecord,
              builder: (context, records) {
                if (!records.hasData) {
                  return Container();
                }

                return ListView(
                  reverse: true,
                  children: records.data.map((e) => LogItem(e)).toList(),
                );
              },
            ),
          ),
        ],
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
    Color _dividerColor = ThemeData.dark().dividerColor;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '$_time - ${record.level.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: logColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                      ),
                ),
              ),
              Text(
                record.loggerName,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: logColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            record.message,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: logColor,
                  fontWeight: _getTextWeight(),
                  fontSize: 16.0,
                ),
          ),
          _LogItemStackWidget(record),
          Divider(
            color: _dividerColor,
          ),
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
