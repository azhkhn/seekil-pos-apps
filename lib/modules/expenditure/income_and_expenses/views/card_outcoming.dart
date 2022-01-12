import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class CardExpenses extends StatelessWidget {
  CardExpenses(
    this.data, {
    Key? key,
  }) : super(key: key);
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
                    title: 'Pengeluaran',
                    children: [
                      CardContainerRowChild(
                        children: [
                          Text('Tetap'),
                          Text(wt.currencyFormat(
                              data['expenditure']['fixed_monthly_expenses']))
                        ],
                      ),
                      CardContainerRowChild(
                        children: [
                          Text('Operasional'),
                          Text(wt.currencyFormat(
                              data['expenditure']['spending_money']))
                        ],
                      ),
                      Divider(),
                      CardContainerRowChild(
                        children: [
                          Text('Total Pengeluaran',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              wt.currencyFormat(
                                  data['expenditure']['total_expenditure']),
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
            title: 'Pengeluaran',
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
            title: 'Pengeluaran',
            backgroundColor: ColorConstant.ERROR_BORDER,
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
