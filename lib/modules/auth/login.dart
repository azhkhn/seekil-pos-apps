import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/auth/controller.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // toolbarHeight: 24.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Silahkan masuk untuk melanjutkan!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: SvgPicture.asset(
                'assets/svg/login.svg',
                fit: BoxFit.contain,
                height: 200.0,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    MyFormField(
                      label: 'Username',
                      isMandatory: true,
                      controller: controller.usernameController,
                      textFieldValidator: controller.usernameValidator,
                      textCapitalization: TextCapitalization.none,
                    ),
                    Obx(
                      () => MyFormField(
                        label: 'Password',
                        isMandatory: true,
                        controller: controller.passwordController,
                        textFieldValidator: controller.passwordValidator,
                        obscureText: controller.isObscureText.value,
                        textCapitalization: TextCapitalization.none,
                        suffixIcon: IconButton(
                          onPressed: controller.onChangeObscureText,
                          icon: controller.isObscureText.isTrue
                              ? Icon(
                                  Icons.visibility,
                                  color: ColorConstant.DEF,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: ColorConstant.DEF,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      width: Get.width,
                      margin: EdgeInsets.only(top: 16.0),
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.showLoading.isFalse
                              ? controller.onSubmitLogin
                              : () {},
                          child: controller.showLoading.isFalse
                              ? Text('Masuk')
                              : SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.grey.shade300,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                          style: ElevatedButton.styleFrom(
                            primary: ColorConstant.DEF,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
