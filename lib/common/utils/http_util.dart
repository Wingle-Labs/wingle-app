import 'package:dio/dio.dart';

/// HTTP 클라이언트
class HttpUtil {
  /// Dio 인스턴스
  Dio dio;

  HttpUtil._internal(this.dio);

  /// 싱글톤
  static final HttpUtil instance = HttpUtil._internal(
    Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        sendTimeout: Duration(seconds: 5),
        contentType: 'application/json',
      ),
    ),
  );

  /// (테스트용) Dio 교체
  void replaceDio(Dio newDio) {
    dio = newDio;
  }

  /// GET 요청
  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    return dio.get(
      url,
      queryParameters: query,
      options: Options(headers: headers),
    );
  }

  /// POST 요청
  Future<Response<T>> post<T>(
    String url, {
    Object? body,
    Map<String, dynamic>? headers,
  }) async {
    return dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }
}
