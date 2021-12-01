import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      bool isLoggedIn = box.read(StorageKeyConstant.USER_LOGGED_IN) != null;

      if (isLoggedIn) {
        Get.offAllNamed(AppRoutes.mainWidget);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
                height: 100.0,
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text('Back Office',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.grey)))
        ],
      ),
    );
  }
}
