import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class OrderSectionAllOrder extends StatelessWidget {
  OrderSectionAllOrder(
      {Key? key, required this.orderList, required this.orderListItems})
      : super(key: key);
  final Future<Map<String, dynamic>> orderList, orderListItems;
  final WordTransformation wt = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.order),
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Semua Pesanan',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Expanded(
                  child: FutureBuilder(
                    future: orderListItems,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return MyShimmer(width: 80, height: 10);
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            Map<String, dynamic> itemData =
                                snapshot.data as Map<String, dynamic>;
                            return Text('${itemData['total_row']} items',
                                style: TextStyle(
                                  color: Colors.grey,
                                ));
                          }
                          return Text('0 items',
                              style: TextStyle(
                                color: Colors.grey,
                              ));
                      }
                    },
                  ),
                ),
                FutureBuilder(
                  future: orderList,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return MyShimmer(width: 80, height: 10);
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          Map<String, dynamic> data =
                              snapshot.data as Map<String, dynamic>;

                          return Text(wt.currencyFormat(data['total_order']),
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold));
                        }
                        return Text(wt.currencyFormat(0));
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}
