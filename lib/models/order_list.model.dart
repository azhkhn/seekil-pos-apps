import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class OrderItems {
  String? itemName, servicesName;
  String? note;
  int? subtotal;

  OrderItems({this.itemName, this.servicesName, this.note, this.subtotal});

  Map<String, dynamic> fromJson() {
    return {
      'itemName': itemName,
      'servicesName': servicesName,
      'subtotal': subtotal,
      'note': note
    };
  }
}

class OrderListModel {
  String orderId;
  String orderDate;
  String orderStatus;
  String? paymentStatus;
  String customerName;
  int qty;
  int total;

  OrderListModel(
      {required this.orderId,
      required this.orderDate,
      required this.orderStatus,
      this.paymentStatus,
      required this.customerName,
      required this.qty,
      required this.total});

  factory OrderListModel.fromJson(Map<String, dynamic> object) {
    return OrderListModel(
        orderId: object['order_id'],
        orderDate: object['order_date'],
        orderStatus: object['master_status']['name'],
        paymentStatus: object['payment_status'].contains('_')
            ? toBeginningOfSentenceCase(
                object['payment_status'].replaceAll('_', ' '))
            : toBeginningOfSentenceCase(object['payment_status']),
        customerName: object['customer']['name'],
        qty: object['qty'],
        total: object['total']);
  }

  static Future<Map<String, dynamic>> fetchAllOrders() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order');
    Map<String, dynamic> responseJson = jsonDecode(response.toString());

    return {
      'list': responseJson['list'],
      'total_order': responseJson['total_order'],
      'total_row': responseJson['pagination']['total_row'],
    };
  }

  static Future<List<OrderListModel>> fetchOrderList(String params) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order?$params');
    List<dynamic> orderList;

    var jsonResponse = jsonDecode(response.toString());
    orderList = (jsonResponse as Map<String, dynamic>)['list'];
    return orderList.map((e) => new OrderListModel.fromJson(e)).toList();
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

  static Future<List<dynamic>> fetchTopCustomer() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order/customer/s/top');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }
}
