part of flutter_loggy_dio;
///Convert dio response data to a string.
///By default, use [toString] method to convert the response data.
///Or, maybe you want to use [JsonEncoder] to encode your data before loggy log, like this:
///```dart
/// json.decode('["foo", { "bar": 499 }]');
///```
///Because, in some cases, you may get a response data like this:
///```dart
/// '[foo, { name: myName }]';
///```
class DioLoggyConvert {
  String convertData(dynamic data){
    return data.toString();
  }
}