import 'package:dio/dio.dart';
import 'package:seekil_back_office/models/auth.model.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class EmployeeRepository {
  static Future<List<AuthModel>?>? fetchEmployee() async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.get('auth');
      List data = response.data['list'];

      return data.map((e) => AuthModel.fromMap(e)).toList();
    } on DioError {
      return null;
    }
  }
}
