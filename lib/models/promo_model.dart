import 'package:dio/dio.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class PromoModel {
  int? id;
  String? name;
  String? code;
  int? discount;
  String? description;
  String? startDate;
  String? endDate;
  int? status;

  PromoModel(
      {this.id,
      this.name,
      this.code,
      this.discount,
      this.description,
      this.startDate,
      this.endDate,
      this.status});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'discount': discount,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }

  factory PromoModel.fromMap(Map<String, dynamic> map) {
    return PromoModel(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      discount: map['discount'],
      description: map['description'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      status: map['status'],
    );
  }

  static Future<bool> addNewPromo(Map<String, dynamic> data) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.post('master/promo', data);

      if (response.data['meta']['code'] == 200) {
        return true;
      }
      return false;
    } on DioError {
      return false;
    }
  }

  static Future<bool> updatePromoById(
      String id, Map<String, dynamic> data) async {
    try {
      SeekilApi seekilApi = SeekilApi();
      Response response = await seekilApi.put('master/promo/$id', data);

      if (response.data['meta']['code'] == 200) {
        return true;
      }
      return false;
    } on DioError {
      return false;
    }
  }
}
