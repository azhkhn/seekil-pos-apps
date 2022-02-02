import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
      appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light)),
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
              child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Text(
                        'v${snapshot.data!.version}+${snapshot.data!.buildNumber}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ))
        ],
      ),
    );
  }
}
