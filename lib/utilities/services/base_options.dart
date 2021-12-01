import 'package:dio/dio.dart';
import 'package:seekil_back_office/constants/general.constant.dart';

class SeekilBaseOptions {
  static BaseOptions baseOptions = BaseOptions(
      baseUrl: GeneralConstant.BASE_URL,
      connectTimeout: 100000,
      receiveTimeout: 100000,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });
}
