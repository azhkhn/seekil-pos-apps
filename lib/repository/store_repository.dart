import 'package:dio/dio.dart';
import 'package:seekil_back_office/models/store_model.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class StoreRepository {
  static Future<List<StoreModel>> fetchMasterStore() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/store');

    List data = response.data['list'];

    return data.map((e) => StoreModel.fromMap(e)).toList();
  }
}
