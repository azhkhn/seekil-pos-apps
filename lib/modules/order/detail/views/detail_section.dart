import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class DetailSection extends StatelessWidget {
  final data;
  final TextStyle titleStyle, valueStyle;
  final WordTransformation wordTransformation;

  const DetailSection(
      {Key? key,
      this.data,
      required this.titleStyle,
      required this.valueStyle,
      required this.wordTransformation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.orderStatusName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () =>
                      Get.toNamed(AppRoutes.orderTracking, parameters: {
                    'orderId': data.orderId,
                    'orderDate': data.orderDate,
                    'orderStatus': data.orderStatusName,
                    'customerName': data.customerName,
                    'orderType': data.orderType,
                    'qty': data.qty.toString(),
                  }),
                  child: Text(
                    'Lihat Detail',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          Divider(height: 24.0, color: Colors.grey),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       GestureDetector(
          //         onTap: () async {
          //           await Clipboard.setData(ClipboardData(text: data.orderId));
          //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //               content: Row(
          //             children: [
          //               Icon(Icons.check_circle, color: Colors.green),
          //               SizedBox(width: 8.0),
          //               Text('Nomor invoice disalin ke clipboard'),
          //             ],
          //           )));
          //         },
          //         child: Row(
          //           children: [
          //             Text(
          //               data.orderId,
          //               style:
          //                   titleStyle.copyWith(fontWeight: FontWeight.normal),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 4.0),
          //               child: Icon(Icons.copy_rounded,
          //                   size: 16.0, color: Colors.black54),
          //             )
          //           ],
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () => Get.toNamed('/order/${data.orderId}/invoice'),
          //         child: Text(
          //           'Lihat Invoice',
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold, color: Colors.green),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Divider(height: 24.0, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Tanggal Transaksi',
                  style: titleStyle,
                ),
                Text(
                  wordTransformation.dateFormatter(
                      date: data.orderDate, type: DateFormatType.dateTime),
                  style: valueStyle.copyWith(fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
