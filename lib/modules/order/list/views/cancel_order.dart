import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list.dart';

class CancelOrder extends StatefulWidget {
  const CancelOrder({Key? key}) : super(key: key);

  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder>
    with AutomaticKeepAliveClientMixin<CancelOrder> {
  late Future<List<OrderListModel>> _list;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  Future<dynamic> _fetchList() async {
    setState(() {
      _list = OrderListModel.fetchOrderList('order_status_id=6');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _fetchList,
      child: FutureBuilder<List<OrderListModel>>(
        future: _list,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No data found'));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return OrderCardShimmer(onRefresh: _fetchList);
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<OrderListModel>? data = snapshot.data;
                if (data!.length > 0)
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OrderList(data: data, onRefresh: _fetchList),
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
