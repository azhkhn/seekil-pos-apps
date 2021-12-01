import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OrderSectionCurrentMonthTemp extends StatelessWidget {
  OrderSectionCurrentMonthTemp(this.orderCurrentMonth, {Key? key})
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
                Text('Laci Bulan Ini',
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper.badgeText('Lunas',
                                        badgeColor: ColorConstant.SUCCESS,
                                        textColor: Colors.black),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      wt.currencyFormat(
                                          itemData['total_paid_orders']),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper.badgeText('Belum Lunas',
                                        badgeColor: ColorConstant.ERROR,
                                        textColor: Colors.black),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      wt.currencyFormat(
                                          itemData['total_unpaid_orders']),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
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
