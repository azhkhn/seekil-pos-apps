import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class OrderDetailForEditModel {
  int? orderStatusId;
  int? paymentMethodId;
  String? paymentStatus;

  OrderDetailForEditModel({
    this.orderStatusId,
    this.paymentMethodId,
    this.paymentStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_status_id': orderStatusId,
      'payment_method_id': paymentMethodId,
      'payment_status': paymentStatus
    };
  }
}

class OrderDetailModel {
  String orderStatusName, orderId, orderType, orderDate, customerName;
  String? storeName, pickupAddress, dropZone;
  String? paymentMethodName, paymentStatus, whatsapp;
  int? itemSubtotal,
      orderStatus,
      paymentMethod,
      ongkir,
      promo,
      total,
      qty,
      points;

  OrderDetailModel({
    required this.orderStatus,
    required this.orderStatusName,
    required this.orderId,
    required this.orderType,
    required this.storeName,
    required this.pickupAddress,
    required this.dropZone,
    required this.customerName,
    required this.paymentMethodName,
    required this.whatsapp,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.itemSubtotal,
    required this.ongkir,
    required this.promo,
    required this.total,
    required this.qty,
    required this.orderDate,
    required this.points,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderDate: json['order_date'],
      orderStatus: json['order_status_id'],
      orderStatusName: json['master_status']['name'],
      orderId: json['order_id'],
      orderType: json['master_type']['name'],
      storeName:
          json['master_store'] != null ? json['master_store']['staging'] : null,
      dropZone: json['master_partnership'] != null
          ? json['master_partnership']['name']
          : null,
      pickupAddress:
          json['customer'] != null ? json['customer']['address'] : null,
      customerName: json['customer'] != null
          ? json['customer']['name'].replaceAll('-', ' ')
          : null,
      whatsapp: json['customer'] != null ? json['customer']['whatsapp'] : null,
      paymentMethod: json['payment_method_id'],
      paymentMethodName: json['master_payment_method']['name'],
      paymentStatus: json['payment_status'],
      itemSubtotal: json['items'] != null ? json['items'] : 0,
      ongkir: json['pickup_delivery_price'] != null
          ? json['pickup_delivery_price']
          : 0,
      points: json['points'] != null ? json['points'] : 0,
      promo: json['potongan'] != null ? json['potongan'] : 0,
      qty: json['qty'] != null ? json['qty'] : 0,
      total: json['total'] != null ? json['total'] : 0,
    );
  }

  static Future<OrderDetailModel> fetchOrderDetail(String orderId) async {
    final box = GetStorage();
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order/$orderId');
    Map<String, dynamic> data = jsonDecode(response.toString())['data'];
    var responseJson = OrderDetailModel.fromJson(data);

    box.write(StorageKeyConstant.ORDER_DETAIL, responseJson);

    return responseJson;
  }

  static Future<Response> updateOrder(String orderId, dynamic data) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.put('order/$orderId', data);
    return response;
  }

  static Future<String> fetchOrderInvoice(String orderId) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('invoice/$orderId');
    String data = jsonDecode(response.toString())['data'];

    return data;
  }

  static Future<List<dynamic>> fetchOrderTracking(String orderId) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.get('order/$orderId/tracker');
    List<dynamic> orderTrackingList;

    var jsonResponse = jsonDecode(response.toString());
    orderTrackingList = (jsonResponse as Map<String, dynamic>)['list'];

    return orderTrackingList
        .map((json) => {
              'updatedAt': json['updatedAt'],
              'status': json['master_status']['name'],
              'description': json['master_status']['description']
            })
        .toList();
  }
}
