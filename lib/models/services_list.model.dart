import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class ServicesListModel {
  int? id, price;
  String? name, description, estimate;
  bool? isExpanded;

  ServicesListModel(
      {this.id,
      this.name,
      this.price,
      this.description,
      this.estimate,
      this.isExpanded});

  factory ServicesListModel.fromJson(Map<String, dynamic> json) {
    return ServicesListModel(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        estimate: json['estimate'],
        isExpanded: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'estimate': estimate,
    };
  }

  static Future<List<ServicesListModel>> fetchServicesList() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('master/service');
    List<dynamic> orderList = jsonDecode(response.toString())['list'];

    return orderList.map((e) => new ServicesListModel.fromJson(e)).toList();
  }

  static Future<List<dynamic>> fetchTopServices() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('/order/item/services/s/top');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<bool> createNewServices(ServicesListModel model) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response =
          await seekilApi.post('master/service', model.toJson());
      var responseJson = response.data;

      if (responseJson['meta']['code'] == 200) {
        return true;
      }
      return false;
    } on DioError {
      return false;
    }
  }

  static Future<bool> updateServicesById(
      String id, Map<String, dynamic> data) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.put('master/service/$id', data);
      var responseJson = response.data;

      if (responseJson['meta']['code'] == 200) {
        return true;
      }
      return false;
    } on DioError {
      return false;
    }
  }

  static Future<bool> deleteServicesById(String id) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.delete(
        'master/service/$id',
      );
      var responseJson = response.data;

      if (responseJson['meta']['code'] == 200) {
        return true;
      }
      return false;
    } on DioError {
      return false;
    }
  }
}
