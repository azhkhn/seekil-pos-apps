import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/modules/order/all_order/views/filter.dart';
import 'package:seekil_back_office/modules/order/all_order/views/lists.dart';
import 'package:seekil_back_office/modules/order/all_order/views/search_bar.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';

class AllOrder extends StatelessWidget {
  AllOrder({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Semua Transaksi'),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          if (AuthHelper.isSuperAdmin())
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.insert_chart_outlined_rounded),
                color: Colors.black,
              ),
            )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AllOrderSearchBar(),
                AllOrderFilter(),
              ],
            ),
          ),
        ),
      ),
      body: AllOrderList(),
    );
  }
}
