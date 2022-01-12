import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list.dart';
import 'package:seekil_back_office/widgets/order/order_refresh.dart';

class OrderCancelList extends StatefulWidget {
  OrderCancelList({Key? key}) : super(key: key);

  @override
  State<OrderCancelList> createState() => _OrderCancelListState();
}

class _OrderCancelListState extends State<OrderCancelList>
    with AutomaticKeepAliveClientMixin {
  late Future<List<OrderListModel>> cancelOrderList;
  WordTransformation wt = WordTransformation();

  @override
  void initState() {
    fetchCancelOrderList();
    super.initState();
  }

  Future<void> fetchCancelOrderList() async {
    cancelOrderList = OrderListModel.fetchOrderListByPeriod(
        wt.firstDateOfMonth, wt.endDateOfMonth,
        params: 'order_status_id=6');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: fetchCancelOrderList,
      child: FutureBuilder<List<OrderListModel>>(
        future: cancelOrderList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No data found'));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return OrderCardShimmer(onRefresh: fetchCancelOrderList);
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<OrderListModel>? data = snapshot.data;
                if (data!.length > 0)
                  return OrderList(data: data, onRefresh: fetchCancelOrderList);
                return OrderEmpty(
                  svgAsset: 'assets/svg/order_cancel.svg',
                  text: 'Transaksi yang dibatalkan\ntampil di sini, ya!',
                );
              }
              return OrderRefresh(
                onRefresh: fetchCancelOrderList,
              );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
