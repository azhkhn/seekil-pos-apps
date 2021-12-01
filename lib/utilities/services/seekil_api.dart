import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/base_options.dart';
import 'package:seekil_back_office/utilities/services/connectivity_request_retrier.dart';
import 'package:seekil_back_office/utilities/services/retry_interceptor.dart';
import 'seekil_api_interceptors.dart';

class SeekilApi {
  Future<Response> get(String url) async {
    Dio dio = Dio();
    dio = Dio(SeekilBaseOptions.baseOptions)
      ..interceptors.addAll([
        SeekilApiInterceptors(),
        RetryOnConnectionChangeInterceptor(
            requestRetrier: ConnectivityRequestRetrier(
                dio: dio, connectivity: Connectivity()))
      ]);
    Response response = await dio.get(url);
    return response;
  }

  Future<Response> post(String url, Map<String, dynamic> data) async {
    Dio dio = Dio();
    dio = Dio(SeekilBaseOptions.baseOptions)
      ..interceptors.addAll([
        SeekilApiInterceptors(),
        RetryOnConnectionChangeInterceptor(
            requestRetrier: ConnectivityRequestRetrier(
                dio: dio, connectivity: Connectivity()))
      ]);
    Response response = await dio.post(url, data: data);
    return response;
  }

  Future<Response> put(String url, Map<String, dynamic> data) async {
    Dio dio = Dio();
    dio = Dio(SeekilBaseOptions.baseOptions)
      ..interceptors.addAll([
        SeekilApiInterceptors(),
        RetryOnConnectionChangeInterceptor(
            requestRetrier: ConnectivityRequestRetrier(
                dio: dio, connectivity: Connectivity()))
      ]);
    Response response = await dio.put(url, data: data);
    return response;
  }

  Future<Response> delete(String url) async {
    Dio dio = Dio();
    dio = Dio(SeekilBaseOptions.baseOptions)
      ..interceptors.addAll([
        SeekilApiInterceptors(),
        RetryOnConnectionChangeInterceptor(
            requestRetrier: ConnectivityRequestRetrier(
                dio: dio, connectivity: Connectivity()))
      ]);
    Response response = await dio.delete(url);
    return response;
  }
}
