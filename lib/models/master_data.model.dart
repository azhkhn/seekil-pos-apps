import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class MasterDataModel {
  static Future<List<dynamic>> fetchMasterType() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/type');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<List<dynamic>> fetchMasterStore() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/store');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<List<dynamic>> fetchMasterPartnership() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/partnership');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<List<dynamic>> fetchMasterPromo() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/promo');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<List<dynamic>> fetchMasterPaymentMethod() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/payment-method');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<List<dynamic>> fetchMasterServices() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/service');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<List<dynamic>> fetchMasterStatus() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/status');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    // 1 = New
    // 3 = In Progress
    // 6 = Cancel
    // 7 = Done
    List<dynamic> filteredData = data
        .where((element) =>
            element['id'] == 1 ||
            element['id'] == 3 ||
            element['id'] == 6 ||
            element['id'] == 7)
        .toList();

    return filteredData;
  }
}
