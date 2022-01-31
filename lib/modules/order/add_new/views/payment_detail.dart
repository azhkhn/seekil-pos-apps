import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/order_add_new.model.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class OrderAddNewPaymentDetal extends StatelessWidget {
  const OrderAddNewPaymentDetal(this.orderAddNewModel,
      {Key? key, required this.isUsePoint})
      : super(key: key);

  final OrderAddNewModel orderAddNewModel;
  final bool isUsePoint;

  @override
  Widget build(BuildContext context) {
    WordTransformation wt = WordTransformation();
    OrderUtils orderUtils = OrderUtils();

    List<Map<String, dynamic>> content = [
      {
        'text': 'Item Subtotal',
        'value': orderUtils.getItemSubtotal(orderAddNewModel.items),
      },
      {
        'text': 'Ongkos Kirim',
        'value': orderAddNewModel.pickupDeliveryPrice != null
            ? orderAddNewModel.pickupDeliveryPrice
            : 0
      },
      {
        'text': 'Diskon',
        'value':
            orderAddNewModel.potongan != null ? orderAddNewModel.potongan : 0,
        'isDecrement': true
      },
      // {
      //   'text': 'Points',
      //   'value': orderAddNewModel.points != null
      //       ? isUsePoint
      //           ? orderAddNewModel.points
      //           : 0
      //       : 0,
      //   'isDecrement': true
      // },
      {
        'text': 'Total Bayar',
        'value': orderUtils.getTotal(
            items: orderAddNewModel.items,
            potongan: orderAddNewModel.potongan,
            points: isUsePoint ? orderAddNewModel.points : 0,
            pickupDeliveryPrice: orderAddNewModel.pickupDeliveryPrice)
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Rincian Pembayaran',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: content.length,
            separatorBuilder: (context, index) {
              return index == content.length - 1
                  ? Divider(height: 8.0, color: Colors.grey)
                  : SizedBox(height: 8.0);
            },
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    content[index]['text'],
                    style: TextStyle(
                      fontWeight: index == content.length - 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: index == content.length - 1
                          ? Colors.red
                          : Colors.black,
                      fontSize: index == content.length - 1 ? 18.0 : 14.0,
                    ),
                  ),
                  Text(
                    content[index]['isDecrement'] == true
                        ? '-${wt.currencyFormat(content[index]['value'])}'
                        : wt.currencyFormat(content[index]['value']),
                    style: TextStyle(
                      fontWeight: index == content.length - 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: index == content.length - 1
                          ? Colors.red
                          : Colors.black,
                      fontSize: index == content.length - 1 ? 18.0 : 14.0,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
