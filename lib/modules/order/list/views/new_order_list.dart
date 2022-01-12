import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list.dart';
import 'package:seekil_back_office/widgets/order/order_refresh.dart';

class OrderNewList extends StatelessWidget {
  OrderNewList(
      {Key? key, required this.newOrderList, required this.fetchNewOrderList})
      : super(key: key);
  final Future<List<OrderListModel>> newOrderList;
  final Future<void> Function() fetchNewOrderList;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchNewOrderList,
      child: FutureBuilder<List<OrderListModel>>(
        future: newOrderList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No data found'));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return OrderCardShimmer(onRefresh: fetchNewOrderList);
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<OrderListModel>? data = snapshot.data;
                if (data!.length > 0)
                  return OrderList(data: data, onRefresh: fetchNewOrderList);
                return OrderEmpty(
                  svgAsset: 'assets/svg/order_new.svg',
                  text: 'Transaksi yang baru masuk\ntampil di sini, ya!',
                );
              }
              return OrderRefresh(
                onRefresh: fetchNewOrderList,
              );
          }
        },
      ),
    );
  }
}
