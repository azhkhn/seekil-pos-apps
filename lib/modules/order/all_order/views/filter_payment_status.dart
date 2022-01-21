import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';

class AllOrderFilterPaymentStatus extends StatelessWidget {
  AllOrderFilterPaymentStatus({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Pembayaran',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: [
              for (var item in controller.filterPaymentStatusList)
                Obx(
                  () {
                    bool isSelected =
                        controller.objectFilter.value['payment_status'] ==
                            item['value'];
                    return GestureDetector(
                      onTap: () {
                        controller.onChangeFilterPaymentStatus(item);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            color: isSelected ? ColorConstant.DEF : null),
                        child: Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 15.0,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                )
            ],
          )
        ],
      ),
    );
  }
}
