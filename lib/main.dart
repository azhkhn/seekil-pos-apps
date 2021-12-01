import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/main.widget.dart';
import 'package:seekil_back_office/routes/pages.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/bluetooth_helper.dart';

void main() async {
  await GetStorage.init();
  BluetoothHelper().initSavetoPath();

  runApp(GetMaterialApp(
    title: 'Seekil Back Office',
    initialRoute: AppRoutes.splashScreen,
    getPages: AppPages.appPages,
    debugShowCheckedModeBanner: false,
    home: MainWidget(),
    theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
        textTheme: TextTheme(
            bodyText2: TextStyle(letterSpacing: -0.5),
            // AppBar Style
            headline6: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black),
            // List Title Style
            subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))),
  ));
}