import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class WidgetHelper {
  static PreferredSizeWidget appBar(String title,
      {PreferredSizeWidget? bottom,
      double titleSize = 18.0,
      List<Widget>? actions,
      double? toolbarHeight,
      Color backgroundColor = Colors.white}) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 2.0,
      iconTheme: IconThemeData(color: Colors.black),
      toolbarHeight: toolbarHeight,
      bottom: bottom,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      title: Text(title),
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: titleSize,
          fontWeight: FontWeight.w500),
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

  static bottomSheet(
    BuildContext innerContext, {
    required void Function() onClosing,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = false,
    bool isFullScreen = false,
    bool isCenterChild = false,
    String? title,
  }) {
    return Get.bottomSheet(
      BottomSheet(
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        onClosing: onClosing,
        builder: (innerContext) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: isFullScreen
                ? SafeArea(
                    child: Column(
                      crossAxisAlignment: isCenterChild
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Container(
                            margin: EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Icon(Icons.close_rounded),
                                  onTap: () => Get.back(),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        child,
                      ],
                    ),
                  )
                : Wrap(
                    alignment: isCenterChild
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    children: [
                      if (title != null)
                        Container(
                          margin: EdgeInsets.only(bottom: 24.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Icon(Icons.close_rounded),
                                onTap: () => Get.back(),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      child,
                    ],
                  ),
          );
        },
      ),
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      ignoreSafeArea: isFullScreen ? false : true,
    );
  }

  static Widget bottomSheetButton({
    required void Function()? onPressed,
    required String title,
    Color titleColor = Colors.white,
    Color? backgroundColor = ColorConstant.DEF,
  }) {
    return Container(
      width: Get.width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
