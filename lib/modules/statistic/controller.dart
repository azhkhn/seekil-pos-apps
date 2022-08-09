import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/models/statistic.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class StatisticController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final WordTransformation wt = WordTransformation();

  RxList spots = [].obs;
  RxString selectedDate = 'Pilih Tanggal'.obs;
  final selectedStartDate = Rxn<DateTime>();
  final selectedEndDate = Rxn<DateTime>();
  final dataPengeluaran = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchData();
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> fetchData() async {
    try {
      change(null, status: RxStatus.loading());

      List<StatisticModel> data;

      if (selectedStartDate.value != null && selectedEndDate.value != null) {
        String startDate = wt.dateFormatter(
            date: selectedStartDate.value.toString(),
            type: DateFormatType.dateData);
        String endDate = wt.dateFormatter(
            date: selectedEndDate.value.toString(),
            type: DateFormatType.dateData);
        String params = 'start_date=$startDate&end_date=$endDate';

        data = await StatisticModel.fetchStatistic(params: params);
        dataPengeluaran.value =
            await ExpenditureModel.fetchAllSpendingMoney(params: params);
      } else {
        data = await StatisticModel.fetchStatistic();
        dataPengeluaran.value = await ExpenditureModel.fetchAllSpendingMoney();
      }

      if (data.isNotEmpty) {
        change(data, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  void onChangeDateRangePicker(DateTimeRange? result) {
    if (result == null) {
      print('result kosong');
    } else {
      DateTime startDate = result.start;
      DateTime endDate = result.end;

      selectedStartDate.value = startDate;
      selectedEndDate.value = endDate;
      selectedDate.value =
          '${wt.dateFormatter(date: startDate.toString())} - ${wt.dateFormatter(date: endDate.toString())}';
      fetchData();
    }
  }

  void resetDateRangePicker() {
    selectedStartDate.value = null;
    selectedEndDate.value = null;
    selectedDate.value = 'Pilih Tanggal';
    fetchData();
  }
}
