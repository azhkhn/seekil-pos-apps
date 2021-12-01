import 'package:flutter/material.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class OrderSectionCurrentMonth extends StatelessWidget {
  OrderSectionCurrentMonth(this.orderCurrentMonth, {Key? key})
      : super(key: key);
  final WordTransformation wt = WordTransformation();
  final Future<Map<String, dynamic>> orderCurrentMonth;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bulan Ini',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Expanded(
                  child: FutureBuilder(
                    future: orderCurrentMonth,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return Column(
                            children: [
                              Expanded(child: MyShimmer(width: 80, height: 10)),
                              SizedBox(
                                height: 4.0,
                              ),
                              MyShimmer(width: 80, height: 10),
                            ],
                          );
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            Map<String, dynamic> itemData =
                                snapshot.data as Map<String, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text('${itemData['total_row']} items',
                                      style: TextStyle(color: Colors.grey)),
                                ),
                                Text(
                                  wt.currencyFormat(itemData['total_order']),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('0 items', style: TextStyle(fontSize: 16.0)),
                              Text(wt.currencyFormat(0))
                            ],
                          );
                      }
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
