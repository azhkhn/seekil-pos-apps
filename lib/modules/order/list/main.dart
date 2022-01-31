import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/constants/order_status.constant.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/modules/order/list/views/done_order_list.dart';
import 'package:seekil_back_office/modules/order/list/views/inprogress_order_list.dart';
import 'package:seekil_back_office/modules/order/list/views/onprogress_shipment_order_list.dart';
import 'package:seekil_back_office/modules/order/list/views/ready_to_pickup_order_list.dart';
import 'package:seekil_back_office/modules/order/list/views/ready_to_shipment_order_list.dart';
import 'package:seekil_back_office/modules/order/list/views/waiting_order_list.dart';
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
  final PagingController<int, OrderListModel> pagingController =
      PagingController<int, OrderListModel>(firstPageKey: 0);

  WordTransformation wt = WordTransformation();
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchNewOrderList(pageKey);
    });
  }

  Future<void> fetchNewOrderList(dynamic pageKey) async {
    Map<String, String> objectParams = {
      'order_status_id': OrderStatusConstant.newest.toString(),
      'start_date': wt.firstDateOfMonth,
      'end_date': wt.endDateOfMonth
    };
    String queryParams = Uri(queryParameters: objectParams).query;

    try {
      final newItems =
          await OrderListModel.fetchOrderList(queryParams, pageKey.toString());
      final isLastPage = newItems.length < pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    Tab(text: 'Dalam Antrian'),
                    Tab(text: 'Diproses'),
                    Tab(text: 'Siap Diambil'),
                    Tab(text: 'Siap Dikirim'),
                    Tab(text: 'Sedang Dikirim'),
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
                  pagingController.refresh();
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
          OrderNewList(pagingController: pagingController),
          OrderWaitingList(),
          OrderInprogressList(),
          OrderListReadyToPickup(),
          OrderListReadyToShipment(),
          OrderListOnprogressShipment(),
          OrderDoneList(),
        ]),
      ),
    );
  }
}
