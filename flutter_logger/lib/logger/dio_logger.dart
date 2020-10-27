import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'custom_loggers.dart';

class LoggerDioInterceptor extends Interceptor with DioLogger {
  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// Width size per logPrint
  final int maxWidth;

  LoggerDioInterceptor({
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 90,
  });

  @override
  Future onRequest(RequestOptions options) async {
    _printRequestHeader(options);
    if (requestHeader) {
      _prettyPrintObject(options.queryParameters, header: 'Query Parameters');
      final requestHeaders = <String, dynamic>{};
      if (options.headers != null) {
        requestHeaders.addAll(options.headers);
      }
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType?.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout;
      requestHeaders['receiveTimeout'] = options.receiveTimeout;

      _prettyPrintObject(requestHeaders, header: 'Headers');
      _prettyPrintObject(options.extra, header: 'Extras');
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is FormData) {
          final formDataMap = <String, dynamic>{}..addEntries(data.fields)..addEntries(data.files);
          _prettyPrintObject(formDataMap, header: 'Form data | ${data.boundary}');
        } else {
          _prettyPrintObject(data, header: 'Body');
        }
      }
    }

    _commit(LogLevel.debug);
    return options;
  }

  @override
  Future onError(DioError err) async {
    if (error) {
      if (err.type == DioErrorType.RESPONSE) {
        logPrint(
            '<<< DioError │ ${err?.request?.method} │ ${err?.response?.statusCode} ${err?.response?.statusMessage} │ ${err?.response?.request?.uri?.toString()}');
        if (err.response != null && err.response.data != null) {
          _prettyPrintObject(err.response.data, header: 'DioError │ ${err.type}');
        }
      } else {
        logPrint('<<< DioError (No response) │ ${err?.request?.method} │ ${err?.request?.uri?.toString()}');
        logPrint('╔ ERROR');
        logPrint('║  ${err.message.replaceAll('\n', '\n║  ')}');
        _printLine(pre: '╚');
      }
    }
    _commit(LogLevel.error);
    return err;
  }

  @override
  Future onResponse(Response response) async {
    _printResponseHeader(response);
    if (responseHeader) {
      _prettyPrintObject(response.headers, header: 'Headers');
    }

    if (responseBody) {
      _printResponse(response);
    }

    _commit(LogLevel.info);
    return response;
  }

  void _printResponse(Response response) {
    final dynamic data = response.data;

    if (data != null) {
      _prettyPrintObject(data, header: 'Body');
    }
  }

  void _prettyPrintObject(dynamic data, {String header}) {
    final dynamic object = JsonDecoder().convert(data.toString());
    final json = JsonEncoder.withIndent('  ');

    logPrint('╔  $header');
    logPrint('║');
    logPrint('║  ${json.convert(object).replaceAll('\n', '\n║  ')}');
    logPrint('║');
    _printLine(pre: '╚');
  }

  void _printResponseHeader(Response response) {
    final uri = response?.request?.uri;
    final method = response.request.method;
    logPrint('<<< Response │ $method │ ${response.statusCode} ${response.statusMessage} │ ${uri.toString()}');
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options?.uri;
    final method = options?.method;
    logPrint('>>> Request │ $method │ ${uri.toString()}');
  }

  void _printLine({String pre = '', String suf = '╝'}) => logPrint(
        '$pre${'═' * maxWidth}$suf',
      );

  final StringBuffer _value = StringBuffer();
  void logPrint(String value) {
    if (_value.isEmpty) {
      _value.write(value);
    } else {
      _value.write('\n');
      _value.write(value);
    }
  }

  void _commit(LogLevel level) {
    if (level.priority >= LogLevel.error.priority) {
      final _valueError = _value.toString();
      final _errorTitle = _valueError.substring(0, _valueError.indexOf('\n'));
      final _errorBody = _valueError.substring(_errorTitle.length);
      logger.log(level, _errorTitle, _errorBody);
    } else {
      logger.log(level, _value.toString());
    }
    _value.clear();
  }
}
