import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/utilities/services/base_options.dart';

class SeekilApiInterceptors extends InterceptorsWrapper {
  @override
  dynamic onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final box = GetStorage();
    String? token = box.read('TOKEN');

    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }

  @override
  dynamic onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  dynamic onError(DioError error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 403) {
      Dio dio = Dio(SeekilBaseOptions.baseOptions);

      final box = GetStorage();
      RequestOptions options = error.response!.requestOptions;
      Response response =
          await dio.post('auth/token', data: {'username': 'it.min'});
      String token = response.data['token'];

      options.headers['Authorization'] = 'Bearer $token';
      box.write('TOKEN', token);

      return dio.request(options.path);
    } else if (error.type == DioErrorType.connectTimeout) {
      return SnackbarHelper.show(
          title: GeneralConstant.ERROR_TITLE,
          message: GeneralConstant.NO_INTERNET);
    }

    return super.onError(error, handler);
  }
}
