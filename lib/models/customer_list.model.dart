import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class CustomerListModel {
  final int id;
  final String name;
  final String whatsapp;
  final int points;

  CustomerListModel(
      {required this.id,
      required this.name,
      required this.whatsapp,
      required this.points});

  factory CustomerListModel.fromJson(Map<String, dynamic> json) {
    return CustomerListModel(
        id: json['id'],
        name: json['name'],
        whatsapp: json['whatsapp'] != '0' ? json['whatsapp'] : '-',
        points: json['points'] != null ? json['points'] : 0);
  }

  static Future<List<CustomerListModel>> fetchCustomerList({
    String? customerName,
    String page = '0',
  }) async {
    SeekilApi seekilApi = SeekilApi();

    String params = customerName != '' && customerName != null
        ? 'customer?page=$page&name=$customerName'
        : 'customer?page=$page';

    Response response = await seekilApi.get(params);

    List<dynamic> responseJson = jsonDecode(response.toString())['list'];
    return responseJson.map((e) => CustomerListModel.fromJson(e)).toList();
  }
}
