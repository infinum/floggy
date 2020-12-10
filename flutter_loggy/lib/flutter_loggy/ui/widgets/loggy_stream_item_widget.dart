part of flutter_loggy;

final List<LogRecord> _shownRecords = <LogRecord>[];

class _LoggyItemStackWidget extends StatefulWidget {
  _LoggyItemStackWidget(this.record, {Key key}) : super(key: key);

  final LogRecord record;

  @override
  _LoggyItemStackWidgetState createState() => _LoggyItemStackWidgetState();
}

class _LoggyItemStackWidgetState extends State<_LoggyItemStackWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.record.stackTrace == null) {
      return SizedBox.shrink();
    }

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
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Divider(color: Colors.grey.shade600),
              _CollapsableButton(widget.record),
              AnimatedCrossFade(
                firstChild: SizedBox(
                  width: MediaQuery.of(context).size.width,
                ),
                secondChild: _StackList(widget.record),
                duration: Duration(milliseconds: 250),
                crossFadeState:
                    _shownRecords.contains(widget.record) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StackList extends StatelessWidget {
  _StackList(this.record, {Key key}) : super(key: key);

  final LogRecord record;

  @override
  Widget build(BuildContext context) {
    final _stackString = record.stackTrace.toString().split('\n');

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _stackString.map(
          (e) {
            final _value = e.replaceAll(RegExp(' +'), '  ').replaceAll(')', '').split('(');
            final _isFlutter =
                (_value.last ?? '').startsWith('package:flutter') || (_value.last ?? '').startsWith('dart:');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _value.first ?? '',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: _isFlutter ? Colors.blueGrey : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                ),
                Text(
                  _value.last ?? '',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: _isFlutter ? Colors.blueGrey : Colors.redAccent,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                ),
                SizedBox(
                  height: 4.0,
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

class _CollapsableButton extends StatelessWidget {
  _CollapsableButton(this.record, {Key key}) : super(key: key);

  final LogRecord record;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Container(
        height: 32.0,
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
        height: 32.0,
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
      crossFadeState: _shownRecords.contains(record) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }
}
