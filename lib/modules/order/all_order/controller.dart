import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_list.model.dart';

class AllOrderController extends GetxController with StateMixin {
  TextEditingController searchController = TextEditingController();

  RxString filterPaymentStatusTitle =
      GeneralConstant.FILTER_PAYMENT_STATUS_DEFAULT.obs;
  RxString filterPaymentMethodTitle =
      GeneralConstant.FILTER_PAYMENT_METHOD_DEFAULT.obs;
  RxString filterDateTitle = GeneralConstant.FILTER_ORDER_DATE_DEFAULT.obs;
  RxString filterOrderStatusTitle =
      GeneralConstant.FILTER_ONGOING_TRANSACTION_DEFAULT.obs;

  RxList filterPaymentStatusList = GeneralConstant.filterPaymentStatus.obs;
  RxList filterDateList = GeneralConstant.filterDateMenu.obs;
  RxList filterOrderStatusList = [].obs;
  RxList filterPaymentMethodList = [].obs;

  RxBool isCustomDate = false.obs;
  RxMap gvFilterDate = {}.obs;
  RxString queryParameters = ''.obs;
  final objectFilter = RxMap({
    'order_type_id': '',
    'order_status_id': '',
    'payment_method_id': '',
    'payment_status': '',
    'customer_name': '',
    'start_date': '',
    'end_date': '',
  }).obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderList();
    fetchMasterData();
  }

  String checkQueryParams() {
    // Remove key if value is empty
    objectFilter.value.removeWhere((key, value) => value == '');
    // If all value is empty
    // provide query params as empty value = ''
    // if one of more value is available
    // provide query params with given key-value
    return queryParameters.value = objectFilter.value == {}
        ? ''
        : Uri(queryParameters: objectFilter.value).query;
  }

  Future<void> fetchOrderList() async {
    String queryParams = checkQueryParams();
    try {
      change(null, status: RxStatus.loading());
      List<OrderListModel> data =
          await OrderListModel.fetchOrderList(queryParams);

      if (data.isNotEmpty) {
        change(data, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  Future<void> fetchMasterData() async {
    filterOrderStatusList.value = await MasterDataModel.fetchMasterStatus();
    filterPaymentMethodList.value =
        await MasterDataModel.fetchMasterPaymentMethod();
  }

  void handleSearchBar(String value) {
    objectFilter.value['customer_name'] = value;
    fetchOrderList();
  }

  void resetSearchBar() {
    searchController.text = '';
    objectFilter.value['customer_name'] = '';
    fetchOrderList();
  }

  void resetQueryParam() {
    objectFilter.value = RxMap({
      'order_type_id': '',
      'order_status_id': '',
      'payment_method_id': '',
      'payment_status': '',
      'customer_name': '',
      'start_date': '',
      'end_date': ''
    });
    filterPaymentStatusTitle.value =
        GeneralConstant.FILTER_PAYMENT_STATUS_DEFAULT;
    filterPaymentMethodTitle.value =
        GeneralConstant.FILTER_PAYMENT_METHOD_DEFAULT;
    filterOrderStatusTitle.value =
        GeneralConstant.FILTER_ONGOING_TRANSACTION_DEFAULT;
    filterDateTitle.value = GeneralConstant.FILTER_ORDER_DATE_DEFAULT;
    resetSearchBar();
  }

  void onChangedPaymentStatus(dynamic value) {
    objectFilter.value['payment_status'] = value['value'];
    filterPaymentStatusTitle.value = value['name'];
    Get.back();
    fetchOrderList();
  }

  void onChangedPaymentMethod(dynamic value) {
    objectFilter.value['payment_method_id'] = value['id'].toString();
    filterPaymentMethodTitle.value = value['name'];
    Get.back();
    fetchOrderList();
  }

  void onChangedOrderStatus(dynamic value) {
    objectFilter.value['order_status_id'] = value['id'].toString();
    filterOrderStatusTitle.value = value['name'];
    Get.back();
    fetchOrderList();
  }

  void onChangedDate(dynamic value) {
    if (value['value'] != 'custom') {
      isCustomDate.value = false;
      objectFilter.value['start_date'] = value['value']['start_date'];
      objectFilter.value['end_date'] = value['value']['end_date'];
      filterDateTitle.value = value['name'];
      Get.back();
      fetchOrderList();
    } else {
      isCustomDate.value = true;
    }
  }
}
