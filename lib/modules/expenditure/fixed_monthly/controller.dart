import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';

class ExpenditureFixedMonthlyController extends GetxController with StateMixin {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFixedMonthlyData();
  }

  Future<void> fetchFixedMonthlyData() async {
    try {
      change(null, status: RxStatus.loading());
      Map<String, dynamic> data =
          await ExpenditureModel.fetchAllFixedMonthlyExpenses();

      if (data['list'] != null || data['list'].isNotEmpty) {
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
        bool isCreated =
            await ExpenditureModel().createFixedMonthlyExpenses(model);

        if (isCreated) {
          isLoading.value = false;
          fetchFixedMonthlyData();
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
      bool isCreated =
          await ExpenditureModel.updateFixedMonthlyExpenses(id, data);

      if (isCreated) {
        isLoading.value = false;
        fetchFixedMonthlyData();
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
      bool isDeleted =
          await ExpenditureModel.deleteFixedMonthlyExpensesById(id);

      if (isDeleted) {
        isLoading.value = false;
        fetchFixedMonthlyData();
        Fluttertoast.showToast(msg: 'Berhasil hapus data');
      }
    } on DioError catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }
}
