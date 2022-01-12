import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderListController extends GetxController with StateMixin {
  final paymentStatus = Rxn<String>().obs;
  final orderStatusId = Rxn<int>().obs;
  final dateRange = Rxn<String>().obs;
  RxInt selectedFilter = 0.obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchController.text = '';
  }

  @override
  void onClose() {
    super.onClose();
    resetObjectParam();
  }

  void resetObjectParam() {
    paymentStatus.value.value = null;
    orderStatusId.value.value = null;
    dateRange.value.value = null;
  }

  bool paramsValidation() {
    bool isValid = false;

    if (paymentStatus.value.value != null ||
        orderStatusId.value.value != null) {
      isValid = true;
    }

    return isValid;
  }

  String objectParamToQueryString() {
    String queryParam = '';
    Map<String, dynamic> objectParam = {
      'payment_status': paymentStatus.value.value,
      'order_status_id': orderStatusId.value.value,
    };
    objectParam.removeWhere((key, value) => value == null);
    Map<String, dynamic> removedNullValue = objectParam;
    selectedFilter.value = removedNullValue.length;

    if (paramsValidation()) {
      queryParam = Uri(
          queryParameters: removedNullValue
              .map((key, value) => MapEntry(key, value.toString()))).query;

      if (dateRange.value.value != null) {
        queryParam += '&${dateRange.value.value!}';
      }
    }

    return queryParam;
  }

  void onSearch() {}

  void handleResetSearchController() {
    searchController.text = '';
  }

  void handleChangePaymentStatus(String? newValue) {
    if (paymentStatus.value.value == null) {
      paymentStatus.value.value = newValue;
    } else {
      paymentStatus.value.value = null;
    }
  }

  void handleChangeOrderStatus(int? newValue) {
    if (orderStatusId.value.value == null) {
      orderStatusId.value.value = newValue;
    } else {
      orderStatusId.value.value = null;
    }
  }

  void handleChangeDateRange(String? value) {
    dateRange.value.value = value;
  }
}
