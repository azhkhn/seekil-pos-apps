import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:seekil_back_office/constants/order_status.constant.dart';
import 'package:seekil_back_office/models/promo_model.dart';
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

  static Future<List<PromoModel>?> fetchMasterPromo({String? params}) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = params != null
          ? await seekilApi.get('master/promo?$params')
          : await seekilApi.get('master/promo');
      List data = response.data['list'];

      return data.map((e) => PromoModel.fromMap(e)).toList();
    } on DioError {
      return null;
    }
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
    List<dynamic> filteredData = data
        .where((element) => element['id'] != OrderStatusConstant.cancel)
        .toList();

    return filteredData;
  }
}
