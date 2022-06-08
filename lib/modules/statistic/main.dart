import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/statistic.model.dart';
import 'package:seekil_back_office/modules/statistic/controller.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class StatisticPage extends StatelessWidget {
  StatisticPage({Key? key}) : super(key: key);
  final controller = Get.put(StatisticController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Statistic'),
      body: controller.obx(
        (state) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              StatisticModel item = state[index];
              return Text(item.month.toString());
            },
          );
        },
        onEmpty: Text('Empty'),
        onError: (error) => Text(error.toString()),
      ),
    );
  }
}
