import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static Dio? dio;
  static const String baseurl = "http://localhost:8000/api/v1";

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: baseurl,
      connectTimeout: const Duration(seconds: 530),
      receiveTimeout: const Duration(seconds: 530),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    dio!.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  static Future<Response> getData(
      {required String url, String? token, Map<String, dynamic>? query}) async {
    if (token != null) {
      dio!.options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

//postData

  static Future<Response> postData(
      {required String url,
      required Map<String, dynamic>? data,
      String? token}) async {
    if (token != null) {
      dio!.options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    // if (token != null) {
    //   dio!.options.headers = {
    //     'Accept': 'application/json',
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   };
    // }
    return await dio!.post(url, data: data);
  }
}
