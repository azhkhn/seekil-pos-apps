import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/order_detail.model.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OrderInvoice extends StatefulWidget {
  @override
  _OrderInvoiceState createState() => _OrderInvoiceState();
}

class _OrderInvoiceState extends State<OrderInvoice> {
  Future<String>? _strBase64PDF;
  String? orderId = Get.parameters['order_id'];

  @override
  void initState() {
    super.initState();
    if (orderId != null) {
      _strBase64PDF = OrderDetailModel.fetchOrderInvoice(orderId as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Invoice'),
      body: FutureBuilder(
        future: _strBase64PDF,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return Text(data.toString());
          }
          return Container();
        },
      ),
    );
  }
}
