import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/modules/order/list/views/done_order_list.dart';
import 'package:seekil_back_office/modules/order/list/views/inprogress_order_list.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/modules/order/list/views/new_order_list.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class Order extends StatefulWidget {
  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late Future<List<OrderListModel>> newOrderList;
  WordTransformation wt = WordTransformation();

  @override
  void initState() {
    super.initState();
    fetchNewOrderList();
  }

  Future<void> fetchNewOrderList() async {
    newOrderList = OrderListModel.fetchOrderListByPeriod(
        wt.firstDateOfMonth, wt.endDateOfMonth,
        params: 'order_status_id=1');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          'Transaksi ${wt.currentMonth}',
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: TabBar(
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorConstant.DEF),
                  tabs: [
                    Tab(text: 'Baru'),
                    Tab(text: 'Diproses'),
                    Tab(text: 'Selesai'),
                  ]),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                size: 32.0,
              ),
              padding: EdgeInsets.all(2.0),
              onPressed: () => Get.toNamed(AppRoutes.orderAdd)!.then((value) {
                if (value != null && value == true) {
                  fetchNewOrderList();
                  SnackbarHelper.show(
                      title: 'Info',
                      message: GeneralConstant.ORDER_CREATED,
                      withBottomNavigation: true);
                }
              }),
            ),
          ],
        ),
        body: TabBarView(children: [
          OrderNewList(
            fetchNewOrderList: fetchNewOrderList,
            newOrderList: newOrderList,
          ),
          OrderInprogressList(),
          OrderDoneList(),
        ]),
      ),
    );
  }
}
