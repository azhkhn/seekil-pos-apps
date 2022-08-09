import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class StoreController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  late TabController tabController;

  void onInit() {
    tabController = new TabController(length: 2, vsync: this);
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {} on DioError catch (e) {
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }
}
