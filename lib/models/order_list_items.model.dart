import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
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

  static Future<Map<String, dynamic>> fetchOrderItems(String? orderId) async {
    final box = GetStorage();
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order/item/$orderId');
    var jsonResponse = jsonDecode(response.toString());

    var assignServices = await _fetchServices(jsonResponse['list'], seekilApi);
    var list = assignServices
        .map((json) => {
              'item_name': json['item_name'],
              'services': json['services'],
              'subtotal': json['subtotal'],
              'note': json['note']
            })
        .toList();
    var responseJson = {
      'list': list,
      'total_order': jsonResponse['total_order']
    };

    box.write(StorageKeyConstant.ORDER_ITEMS, responseJson);

    return responseJson;
  }

  static _fetchServices(List<dynamic> items, seekilApi) async {
    return await Future.wait(items.map((item) async {
      Response response =
          await seekilApi.get('order/item/${item['item_id']}/services');
      List<dynamic> servicesList = jsonDecode(response.toString())['list'];

      item['services'] = servicesList
          .map((e) => {
                'name': e['master_service']['name'],
                'price': e['master_service']['price']
              })
          .toList();

      return item;
    }).toList());
  }
}
