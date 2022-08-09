import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/promo_model.dart';
import 'package:seekil_back_office/utilities/helper/pretty_print.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

Map<String, dynamic> defaultSelectedDateValue = {
  'start_date': '',
  'end_date': ''
};
Map<String, dynamic> defaultDateValue = {'start_date': '', 'end_date': ''};

class PromoController extends GetxController with StateMixin {
  final WordTransformation wt = WordTransformation();
  final addPromoFormKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool addPromoSwitchValue = false.obs;
  final dateValue = RxMap(defaultDateValue).obs;
  final selectedDateTitle = RxMap(defaultSelectedDateValue).obs;

  void onInit() {
    super.onInit();
    fetchPromoList();
  }

  Future<void> fetchPromoList() async {
    try {
      isLoading.value = true;
      change(null, status: RxStatus.loading());

      List<PromoModel>? data = await MasterDataModel.fetchMasterPromo();

      if (data != null && data.length > 0) {
        isLoading.value = false;
        change(data, status: RxStatus.success());
      } else {
        isLoading.value = false;
        change(null, status: RxStatus.empty());
      }
    } on DioError {
      isLoading.value = false;
    }
  }

  void onUpdatePromo(PromoModel model, {bool isFromOnChange = false}) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {
        'id': model.id,
        'name': model.name,
        'code': model.code,
        'discount': model.discount,
        'description': model.description,
        'startDate': model.startDate,
        'endDate': model.endDate,
        'status': model.status,
      };

      prettyPrintJson(data);

      bool isUpdated =
          await PromoModel.updatePromoById(model.id.toString(), data);

      if (isUpdated) {
        isLoading.value = false;
        fetchPromoList();
        Fluttertoast.showToast(msg: 'Berhasil update promo');
      } else {
        isLoading.value = false;
        fetchPromoList();
        Fluttertoast.showToast(msg: 'Gagal update promo');
      }
    } on DioError catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }

  bool valueSwitchPromo(int? status) {
    if (status != null) {
      if (status == 1) {
        return true;
      }
      return false;
    }
    return false;
  }

  void onChangeSwitchPromo(bool value, int index, PromoModel item) {
    if (value) {
      item.status = 1;
      update();
    } else {
      item.status = 0;
      update();
    }

    onUpdatePromo(PromoModel(
      id: item.id,
      name: item.name,
      code: item.code,
      description: item.description,
      discount: item.discount,
      startDate: item.startDate,
      endDate: item.endDate,
      status: item.status,
    ));
  }

  void onAddPromo(PromoModel model) async {
    if (addPromoFormKey.currentState!.validate()) {
      try {
        // Close Bottomsheet
        Get.back();
        isLoading.value = true;
        bool isCreated = await PromoModel.addNewPromo(model.toMap());

        if (isCreated) {
          Fluttertoast.showToast(msg: 'Berhasil tambah promo');
          fetchPromoList();
        } else {
          Fluttertoast.showToast(msg: 'Gagal tambah promo');
          fetchPromoList();
        }
      } on DioError catch (e) {
        Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 356)),
      lastDate: DateTime.now().add(Duration(days: 356)),
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (pickedDateTime != null) {
      return pickedDateTime;
    } else {
      return DateTime.now();
    }
  }

  void onSelectedDate(DateTime? pickedDateTime, String dateType) {
    String selectedDate = wt.dateFormatter(
      date: pickedDateTime.toString(),
    );
    String formattedSelectedDate = wt.dateFormatter(
      date: pickedDateTime.toString(),
      type: DateFormatType.dateData,
    );
    dateValue.value[dateType] = formattedSelectedDate;
    selectedDateTitle.value[dateType] = selectedDate;
  }

  void resetDateValue() {
    dateValue.value = RxMap(defaultDateValue);
    selectedDateTitle.value = RxMap(defaultSelectedDateValue);
  }
}
