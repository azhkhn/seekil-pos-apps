import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/modules/order/all_order/views/lists.dart';
import 'package:seekil_back_office/modules/order/all_order/views/search_bar.dart';

class AllOrder extends StatelessWidget {
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.my_library_books_outlined),
                color: Colors.black,
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AllOrderSearchBar(),
          ),
        ),
        body: AllOrderList(),
      ),
    );
  }
}
