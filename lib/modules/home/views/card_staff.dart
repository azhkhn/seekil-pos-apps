import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class HomeCardStaff extends StatelessWidget {
  HomeCardStaff(this.data, {Key? key}) : super(key: key);
  final Future<Map<String, dynamic>> data;
  final WordTransformation wt = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      padding: const EdgeInsets.all(16.0),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5)),
        ],
      ),
      child: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return _currentMonthLoading();
            case ConnectionState.done:
              if (snapshot.hasData) {
                Map<String, dynamic> itemData =
                    snapshot.data as Map<String, dynamic>;
                return _currentMonthHasData(itemData);
              }
              return _currentMonthEmpty();
          }
        },
      ),
    );
  }

  Widget _title() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.store_outlined,
              color: Colors.black,
              size: 20.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(wt.currentMonth,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ]);

  Widget _currentMonthHasData(Map<String, dynamic> data) {
    int totalTarget = 100;
    num target = data['incoming']['items'] - totalTarget;

    return Row(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            SizedBox(
              height: 8.0,
            ),
            Material(
              child: InkWell(
                onTap: () =>
                    Get.toNamed(AppRoutes.expenditureIncomingAndExpenses),
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Laci'),
                          Text(
                              wt.currencyFormat(
                                  data['incoming']['paid']['total_paid']),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Icon(Icons.chevron_right_outlined),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
        SizedBox(
          width: 24.0,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Transaksi'),
                Text('${data['incoming']['items']} items',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Target'),
                RichText(
                  text: TextSpan(
                      text: '$totalTarget items ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: !target.isNegative
                                ? '(+${target.toString()})'
                                : '(${target.toString()})',
                            style: TextStyle(
                                color: !target.isNegative
                                    ? Colors.green
                                    : Colors.red))
                      ]),
                )
              ],
            ),
          ],
        )),
      ],
    );
  }

  Widget _currentMonthEmpty() {
    return Row(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            SizedBox(
              height: 8.0,
            ),
            Material(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Laci'),
                          Text('-',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Tooltip(
                        child: Icon(Icons.info_outline_rounded),
                        showDuration: Duration(seconds: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        message:
                            'Pastiin nominal transaksi yang\nudah lunas sama dengan uang laci, ya!',
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
        SizedBox(
          width: 24.0,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Transaksi'),
                Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Target'),
                Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )),
      ],
    );
  }

  Widget _currentMonthLoading() {
    return Row(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            SizedBox(
              height: 8.0,
            ),
            Material(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Laci'),
                          MyShimmer.rectangular(
                            width: 100.0,
                          )
                        ],
                      ),
                      Tooltip(
                        child: Icon(Icons.info_outline_rounded),
                        showDuration: Duration(seconds: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        message:
                            'Pastiin nominal transaksi yang\nudah lunas sama dengan uang laci, ya!',
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
        SizedBox(
          width: 24.0,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Total Transaksi'), MyShimmer.rectangular()],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Target'), MyShimmer.rectangular()],
            ),
          ],
        )),
      ],
    );
  }
}
