import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/auth.model.dart';
import 'package:seekil_back_office/modules/home/employee/controller.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class EmployeePage extends StatelessWidget {
  EmployeePage({Key? key}) : super(key: key);
  final controller = Get.put(EmployeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Karyawan'),
      body: controller.obx((state) {
        return ListView.builder(
          itemCount: state.length,
          itemBuilder: (context, index) {
            AuthModel item = state[index];
            return ListTile(
              onTap: () => _showDetailEmployee(context, item),
              leading: Icon(
                Icons.account_circle_rounded,
                color: ColorConstant.DEF,
                size: 48.0,
              ),
              title: Text(item.name ?? '-'),
              subtitle: Text(item.level ?? '-'),
            );
          },
        );
      }),
    );
  }

  void _showDetailEmployee(BuildContext context, AuthModel item) {
    WidgetHelper.bottomSheet(
      context,
      onClosing: () => Get.back(),
      isCenterChild: true,
      title: 'Detail Karyawan',
      child: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              child: Icon(Icons.account_circle_rounded),
              maxRadius: 32.0,
            ),
            SizedBox(height: 8.0),
            Text(
              item.name ?? '-',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0),
            Text('Level: ${item.level ?? '-'}',
                style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 4.0),
            Text('Target bulanan: ${item.target ?? 0}',
                style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
