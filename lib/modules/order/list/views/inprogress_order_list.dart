import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list.dart';
import 'package:seekil_back_office/widgets/order/order_refresh.dart';

class OrderInprogressList extends StatefulWidget {
  OrderInprogressList({Key? key}) : super(key: key);

  @override
  State<OrderInprogressList> createState() => _OrderInprogressListState();
}

class _OrderInprogressListState extends State<OrderInprogressList>
    with AutomaticKeepAliveClientMixin {
  late Future<List<OrderListModel>> inProgressOrderList;
  WordTransformation wt = WordTransformation();

  @override
  void initState() {
    fetchInProgressList();
    super.initState();
  }

  Future<void> fetchInProgressList() async {
    inProgressOrderList = OrderListModel.fetchOrderListByPeriod(
        wt.firstDateOfMonth, wt.endDateOfMonth,
        params: 'order_status_id=3');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: fetchInProgressList,
      child: FutureBuilder<List<OrderListModel>>(
        future: inProgressOrderList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No data found'));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return OrderCardShimmer(onRefresh: fetchInProgressList);
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<OrderListModel>? data = snapshot.data;
                if (data!.length > 0)
                  return OrderList(data: data, onRefresh: fetchInProgressList);
                return OrderEmpty(
                  svgAsset: 'assets/svg/order_progress.svg',
                  text: 'Transaksi yang lagi dikerjain\ntampil di sini, ya!',
                );
              }
              return OrderRefresh(
                onRefresh: fetchInProgressList,
              );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
