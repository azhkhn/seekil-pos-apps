import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class WidgetHelper {
  static PreferredSizeWidget appBar(String title,
      {PreferredSizeWidget? bottom, List<Widget>? actions}) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      bottom: bottom,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  static Widget badgeText(String text,
      {Color? badgeColor = ColorConstant.DEF,
      Color? textColor = Colors.white}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Text(text,
          style: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.bold, color: textColor)),
    );
  }
}
