import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_list.model.dart';

var defaultObjectFilter = {
  'order_type_id': '',
  'order_status_id': '',
  'payment_method_id': '',
  'payment_status': '',
  'customer_name': '',
  'start_date': '',
  'end_date': '',
};

class AllOrderController extends GetxController with StateMixin {
  TextEditingController searchController = TextEditingController();

  RxList filterPaymentStatusList = GeneralConstant.filterPaymentStatus.obs;
  RxList filterDateList = GeneralConstant.filterDateMenu.obs;
  RxList filterOrderStatusList = [].obs;
  RxList filterPaymentMethodList = [].obs;

  RxMap gvFilterDate = {}.obs;
  RxString queryParameters = ''.obs;
  RxString filterCount = ''.obs;

  final objectFilter = RxMap(defaultObjectFilter).obs;

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
    filterCount.value = objectFilter.value.length.toString();
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
    gvFilterDate.value = {};
    objectFilter.value = RxMap(defaultObjectFilter);
  }

  void onChangeFilterPaymentStatus(dynamic value) {
    objectFilter.value['payment_status'] = value['value'];
  }

  void onChangeFilterOrderStatus(dynamic value) {
    objectFilter.value['order_status_id'] = value['id'].toString();
  }

  void onApplyFilter() {
    Get.back();
    fetchOrderList();
  }

  void onChangedDate(dynamic value) {
    if (value['value'] != 'custom') {
      gvFilterDate.value = value;
      objectFilter.value['start_date'] = value['value']['start_date'];
      objectFilter.value['end_date'] = value['value']['end_date'];
    }
  }
}
