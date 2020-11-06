# Loggy Dio extension

## Dio
For Dio we included special `DioLoggy` that can be filtered, and `LoggyDioInterceptor` that will connect to Dio and print out requests and responses.

`LoggyDioInterceptor` has special characters when showing request/response body. You can use this to set new rule in IntelliJ (Preferences -> Editor -> General -> Console), under `Fold console lines that contain` add these 3 rules: `║`, `╔` and `╚`.
This will automatically collapse the lines, and they can be expanded if you want to see whole body:
 ![Gif showing collapsible body][show_body]
 
 [show_body]: ../assets/2020-10-28%2010.38.39.gif