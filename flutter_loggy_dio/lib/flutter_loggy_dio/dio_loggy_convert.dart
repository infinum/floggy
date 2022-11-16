part of flutter_loggy_dio;
///Convert dio response data to a json string before loggy log.
///By default, using [toString] method to convert the response data.
///Or, use a [JsonEncoder] to encode a response data , like this:
///```dart
/// json.decode('["foo", { "bar": 499 }]');
///```
///Because, in some cases, a response data has no quotes, like this:
///```dart
/// '[foo, { name: jj }]';
///```
class DioLoggyConvert {
  String convertData(dynamic data){
    return data.toString();
  }
}