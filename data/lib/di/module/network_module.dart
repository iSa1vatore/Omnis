import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @injectable
  Dio get dio => Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) {
          return handler.next(options);
        },
        onResponse: (Response response, handler) {
          if (response.data is Map) {
            if (response.data.containsKey("response")) {
              response.data = response.data["response"];
            } else if (response.data.containsKey("error")) {
              var error = response.data["error"];

              print("API ERROR: $error");
            }
          }

          return handler.next(response);
        },
      ),
    );
}
