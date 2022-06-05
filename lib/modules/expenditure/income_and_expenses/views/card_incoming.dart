import 'package:flutter/material.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class CardIncoming extends StatelessWidget {
  CardIncoming(this.data, {Key? key}) : super(key: key);
  final WordTransformation wt = WordTransformation();
  final Future<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return _onLoadingState();
          case ConnectionState.done:
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
              return Column(
                children: [
                  OrderCurrentMonthCardContainer(
                    title: 'Pemasukan',
                    children: [
                      CardContainerRowChild(
                        children: [
                          Text('Total Transaksi'),
                          Text('${data['incoming']['items'].toString()} items')
                        ],
                      ),
                      Divider(),
                      CardContainerRowChild(
                        children: [
                          Text('Lunas'),
                          Text(wt.currencyFormat(
                              data['incoming']['paid']['total_paid']))
                        ],
                      ),
                      if (data['incoming']['paid']['cash'] != 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CardContainerRowChild(
                            children: [
                              Text('Tunai'),
                              Text(
                                wt.currencyFormat(
                                    data['incoming']['paid']['cash']),
                              ),
                            ],
                          ),
                        ),
                      if (data['incoming']['paid']['dana'] != 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CardContainerRowChild(
                            children: [
                              Text('Dana'),
                              Text(
                                wt.currencyFormat(
                                    data['incoming']['paid']['dana']),
                              ),
                            ],
                          ),
                        ),
                      if (data['incoming']['paid']['shopeepay'] != 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CardContainerRowChild(
                            children: [
                              Text('ShopeePay'),
                              Text(
                                wt.currencyFormat(
                                    data['incoming']['paid']['shopeepay']),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CardContainerRowChild(
                          children: [
                            Text('Belum lunas'),
                            Text(wt.currencyFormat(data['incoming']['unpaid']))
                          ],
                        ),
                      ),
                      Divider(),
                      CardContainerRowChild(
                        children: [
                          Text('Total Pemasukan',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              wt.currencyFormat(
                                  data['incoming']['total_incoming']),
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  )
                ],
              );
            }
            return _onEmptyState();
        }
      },
    );
  }

  Widget _onLoadingState() => Column(
        children: [
          OrderCurrentMonthCardContainer(
            title: 'Pemasukan',
            children: [
              CardContainerRowChild(
                children: [
                  MyShimmer.rectangular(
                    width: 90,
                  ),
                  MyShimmer.rectangular(
                    width: 60,
                  )
                ],
              ),
              Divider(),
              CardContainerRowChild(
                children: [
                  MyShimmer.rectangular(
                    width: 60,
                  ),
                  MyShimmer.rectangular(
                    width: 80,
                  )
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              CardContainerRowChild(
                children: [
                  MyShimmer.rectangular(
                    width: 80,
                  ),
                  MyShimmer.rectangular(
                    width: 80,
                  )
                ],
              ),
              Divider(),
              CardContainerRowChild(
                children: [
                  MyShimmer.rectangular(),
                  MyShimmer.rectangular(
                    width: 80,
                  )
                ],
              ),
            ],
          )
        ],
      );

  Widget _onEmptyState() => Column(
        children: [
          OrderCurrentMonthCardContainer(
            title: 'Pemasukan',
            children: [
              CardContainerRowChild(
                children: [Text('Rp-'), Text('Rp-')],
              ),
              Divider(),
              CardContainerRowChild(
                children: [Text('Rp-'), Text('Rp-')],
              ),
              CardContainerRowChild(
                children: [Text('Rp-'), Text('Rp-')],
              ),
              Divider(),
              CardContainerRowChild(
                children: [Text('Rp-'), Text('Rp-')],
              ),
            ],
          )
        ],
      );
}
