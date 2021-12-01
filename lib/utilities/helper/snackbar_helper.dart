import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

enum SnackStatus { SUCCESS, ERROR, INFO }

class SnackbarHelper {
  static void show({
    required String title,
    required String message,
    bool withBottomNavigation = false,
    String? mainButtonTitle,
    void Function()? mainButtonAction,
    SnackStatus? snackStatus,
  }) {
    double defaultMargin = 16.0;

    Color snackbarBackgroundByStatus() {
      Color bgColor;

      switch (snackStatus) {
        case SnackStatus.SUCCESS:
          bgColor = ColorConstant.SUCCESS;
          break;
        case SnackStatus.ERROR:
          bgColor = ColorConstant.ERROR;
          break;
        case SnackStatus.INFO:
          bgColor = ColorConstant.INFO;
          break;
        default:
          bgColor = ColorConstant.DEF;
          break;
      }
      return bgColor;
    }

    Color snackbarBorderColor() {
      Color borderColor;

      switch (snackStatus) {
        case SnackStatus.ERROR:
          borderColor = ColorConstant.ERROR_BORDER;
          break;
        case SnackStatus.INFO:
          borderColor = ColorConstant.INFO_BORDER;
          break;
        case SnackStatus.SUCCESS:
        default:
          borderColor = ColorConstant.DEF;
          break;
      }
      return borderColor;
    }

    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: snackbarBackgroundByStatus(),
        colorText: snackStatus != null ? Colors.black : Colors.white,
        margin: !withBottomNavigation
            ? EdgeInsets.all(defaultMargin)
            : EdgeInsets.fromLTRB(defaultMargin, defaultMargin, defaultMargin,
                kBottomNavigationBarHeight + defaultMargin),
        borderRadius: 8.0,
        borderColor: snackbarBorderColor(),
        borderWidth: 1.0,
        mainButton: mainButtonAction != null || mainButtonTitle != null
            ? TextButton(
                onPressed: mainButtonAction,
                child: Text(mainButtonTitle as String,
                    style: TextStyle(
                        color:
                            snackStatus != null ? Colors.black : Colors.white)))
            : null);
  }
}
