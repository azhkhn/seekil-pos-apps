import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';

class ExpenditureCurrentMonthController extends GetxController with StateMixin {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentMonth();
  }

  Future<void> fetchCurrentMonth() async {
    try {
      change(null, status: RxStatus.loading());
      Map<String, dynamic> data =
          await ExpenditureModel.fetchPeriodSpendingMoney('current-month');

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
      Get.back();
      isLoading.value = true;
      bool isCreated = await ExpenditureModel().createSpendingMoney(model);

      if (isCreated) {
        isLoading.value = false;
        fetchCurrentMonth();
        SnackbarHelper.show(
            snackStatus: SnackStatus.SUCCESS,
            title: 'Berhasil',
            message: 'Data pengeluaran berhasil dibuat');
      } else {
        isLoading.value = false;
        SnackbarHelper.show(
            title: GeneralConstant.ERROR_TITLE,
            snackStatus: SnackStatus.ERROR,
            message: 'Gagal tambah data pengeluaran');
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
        SnackbarHelper.show(
            snackStatus: SnackStatus.SUCCESS,
            title: 'Berhasil',
            message: 'Data pengeluaran berhasil diupdate');
      }
    } catch (error) {
      isLoading.value = false;
      SnackbarHelper.show(
          title: GeneralConstant.ERROR_TITLE, message: error.toString());
    }
  }
}
