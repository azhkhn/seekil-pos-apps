import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class ServicesListModel {
  int id, price;
  String name, description, estimate;
  bool isExpanded;

  ServicesListModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.estimate,
      required this.isExpanded});

  factory ServicesListModel.fromJson(Map<String, dynamic> json) {
    return ServicesListModel(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        estimate: json['estimate'],
        isExpanded: false);
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
}
