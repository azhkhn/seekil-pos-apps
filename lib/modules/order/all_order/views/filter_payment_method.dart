import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';

class AllOrderFilterPaymentMethod extends StatelessWidget {
  AllOrderFilterPaymentMethod({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaksi Berlangsung',
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
              for (var item in controller.filterOrderStatusList)
                Obx(() {
                  bool isSelected =
                      controller.objectFilter.value['order_status_id'] ==
                          item['id'].toString();

                  return GestureDetector(
                    onTap: () {
                      controller.onChangeFilterOrderStatus(item);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          border: Border.all(color: Colors.black54),
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
                })
            ],
          )
        ],
      ),
    );
  }
}
