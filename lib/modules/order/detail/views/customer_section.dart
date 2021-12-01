import 'package:flutter/material.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class CustomerSection extends StatelessWidget {
  final data;
  final TextStyle titleStyle, valueStyle;
  final WordTransformation wordTransformation;

  const CustomerSection(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Text('Detail Transaksi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ))),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text('Pelanggan', style: titleStyle)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.customerName, style: valueStyle),
                      Text(data.whatsapp, style: valueStyle),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Jenis Pesanan',
                    style: titleStyle,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${data.orderType}', style: valueStyle),
                      if (data.storeName != null)
                        Text(data.storeName, style: valueStyle)
                      else if (data.pickupAddress != null)
                        Text(data.pickupAddress, style: valueStyle)
                      else if (data.dropZone != null)
                        Text(data.dropZone, style: valueStyle)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
