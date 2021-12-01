import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class OrderItemListItemsModel {
  String itemName, note;
  int subtotal;

  OrderItemListItemsModel(
      {required this.itemName, required this.note, required this.subtotal});

  factory OrderItemListItemsModel.fromJson(Map<String, dynamic> json) {
    return OrderItemListItemsModel(
        itemName: json['item_name'],
        note: json['note'],
        subtotal: json['subtotal']);
  }

  static Future<List<OrderItemListItemsModel>> fetchOrderItemByOrderId(
      String orderId) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order/$orderId');
    List<dynamic> orderItems;

    var jsonResponse = jsonDecode(response.toString());
    orderItems = (jsonResponse as Map<String, dynamic>)['list'];
    return orderItems
        .map((e) => new OrderItemListItemsModel.fromJson(e))
        .toList();
  }

  static Future<Map<String, dynamic>> fetchOrderItems(String params) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order/item/$params');
    Map<String, dynamic> responseJson = jsonDecode(response.toString());

    return {
      'list': responseJson['list'],
      'total_order': responseJson['total_order'],
      'total_paid_orders': responseJson['total_paid_orders'],
      'total_unpaid_orders': responseJson['total_unpaid_orders'],
      'total_row': responseJson['pagination']['total_row']
    };
  }
}
