import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class HomeCardCurrentMonth extends StatelessWidget {
  HomeCardCurrentMonth(this.data, {Key? key}) : super(key: key);

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
            Text('Arus kas ${wt.currentMonth}',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ]);

  Widget _currentMonthHasData(Map<String, dynamic> data) {
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
                onTap: () => AuthHelper.isSuperAdmin()
                    ? Get.toNamed(AppRoutes.expenditureIncomingAndExpenses)
                    : null,
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
                          Text(wt.currencyFormat(data['total_current_month']),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Icon(Icons.chevron_right_rounded)
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
                Text('Pemasukan bulan ini'),
                Text(wt.currencyFormat(data['incoming']['total_incoming']),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengeluaran bulan ini'),
                Text(wt.currencyFormat(data['expenditure']['spending_money']),
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                      Icon(Icons.chevron_right_rounded)
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
                Text('Pemasukan bulan ini'),
                Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengeluaran bulan ini'),
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
                      Icon(Icons.chevron_right_rounded)
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
              children: [Text('Pemasukan bulan ini'), MyShimmer.rectangular()],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengeluaran bulan ini'),
                MyShimmer.rectangular()
              ],
            ),
          ],
        )),
      ],
    );
  }
}
