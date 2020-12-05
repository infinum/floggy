import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:loggy/loggy.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: HistoryPrinter(
      PrettyDeveloperPrinter(),
    ),
    logOptions: LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.error,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with UiLoggy {
  CounterLogic _counter;

  @override
  void initState() {
    super.initState();
    loggy.debug('Init state called!');
    _counter = CounterLogic(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loggy.debug('Did change dependencies called!');
  }

  void _click({bool increase = true}) {
    loggy.info('Button clicked!');

    setState(() {
      if (increase) {
        _counter.increment();
      } else {
        _counter.decrement();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loggy.debug('Build called!');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade800,
            height: 400.0,
            child: LogHistoryWidget(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${_counter.value}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _click,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 12.0,
          ),
          FloatingActionButton(
            onPressed: () => _click(increase: false),
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

mixin LogicLoggy implements LoggyType {
  @override
  Loggy<LogicLoggy> get loggy => Loggy<LogicLoggy>('Logic($runtimeType)');
}

class CounterLogic with LogicLoggy {
  CounterLogic(this._counter);

  int _counter;

  int get value => _counter;

  void increment() {
    loggy.info('Incrementing counter: $_counter');
    _counter++;
  }

  void decrement() {
    loggy.warning('Decrementing counter: $_counter');

    if (_counter == 0) {
      loggy.error('Counter is at 0!');
      return;
    }
    _counter--;
  }
}
