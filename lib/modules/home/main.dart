import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/models/services_list.model.dart';
import 'package:seekil_back_office/models/order_list_items.model.dart';
import 'package:seekil_back_office/modules/home/views/order_section.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WordTransformation wt = WordTransformation();
  late Future<Map<String, dynamic>> _orderList;
  late Future<Map<String, dynamic>> _orderListItems, _orderCurrentMonth;
  late Future<List<dynamic>> _topServices;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    initialFetchMasterData();
  }

  Future<void> initialFetchMasterData() async {
    setState(() {
      _orderList = OrderListModel.fetchAllOrders();
      _orderListItems = OrderItemListItemsModel.fetchOrderItems('all');
      _orderCurrentMonth =
          OrderItemListItemsModel.fetchOrderItems('current-month');
      // _topCustomer = OrderListModel.fetchTopCustomer();
      _topServices = ServicesListModel.fetchTopServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.black),
          toolbarHeight: Get.height * .16,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.blue,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  AuthHelper.isLoggedIn()
                      ? '${wt.greeting()}${AuthHelper.user().username}'
                      : wt.greeting(),
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text('Bagaimana harimu?',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white))
            ],
          ),
        ),
        body: RefreshIndicator(
            onRefresh: initialFetchMasterData,
            child: ListView(
              children: [
                HomeOrderSection(
                    orderList: _orderList,
                    orderListItems: _orderListItems,
                    orderCurrentMonth: _orderCurrentMonth,
                    topServices: _topServices),
                // HomeInsightSection(),
                // TopCustomerSection(
                //   topCustomerList: _topCustomer,
                // ),
              ],
            )));
  }
}
