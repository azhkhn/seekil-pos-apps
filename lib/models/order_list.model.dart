import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
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

  static Future<List<OrderListModel>> fetchOrderList(
    String params, [
    String page = '0',
  ]) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order?$params&page=$page');
    List<dynamic> orderList;

    var jsonResponse = jsonDecode(response.toString());
    orderList = (jsonResponse as Map<String, dynamic>)['list'];
    return orderList.map((e) => new OrderListModel.fromJson(e)).toList();
  }

  static Future<List<dynamic>> fetchTopCustomer() async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order/customer/s/top');
    List<dynamic> data = jsonDecode(response.toString())['list'];
    return data;
  }

  static Future<bool> deleteOrderByOrderId(String orderId) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.delete('order/$orderId');
    var responseCode = jsonDecode(response.toString())['meta']['code'];

    if (responseCode == 200) {
      return true;
    }
    return false;
  }
}
