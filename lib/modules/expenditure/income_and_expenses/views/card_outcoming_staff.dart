import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/modules/expenditure/current_month/controller.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class CardExpensesStaff extends StatelessWidget {
  CardExpensesStaff({Key? key}) : super(key: key);
  final WordTransformation wt = WordTransformation();
  final controller = Get.put(ExpenditureCurrentMonthController());

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => _list(context, state),
      onEmpty: _onEmptyState(),
      onLoading: _onLoadingState(),
    );
  }

  Widget _list(BuildContext context, dynamic state) =>
      OrderCurrentMonthCardContainer(
        title: 'Pengeluaran',
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            shrinkWrap: true,
            itemCount: state['list'].length,
            itemBuilder: (context, index) {
              ExpenditureModel item = state['list'][index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name.toString()),
                  Text(wt.currencyFormat(item.price)),
                ],
              );
            },
          ),
          Divider(),
          CardContainerRowChild(
            children: [
              Text('Total Pengeluaran', style: TextStyle(fontWeight: FontWeight.bold),),
              Obx(
                () => Text(
                  wt.currencyFormat(
                      controller.totalExpenditureCurrentMonth.value),
                ),
              )
            ],
          ),
        ],
      );

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
