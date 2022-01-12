import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/auth/controller.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain,
                    height: 90.0,
                    alignment: Alignment.center,
                  ),
                  Column(
                    children: [
                      Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 32.0),
                                child: Text(
                                  'Masuk untuk melanjutkan',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              MyFormField(
                                label: 'Username',
                                isMandatory: true,
                                controller: controller.usernameController,
                                textFieldValidator:
                                    controller.usernameValidator,
                                textCapitalization: TextCapitalization.none,
                              ),
                              Obx(
                                () => MyFormField(
                                    label: 'Password',
                                    isMandatory: true,
                                    controller: controller.passwordController,
                                    textFieldValidator:
                                        controller.passwordValidator,
                                    obscureText: controller.isObscureText.value,
                                    textCapitalization: TextCapitalization.none,
                                    suffixIcon: IconButton(
                                        onPressed:
                                            controller.onChangeObscureText,
                                        icon: controller.isObscureText.isTrue
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility))),
                              ),
                            ],
                          )),
                      Container(
                        width: Get.width,
                        child: ElevatedButton(
                          onPressed: controller.onSubmitLogin,
                          child: Text('Masuk'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              primary: ColorConstant.DEF,
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
          Obx(() => Visibility(
                child: LoadingIndicator(),
                visible: controller.showLoading.isTrue,
              ))
        ],
      ),
    );
  }
}
