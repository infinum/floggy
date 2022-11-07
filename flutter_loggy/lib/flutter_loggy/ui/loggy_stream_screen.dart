part of flutter_loggy;

class LoggyStreamScreen extends StatefulWidget {
  const LoggyStreamScreen({Key? key}) : super(key: key);

  @override
  State createState() => _LoggyStreamScreenState();
}

class _LoggyStreamScreenState extends State<LoggyStreamScreen> {
  LogLevel? _level = LogLevel.all;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${_level?.name}'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Center(
                child: DropdownButton<LogLevel>(
                  items: LogLevel.values
                      .map(
                        (LogLevel level) => DropdownMenuItem<LogLevel>(
                          value: level,
                          child: Text(level.name),
                        ),
                      )
                      .toList(),
                  onChanged: (LogLevel? level) {
                    setState(() {
                      _level = level;
                    });
                  },
                  icon: const Icon(Icons.filter_list_sharp),
                  underline: const SizedBox.shrink(),
                ),
              ),
            )
          ],
        ),
        body: LoggyStreamWidget(logLevel: _level),
      ),
    );
  }
}
