import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/order_detail.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTracking extends StatefulWidget {
  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  WordTransformation wt = WordTransformation();
  Future<List<dynamic>>? _orderTrackingList;
  String? orderId = Get.parameters['orderId'];
  String? orderDate = Get.parameters['orderDate'];
  String? orderStatus = Get.parameters['orderStatus'];
  String? customerName = Get.parameters['customerName'];
  String? orderType = Get.parameters['orderType'];
  String? qty = Get.parameters['qty'];

  TextStyle _textStyle(
      {bool isBold = false, double size = 14.0, Color color = Colors.black54}) {
    return TextStyle(
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color);
  }

  @override
  void initState() {
    super.initState();
    if (orderId != null) {
      _orderTrackingList = OrderDetailModel.fetchOrderTracking(orderId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Lacak'),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nomor Invoice', style: _textStyle(color: Colors.grey)),
                SizedBox(height: 2.0),
                Text(orderId as String,
                    style: _textStyle(isBold: true, size: 16.0))
              ],
            ),
          ),
          Divider(height: 4.0, color: Colors.grey),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal Transaksi',
                              style: _textStyle(color: Colors.grey)),
                          SizedBox(height: 2.0),
                          Text(wt.dateFormatter(date: orderDate as String),
                              style: _textStyle())
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('QTY', style: _textStyle(color: Colors.grey)),
                          SizedBox(height: 2.0),
                          Text('$qty item', style: _textStyle())
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jenis Order',
                              style: _textStyle(color: Colors.grey)),
                          SizedBox(height: 2.0),
                          Text(orderType as String, style: _textStyle())
                        ],
                      ),
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text('Alamat', style: _textStyle()),
                    //     Text('', style: _textStyle(isBold: true))
                    //   ],
                    // ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama Pelanggan',
                                style: _textStyle(color: Colors.grey)),
                            SizedBox(height: 2.0),
                            Text(customerName as String, style: _textStyle())
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(height: 4.0, color: Colors.grey),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status', style: _textStyle(color: Colors.grey)),
                SizedBox(height: 2.0),
                Text(orderStatus as String,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.red)),
                Divider(height: 40.0, color: Colors.grey),
              ],
            ),
          ),
          FutureBuilder(
            future: _orderTrackingList,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sedang mengambil data pelacakan...'),
                        SizedBox(height: 8.0),
                        CircularProgressIndicator(
                          color: Colors.green,
                          backgroundColor: Colors.yellow,
                        )
                      ],
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<dynamic> data = snapshot.data as List<dynamic>;

                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        bool isFirstIndex = index == 0;
                        return TimelineTile(
                          isFirst: isFirstIndex,
                          isLast: index == data.length - 1,
                          beforeLineStyle: LineStyle(color: Colors.green),
                          indicatorStyle: IndicatorStyle(
                            color: Colors.green,
                            width: 20.0,
                          ),
                          endChild: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        wt.dateFormatter(
                                            date: data[index]['updatedAt']),
                                        style: _textStyle(
                                            isBold: true,
                                            color: isFirstIndex
                                                ? Colors.green
                                                : Colors.black54)),
                                    Text(
                                      wt.dateFormatter(
                                          date: data[index]['updatedAt'],
                                          type: DateFormatType.timeOnly),
                                      style: _textStyle(),
                                    )
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Text(data[index]['description'],
                                    style: _textStyle()),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
