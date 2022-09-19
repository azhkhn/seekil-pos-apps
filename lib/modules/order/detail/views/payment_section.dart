import 'package:flutter/material.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class PaymentSection extends StatelessWidget {
  final data;
  final TextStyle titleStyle, valueStyle;
  final Map<String, dynamic> itemsList;

  const PaymentSection(
      {Key? key,
      required this.data,
      required this.itemsList,
      required this.titleStyle,
      required this.valueStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WordTransformation wt = WordTransformation();

    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Text('Rincian Pembayaran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metode Pembayaran', style: titleStyle),
                Text(data.paymentMethodName,
                    style: valueStyle.copyWith(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Pembayaran', style: titleStyle),
                Text(data.paymentStatus == 'lunas' ? 'Lunas' : 'Belum Lunas',
                    style: valueStyle.copyWith(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          Divider(height: 16.0, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item Subtotal', style: titleStyle),
                Text(wt.currencyFormat(itemsList['total_order']),
                    style: valueStyle.copyWith(fontWeight: FontWeight.normal))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ongkos Kirim', style: titleStyle),
                Text(wt.currencyFormat(data.ongkir),
                    style: valueStyle.copyWith(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Diskon', style: titleStyle),
                Text('-${wt.currencyFormat(data.promo)}',
                    style: valueStyle.copyWith(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text('Points', style: titleStyle),
          //       Text('-${wt.currencyFormat(data.points)}',
          //           style: valueStyle.copyWith(fontWeight: FontWeight.normal)),
          //     ],
          //   ),
          // ),
          Divider(height: 16.0, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Uang Muka (DP)',
                    style: valueStyle.copyWith(
                      color: Colors.black,
                      fontSize: 15.0,
                    )),
                Text(wt.currencyFormat(data.downPayment),
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Bayar',
                    style: valueStyle.copyWith(
                      color: Colors.black,
                      fontSize: 15.0,
                    )),
                Text(wt.currencyFormat(data.total),
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
