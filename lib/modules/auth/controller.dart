import 'dart:convert';
import 'package:dio/dio.dart' as D;
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/utilities/services/seekil_api.dart';

class LoginController extends GetxController with StateMixin {
  final box = GetStorage();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool showLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController.text = '';
    passwordController.text = '';
  }

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    passwordController.dispose();
  }

  String? usernameValidator(String? value) {
    if (value == null || value == '') {
      return 'Username harus diisi';
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value == '') {
      return 'Password harus diisi';
    }
  }

  void onSubmitLogin() async {
    SeekilApi seekilApi = SeekilApi();

    if (formKey.currentState!.validate()) {
      try {
        showLoading.value = true;
        D.Response response = await seekilApi.post('auth/login', {
          'username': usernameController.text.toLowerCase(),
          'password': passwordController.text.toLowerCase()
        });
        var responseJson = jsonDecode(response.toString());

        if (responseJson['data'] != null) {
          box.write(StorageKeyConstant.USER_LOGGED_IN, responseJson['data']);
          Get.offAllNamed(AppRoutes.mainWidget);
        } else {
          showLoading.value = false;
          SnackbarHelper.show(
              title: GeneralConstant.ERROR_TITLE,
              message: GeneralConstant.FAILED_LOGIN);
        }
      } on D.DioError catch (e) {
        showLoading.value = false;
        SnackbarHelper.show(
            title: GeneralConstant.ERROR_TITLE, message: e.toString());
      }
    }
  }
}
