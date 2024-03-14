part of '../flutter_loggy_dio.dart';

class LoggyDioInterceptor extends Interceptor with DioLoggy {
  LoggyDioInterceptor({
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 90,
    this.requestLevel = LogLevel.info,
    this.responseLevel = LogLevel.info,
    this.errorLevel = LogLevel.error,
  });

  final LogLevel requestLevel;
  final LogLevel responseLevel;
  final LogLevel errorLevel;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print [Response.data]
  final bool responseBody;

  /// Print error message
  final bool error;

  /// Width size per logPrint
  final int maxWidth;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final builder = _LogBuilder(maxWidth);

    builder.addTitle('>>> Request │ ${options.method} │ ${options.uri}');

    if (requestHeader) {
      builder.startSection('Query parameters');
      builder.addMap(options.queryParameters);
      builder.endSection();

      builder.startSection('Headers');
      final headers = {
        'contentType': options.contentType,
        'responseType': options.responseType,
        'followRedirects': options.followRedirects,
        'connectTimeout': options.connectTimeout,
        'receiveTimeout': options.receiveTimeout,
        ...options.headers,
      };
      builder.addMap(headers);
      builder.endSection();

      builder.startSection('Extra');
      builder.addMap(options.extra);
      builder.endSection();
    }

    if (requestBody && options.method != 'GET') {
      final data = options.data;

      if (data is FormData) {
        builder.startSection('Form data │ ${data.boundary}');
        final formDataMap = {}
          ..addEntries(data.fields)
          ..addEntries(data.files);
        builder.addMap(formDataMap);
        builder.endSection();
      } else {
        builder.startSection('Body');
        builder.addBodyData(data);
        builder.endSection();
      }
    }

    loggy.log(requestLevel, builder.build());
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final builder = _LogBuilder(maxWidth);

    final response = err.response;
    if (response != null) {
      builder.addTitle('<<< DioError │ ${err.requestOptions.method} │ '
          '${response.statusCode} ${response.statusMessage} │ '
          '${response.requestOptions.uri}');

      if (error) {
        builder.startSection('Headers');
        builder.addMap(response.headers.map);
        builder.endSection();

        builder.startSection('Body');
        builder.addBodyData(response.data);
        builder.endSection();
      }
    } else {
      builder.addTitle('<<< DioError (${err.type}) │ '
          '${err.requestOptions.method} │ ${err.requestOptions.uri}');

      final message = err.message;
      if (error && message != null) {
        builder.startSection('Message');
        builder.addMessage(message);
        builder.endSection();
      }
    }

    loggy.log(errorLevel, builder.build());
    super.onError(err, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    final builder = _LogBuilder(maxWidth);

    builder.addTitle('<<< Response │ ${response.requestOptions.method} │ '
        '${response.statusCode} ${response.statusMessage} │ '
        ' ${response.requestOptions.uri}');

    if (responseHeader) {
      builder.startSection('Headers');
      builder.addMap(response.headers.map);
      builder.endSection();
    }

    if (responseBody) {
      builder.startSection('Body');
      builder.addBodyData(response.data);
      builder.endSection();
    }

    loggy.log(responseLevel, builder.build());
    super.onResponse(response, handler);
  }
}

class _LogBuilder {
  _LogBuilder(this._maxWidth);
  final int _maxWidth;

  final _buffer = StringBuffer();

  void startSection(String name) {
    _buffer.writeln('╔ $name');
  }

  void endSection() {
    _buffer.writeln('╚${'═' * (_maxWidth - 2)}╝');
  }

  void addTitle(String title) {
    _buffer.writeln(title);
  }

  void addMessage(String message) {
    var string = '║ ${message.replaceAll('\n', '\n║')}';
    string = _squeezeToMaxWidth(string);
    _buffer.write(string);
  }

  void addMap(Map map) {
    final buffer = StringBuffer();
    if (map.isEmpty) {
      buffer.writeln('║');
    } else {
      for (final entry in map.entries) {
        buffer.writeln('╟ ${entry.key}: ${entry.value}');
      }
    }
    final string = _squeezeToMaxWidth(buffer.toString());
    _buffer.write(string);
  }

  void addBodyData(dynamic data) {
    if (data == null) {
      _buffer.writeln('║');
      return;
    }

    dynamic json;
    if (data is String) {
      try {
        json = jsonDecode(data);
      } catch (_) {}
    } else if (data is num ||
        data is Map<String, dynamic> ||
        data is List<dynamic> ||
        data is bool) {
      json = data;
    }

    late String string;
    if (json != null) {
      const jsonEncoder = JsonEncoder.withIndent('  ');
      string = jsonEncoder.convert(json);
    } else {
      string = data.toString();
    }

    string = '║ ${string.replaceAll('\n', '\n║ ')}';
    string = _squeezeToMaxWidth(string);
    _buffer.write(string);
  }

  String build() {
    final string = _buffer.toString();
    return string.substring(0, string.length - 1); // removes last '\n'
  }

  String _squeezeToMaxWidth(String string) {
    if (string.isEmpty) return string;

    final buffer = StringBuffer();

    var lines = string.split('\n');
    if (lines.last.isEmpty) {
      lines = lines.sublist(0, lines.length - 1);
    }

    for (final line in lines) {
      final squeezedLineLength = min(line.length, _maxWidth);
      buffer.writeln(line.substring(0, squeezedLineLength));

      final hasOverflow = line.length > squeezedLineLength;
      if (!hasOverflow) continue;

      var overflow = line.substring(squeezedLineLength);
      while (overflow.isNotEmpty) {
        const overflowIndicator = '║';
        final maxOverflowedLineLength = _maxWidth - overflowIndicator.length;
        final overflowedLineLength =
            min(overflow.length, maxOverflowedLineLength);

        buffer.writeln(
            overflowIndicator + overflow.substring(0, overflowedLineLength));
        overflow = overflow.substring(overflowedLineLength);
      }
    }
    return buffer.toString();
  }
}
