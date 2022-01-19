import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list_card.dart';

class AllOrderList extends StatelessWidget {
  AllOrderList({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => RefreshIndicator(
              onRefresh: controller.fetchOrderList,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: state.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => OrderListCard(
                  data: state[index],
                  isRefreshed: (bool isRefreshed) {
                    if (isRefreshed) controller.fetchOrderList();
                  },
                ),
              ),
            ),
        onEmpty: OrderEmpty(),
        onLoading: OrderCardShimmer(onRefresh: controller.fetchOrderList));
  }
}
