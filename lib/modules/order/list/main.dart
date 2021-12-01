import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/modules/order/list/views/cancel_order.dart';
import 'package:seekil_back_office/modules/order/list/views/done_order.dart';
import 'package:seekil_back_office/modules/order/list/views/new_order.dart';
import 'package:seekil_back_office/modules/order/list/views/ongoing_order.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order>
    with AutomaticKeepAliveClientMixin<Order> {
  @override
  bool get wantKeepAlive => true;
  late Future<List<OrderListModel>> _list;

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  Future<dynamic> _fetchList() async {
    setState(() {
      _list = OrderListModel.fetchOrderList('order_status_id=1');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          'Pesanan',
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: [
              Tab(text: 'Baru'),
              Tab(text: 'Sedang Jalan'),
              Tab(text: 'Selesai'),
              Tab(text: 'Dibatalkan'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_rounded),
              padding: EdgeInsets.all(2.0),
              onPressed: () => Get.toNamed(AppRoutes.orderAdd)!.then((value) {
                if (value != null && value == true) {
                  SnackbarHelper.show(
                      title: 'Info',
                      message: GeneralConstant.ORDER_CREATED,
                      withBottomNavigation: true);
                  _fetchList();
                }
              }),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            NewOrder(
              list: _list,
              fetchList: _fetchList,
            ),
            OngoingOrder(),
            DoneOrder(),
            CancelOrder()
          ],
        ),
      ),
    );
  }
}
