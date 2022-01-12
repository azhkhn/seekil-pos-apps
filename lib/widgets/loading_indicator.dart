import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 10,
                blurRadius: 5,
                offset: Offset(0, 7), // changes position of shadow
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: ColorConstant.DEF,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  height: 16.0,
                  width: 16.0,
                  margin: EdgeInsets.only(right: 16.0),
                  child: CircularProgressIndicator(
                    color: Colors.grey.shade300,
                    strokeWidth: 2.0,
                  ),
                ),
                Text('Memproses...',
                    style: TextStyle(color: Colors.white, fontSize: 16.0))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
