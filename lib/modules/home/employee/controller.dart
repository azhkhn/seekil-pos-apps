import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/auth.model.dart';
import 'package:seekil_back_office/repository/employee_repository.dart';

class EmployeeController extends GetxController with StateMixin {
  void onInit() {
    super.onInit();
    fetchEmployee();
  }

  Future<void> fetchEmployee() async {
    try {
      change(null, status: RxStatus.loading());
      List<AuthModel?>? data = await EmployeeRepository.fetchEmployee();

      if (data != null && data.length > 0) {
        change(data, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error(e.message));
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: ${e.message}');
    }
  }
}
