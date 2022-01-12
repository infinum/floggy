import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';
import 'package:loggy/loggy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Loggy.initLoggy(
    logPrinter: StreamPrinter(
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

  final dio = Dio()
    ..interceptors.add(
      LoggyDioInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );

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
          GestureDetector(
            onTap: () {
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (_) => LoggyStreamScreen()));
            },
            child: Container(
              color: ThemeData.dark().scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height * 0.4,
              child: LoggyStreamWidget(),
            ),
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
          ElevatedButton(
            onPressed: () async {
              final response = await dio
                  .post('https://jsonplaceholder.typicode.com/posts', data: {
                "title": "foo",
                "body": "bar",
                "userId": 1,
              });
            },
            child: Text("DIO POST"),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _click,
            heroTag: 'increment_tag',
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 12.0,
          ),
          FloatingActionButton(
            onPressed: () => _click(increase: false),
            tooltip: 'Decrement',
            heroTag: 'decrement_tag',
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
  CounterLogic(this._counter) {
    loggy.debug('Started new counter! Start count value is: $_counter');
  }

  int _counter;

  int get value => _counter;

  void increment() {
    loggy.info('Incrementing counter! Current value: $_counter');

    if (_counter > 2) {
      loggy.debug(
          'Counter is over 2! This is really long message: Lorem Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');
    }

    _counter++;
  }

  void decrement() {
    loggy.warning('Decrementing counter! Current value: $_counter');

    if (_counter == 0) {
      loggy.error('Counter is at 0. Counter should never be below 0');
      return;
    }

    _counter--;
  }
}
