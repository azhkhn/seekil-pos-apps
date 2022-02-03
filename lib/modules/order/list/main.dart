import 'package:badges/badges.dart';
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
  //
  int pageSize = 10;
  int totalOrder = 0;
  int inprogressListCount = 0;
  int waitingOrderListCount = 0;
  int readyToPickupListCount = 0;
  int readyToShipmentListCount = 0;
  int onprogressShipmentListCount = 0;
  int doneOrderListCount = 0;

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchNewOrderList(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    pagingController.dispose();
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

        setState(() => totalOrder = newItems.length);
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
            child: TabBar(
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                labelColor: ColorConstant.DEF,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                indicatorColor: ColorConstant.DEF,
                tabs: [
                  _tabBarBadge(text: 'Baru', totalOrder: totalOrder),
                  _tabBarBadge(
                    text: 'Dalam Antrian',
                    totalOrder: waitingOrderListCount,
                  ),
                  _tabBarBadge(
                    text: 'Diproses',
                    totalOrder: inprogressListCount,
                  ),
                  _tabBarBadge(
                    text: 'Siap Diambil',
                    totalOrder: readyToPickupListCount,
                  ),
                  _tabBarBadge(
                    text: 'Siap Dikirim',
                    totalOrder: readyToShipmentListCount,
                  ),
                  _tabBarBadge(
                    text: 'Sedang Dikirim',
                    totalOrder: onprogressShipmentListCount,
                  ),
                  _tabBarBadge(
                    text: 'Selesai',
                    totalOrder: doneOrderListCount,
                  ),
                ]),
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
          OrderWaitingList(
            waitingOrderListCount: (value) =>
                setState(() => waitingOrderListCount = value),
          ),
          OrderInprogressList(
            inprogressListCount: (value) =>
                setState(() => inprogressListCount = value),
          ),
          OrderListReadyToPickup(
            readyToPickupListCount: (value) =>
                setState(() => readyToPickupListCount = value),
          ),
          OrderListReadyToShipment(
            readyToShipmentListCount: (value) =>
                setState(() => readyToShipmentListCount = value),
          ),
          OrderListOnprogressShipment(
            onprogressShipmentListCount: (value) =>
                setState(() => onprogressShipmentListCount = value),
          ),
          OrderDoneList(
            doneListCount: (value) =>
                setState(() => doneOrderListCount = value),
          ),
        ]),
      ),
    );
  }

  Widget _tabBarBadge({required int totalOrder, required String text}) {
    return Badge(
      child: Tab(text: text),
      padding: EdgeInsets.all(6.0),
      badgeColor: ColorConstant.DEF,
      animationType: BadgeAnimationType.fade,
      position: BadgePosition.topEnd(top: -4.0, end: -16.0),
      showBadge: totalOrder != 0,
      ignorePointer: true,
      badgeContent: Text(
        totalOrder.toString(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
