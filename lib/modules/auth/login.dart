import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain,
                height: 70.0,
                alignment: Alignment.center,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Masuk untuk melanjutkan',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Form(
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
                      MyFormField(
                        label: 'Password',
                        isMandatory: true,
                        controller: controller.passwordController,
                        textFieldValidator: controller.passwordValidator,
                        obscureText: true,
                        textCapitalization: TextCapitalization.none,
                      ),
                      Container(
                        width: Get.width,
                        child: ElevatedButton(
                          onPressed: controller.onSubmitLogin,
                          child: Text('Masuk'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                        ),
                      )
                    ],
                  )),
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
