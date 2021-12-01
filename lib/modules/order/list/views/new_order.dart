import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list.dart';

class NewOrder extends StatelessWidget {
  const NewOrder({Key? key, required this.list, required this.fetchList})
      : super(key: key);
  final Future<List<OrderListModel>> list;
  final Future<void> Function() fetchList;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchList,
      child: FutureBuilder<List<OrderListModel>>(
        future: list,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No data found'));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return OrderCardShimmer(onRefresh: fetchList);
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<OrderListModel>? data = snapshot.data;
                if (data!.length > 0)
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OrderList(data: data, onRefresh: fetchList),
                  );
                return OrderEmpty();
              }
              return Container();
          }
        },
      ),
    );
  }
}
