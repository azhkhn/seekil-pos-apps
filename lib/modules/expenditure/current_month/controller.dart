import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';

class ExpenditureCurrentMonthController extends GetxController with StateMixin {
  final formKey = GlobalKey<FormState>();
  RxInt totalExpenditureCurrentMonth = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentMonth();
  }

  Future<void> fetchCurrentMonth() async {
    try {
      change(null, status: RxStatus.loading());

      Map<String, dynamic> expenditureData =
          await ExpenditureModel.fetchCashFlowCurrentMonth();
      totalExpenditureCurrentMonth.value =
          expenditureData['expenditure']['spending_money'];

      Map<String, dynamic> data =
          await ExpenditureModel.fetchPeriodSpendingMoney('current-month');

      if (data['list'].length > 0) {
        change(data, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } on DioError catch (e) {
      change(e.message, status: RxStatus.error());
    }
  }

  void onSavedForm(ExpenditureModel model) async {
    if (formKey.currentState!.validate()) {
      try {
        Get.back();
        isLoading.value = true;
        bool isCreated = await ExpenditureModel().createSpendingMoney(model);

        if (isCreated) {
          isLoading.value = false;
          fetchCurrentMonth();
          Fluttertoast.showToast(msg: 'Berhasil tambah data');
        } else {
          isLoading.value = false;
          Fluttertoast.showToast(msg: 'Gagal tambah data');
        }
      } on DioError catch (e) {
        isLoading.value = false;
        Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
      }
    }
  }

  void onUpdateItem(String id, Map<String, dynamic> data) async {
    try {
      Get.back();
      isLoading.value = true;
      bool isCreated = await ExpenditureModel.updateSpendingMoney(id, data);

      if (isCreated) {
        isLoading.value = false;
        fetchCurrentMonth();
        Fluttertoast.showToast(msg: 'Berhasil update data');
      }
    } on DioError catch (error) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${error.message}');
    }
  }

  void onDeleteItem(String id) async {
    try {
      Get.back();
      isLoading.value = true;
      bool isDeleted = await ExpenditureModel.deleteSpendingMoneyById(id);

      if (isDeleted) {
        isLoading.value = false;
        fetchCurrentMonth();
        Fluttertoast.showToast(msg: 'Berhasil hapus data');
      }
    } on DioError catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }
}
