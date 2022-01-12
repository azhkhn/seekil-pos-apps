import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class OrderCurrentMonthCardContainer extends StatelessWidget {
  const OrderCurrentMonthCardContainer(
      {Key? key,
      required this.children,
      required this.title,
      this.backgroundColor = ColorConstant.DEF})
      : super(key: key);
  final List<Widget> children;
  final String title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Container(
            child: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0)),
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            width: Get.width,
            margin: EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            ),
          ),
          ...children
        ],
      ),
    );
  }
}

class CardContainerRowChild extends StatelessWidget {
  const CardContainerRowChild({Key? key, required this.children})
      : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children),
    );
  }
}
