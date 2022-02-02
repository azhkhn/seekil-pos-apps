import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OrderListCard extends StatelessWidget {
  const OrderListCard({Key? key, required this.data, this.isRefreshed})
      : super(key: key);

  final OrderListModel data;
  final ValueChanged<bool>? isRefreshed;

  @override
  Widget build(BuildContext context) {
    TextStyle _valueStyle(bool isBold) {
      if (isBold) {
        return TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
      } else {
        return TextStyle(color: Colors.black);
      }
    }

    return GestureDetector(
        onTap: () => Get.toNamed('/order/${data.orderId}')!.then(
              (value) {
                if (value != null && value == true) {
                  SnackbarHelper.show(
                      title: 'Info',
                      message: GeneralConstant.ORDER_UPDATED,
                      withBottomNavigation: true);
                  isRefreshed!(value);
                }
              },
            ),
        child: Card(
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(data.orderId,
                          textAlign: TextAlign.left,
                          style:
                              _valueStyle(true).copyWith(color: Colors.grey)),
                    ),
                    Text(
                      WordTransformation().dateFormatter(date: data.orderDate),
                      style: _valueStyle(false)
                          .copyWith(color: Colors.grey, fontSize: 13.0),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      data.customerName,
                      style: _valueStyle(true),
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '(${data.qty} Item)',
                      style: _valueStyle(false).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        WordTransformation().currencyFormat(data.total),
                        style: _valueStyle(true),
                      ),
                    ),
                    Row(
                      children: [
                        WidgetHelper.badgeText(
                          data.orderStatus,
                          badgeColor: ColorConstant.DEF,
                          textColor: Colors.white,
                        ),
                        SizedBox(width: 4.0),
                        WidgetHelper.badgeText(data.paymentStatus as String,
                            badgeColor: data.paymentStatus as String == 'Lunas'
                                ? Colors.green
                                : Colors.red,
                            textColor: Colors.white)
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
