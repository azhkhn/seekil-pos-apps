import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list.dart';
import 'package:seekil_back_office/widgets/order/order_refresh.dart';

class OrderDoneList extends StatefulWidget {
  OrderDoneList({Key? key}) : super(key: key);

  @override
  State<OrderDoneList> createState() => _OrderDoneListState();
}

class _OrderDoneListState extends State<OrderDoneList>
    with AutomaticKeepAliveClientMixin {
  late Future<List<OrderListModel>> doneOrderList;
  WordTransformation wt = WordTransformation();

  @override
  void initState() {
    fetchDoneOrderList();
    super.initState();
  }

  Future<void> fetchDoneOrderList() async {
    Map<String, String> objectParams = {
      'order_status_id': '7',
      'start_date': wt.firstDateOfMonth,
      'end_date': wt.endDateOfMonth
    };
    String queryParams = Uri(queryParameters: objectParams).query;

    setState(() {
      doneOrderList = OrderListModel.fetchOrderList(queryParams);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: fetchDoneOrderList,
      child: FutureBuilder<List<OrderListModel>>(
        future: doneOrderList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No data found'));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return OrderCardShimmer(onRefresh: fetchDoneOrderList);
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<OrderListModel>? data = snapshot.data;
                if (data!.length > 0)
                  return OrderList(data: data, onRefresh: fetchDoneOrderList);
                return OrderEmpty(
                  svgAsset: 'assets/svg/order_done.svg',
                  text: 'Transaksi yang udah selesai\ntampil di sini, ya!',
                );
              }
              return OrderRefresh(
                onRefresh: fetchDoneOrderList,
              );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
