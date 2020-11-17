# Loggy Dio extension

Extension for loggy. Includes interceptor and pretty printer for Dio.

## Dio
For Dio we included special `DioLoggy` that can be filtered, and `LoggyDioInterceptor` that will connect to Dio and print out requests and responses.

In IntelliJ/Studio you can collapse request/response body:

 ![Gif showing collapsible body][show_body]
 
All you need to do to setup this is go to Preferences -> Editor -> General -> Console and under `Fold console lines that contain` add these 3 rules: `║`, `╔` and `╚`.

[add image here]
 
## How to use

For documentation refer to [loggy](https://github.com/infinum/floggy/blob/master/loggy/README.md)
 
[show_body]: https://github.com/infinum/floggy/raw/master/assets/2020-10-28%2010.38.39.gif
