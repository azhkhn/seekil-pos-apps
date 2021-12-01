import 'package:flutter/material.dart';
import 'package:seekil_back_office/modules/home/views/order_section_all_order.dart';
import 'package:seekil_back_office/modules/home/views/order_section_current_month.dart';
import 'package:seekil_back_office/modules/home/views/order_section_current_month_temp.dart';
import 'package:seekil_back_office/modules/home/views/order_section_most_services.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class HomeOrderSection extends StatelessWidget {
  HomeOrderSection(
      {Key? key,
      required this.orderList,
      required this.orderListItems,
      required this.orderCurrentMonth,
      required this.topServices})
      : super(key: key);

  final Future<Map<String, dynamic>> orderList;
  final Future<Map<String, dynamic>> orderListItems, orderCurrentMonth;
  final Future<List<dynamic>> topServices;
  final WordTransformation wt = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pesanan',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0),
          GridView.count(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 8.0,
            padding: EdgeInsets.zero,
            children: [
              OrderSectionAllOrder(
                  orderList: orderList, orderListItems: orderListItems),
              OrderSectionMostServices(topServices),
              OrderSectionCurrentMonth(orderCurrentMonth),
              OrderSectionCurrentMonthTemp(orderCurrentMonth),
            ],
          ),
        ],
      ),
    );
  }
}
