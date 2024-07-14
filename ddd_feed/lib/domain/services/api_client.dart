import 'package:dio/dio.dart';

const BASE_URL = "https://ai.kkbt.dev/";

class ApiClient {
  final dio = createDio();

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        receiveTimeout: const Duration(milliseconds: 15000),
        connectTimeout: const Duration(milliseconds: 15000),
        sendTimeout: const Duration(milliseconds: 15000),
        validateStatus: (int? statusCode) {
          if (statusCode == null) {
            return false;
          }
          if (statusCode == 401) {
            return true;
          }
          if (statusCode == 422) {
            return true;
          } else {
            return statusCode >= 200 && statusCode < 300;
          }
        },
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll({AppInterceptors(dio)});

    return dio;
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    return handler.next(response);
  }
}
