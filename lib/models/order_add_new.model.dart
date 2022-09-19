import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';

class OrderAddNewModel {
  List<dynamic>? items;
  String? customerName, whatsapp, pickupAddress, paymentStatus, customerId;
  int? id,
      points,
      orderTypeId,
      storeId,
      partnershipId,
      paymentMethodId,
      promoId,
      pickupDeliveryPrice,
      potongan,
      downPayment,
      qty,
      total;

  OrderAddNewModel({
    this.items,
    this.customerName,
    this.whatsapp,
    this.pickupAddress,
    this.paymentStatus,
    this.pickupDeliveryPrice,
    this.customerId,
    this.id,
    this.points,
    this.orderTypeId,
    this.storeId,
    this.partnershipId,
    this.paymentMethodId,
    this.promoId,
    this.potongan,
    this.downPayment,
    this.qty,
    this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customer_id": customerId,
      "customer_name": customerName,
      "whatsapp": whatsapp != null ? '62$whatsapp' : null,
      "points": points,
      "order_type_id": orderTypeId,
      "store_id": storeId,
      "pickup_address": pickupAddress,
      "partnership_id": partnershipId,
      "payment_method_id": paymentMethodId,
      "payment_status": paymentStatus,
      "order_status_id": 1,
      "promo_id": promoId,
      "pickup_delivery_price": pickupDeliveryPrice ?? null,
      "potongan": potongan,
      "qty": qty,
      "down_payment": downPayment,
      "total": total != null
          ? total
          : OrderUtils().getTotal(
              pickupDeliveryPrice: pickupDeliveryPrice,
              points: points,
              potongan: potongan,
              items: items),
      "items": items
    };
  }

  Future<Response> createOrder(dynamic data) async {
    SeekilApi seekilApi = SeekilApi();
    Response response = await seekilApi.post('order', data);
    return response;
  }
}
