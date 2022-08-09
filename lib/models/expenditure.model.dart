import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class ExpenditureModel {
  int? id;
  String? name;
  String? description;
  int? price;
  String? priceTemp;
  String? createdAt;

  ExpenditureModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.priceTemp,
    this.createdAt,
  });

  factory ExpenditureModel.fromJson(Map<String, dynamic> json) {
    return ExpenditureModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price != null ? price : 0,
    };
  }

  static Future<Map<String, dynamic>> fetchAllFixedMonthlyExpenses() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('fixed-monthly-expenses');
    var responseJson = jsonDecode(response.toString());

    return {
      'total': responseJson['total'],
      'list':
          responseJson['list'].map((e) => ExpenditureModel.fromJson(e)).toList()
    };
  }

  static Future<Map<String, dynamic>> fetchCashFlowCurrentMonth() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi
        .get('fixed-monthly-expenses/all-income-and-expenditure');
    return jsonDecode(response.toString())['data'];
  }

  static Future<Map<String, dynamic>> fetchAllSpendingMoney(
      {String? params}) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = params != null
        ? await seekilApi.get('spending-money?$params')
        : await seekilApi.get('spending-money');
    var responseJson = jsonDecode(response.toString());

    return {
      'total': responseJson['total'],
      'list':
          responseJson['list'].map((e) => ExpenditureModel.fromJson(e)).toList()
    };
  }

  static Future<Map<String, dynamic>> fetchPeriodSpendingMoney(
      String params) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('spending-money/period/$params');
    var responseJson = jsonDecode(response.toString());

    return {
      'total': responseJson['total'],
      'list':
          responseJson['list'].map((e) => ExpenditureModel.fromJson(e)).toList()
    };
  }

  Future<bool> createSpendingMoney(ExpenditureModel model) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response =
          await seekilApi.post('spending-money', model.toJson());
      var responseJson = jsonDecode(response.toString());

      if (responseJson['meta']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError {
      return false;
    }
  }

  Future<bool> createFixedMonthlyExpenses(ExpenditureModel model) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response =
          await seekilApi.post('fixed-monthly-expenses', model.toJson());
      var responseJson = jsonDecode(response.toString());

      if (responseJson['meta']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError {
      return false;
    }
  }

  static Future<bool> updateFixedMonthlyExpenses(
      String id, Map<String, dynamic> data) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response =
          await seekilApi.put('fixed-monthly-expenses/$id', data);
      var responseJson = jsonDecode(response.toString());

      if (responseJson['meta']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError {
      return false;
    }
  }

  static Future<bool> updateSpendingMoney(
      String id, Map<String, dynamic> data) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.put('spending-money/$id', data);
      var responseJson = jsonDecode(response.toString());

      if (responseJson['meta']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError {
      return false;
    }
  }

  static Future<bool> deleteSpendingMoneyById(String id) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.delete('spending-money/$id');
      var responseJson = response.data;

      if (responseJson['meta']['code'] == 200) {
        return true;
      }

      return false;
    } on DioError {
      return false;
    }
  }

  static Future<bool> deleteFixedMonthlyExpensesById(String id) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.delete('fixed-monthly-expenses/$id');
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
