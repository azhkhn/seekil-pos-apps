import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_list.model.dart';

import 'order_list_card.dart';

class OrderList extends StatelessWidget {
  final List<OrderListModel> data;
  final Future<void> Function() onRefresh;

  const OrderList({required this.data, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => OrderListCard(
        data: data[index],
        isRefreshed: (bool isRefreshed) {
          if (isRefreshed) onRefresh();
        },
      ),
    );
  }
}
