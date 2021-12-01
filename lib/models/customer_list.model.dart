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

  static Future<List<dynamic>> fetchCustomerList(String url,
      [String userName = '']) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get(url);

    List<dynamic> responseJson = jsonDecode(response.toString())['list'];
    var customerList =
        responseJson.map((e) => CustomerListModel.fromJson(e)).where((element) {
      final name = element.name.toLowerCase();
      final inputtedUserName = userName.toLowerCase();

      return name.contains(inputtedUserName);
    }).toList();

    return customerList;
  }
}
