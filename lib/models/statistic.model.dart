import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class StatisticModel {
  final String? month;
  final int? year;
  final int? totalItems;
  final int? total;

  StatisticModel({
    this.month,
    this.year,
    this.totalItems,
    this.total,
  });

  factory StatisticModel.fromJson(Map<String, dynamic> json) {
    return StatisticModel(
      year: json['year'],
      month: json['month'],
      total: json['total'],
      totalItems: json['total_items'],
    );
  }

  static Future<List<StatisticModel>> fetchStatistic({String? params}) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = params != null
          ? await seekilApi.get('/statistic/month-in-year?$params')
          : await seekilApi.get('/statistic/month-in-year');
      List<dynamic> data = response.data['list'];

      return data.map((e) => StatisticModel.fromJson(e)).toList();
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
