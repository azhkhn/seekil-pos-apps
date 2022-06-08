import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/statistic.model.dart';

class StatisticController extends GetxController with StateMixin {
  RxList spots = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      change(null, status: RxStatus.loading());
      List<StatisticModel> data = await StatisticModel.fetchStatistic();

      if (data.isNotEmpty) {
        change(data, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }
}
