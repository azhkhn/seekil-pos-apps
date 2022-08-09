import 'package:dio/dio.dart';
import 'package:seekil_back_office/models/partnership_model.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class PartnershipRepository {
  static Future<List<PartnershipModel>> fetchMasterPartnership() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/partnership');

    List data = response.data['list'];

    return data.map((e) => PartnershipModel.fromMap(e)).toList();
  }
}
