import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list_card.dart';

class AllOrderList extends StatelessWidget {
  AllOrderList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllOrderController>(
      builder: (controller) => RefreshIndicator(
        onRefresh: () =>
            Future.sync(() => controller.pagingController.refresh()),
        child: PagedListView<int, OrderListModel>(
          shrinkWrap: true,
          pagingController: controller.pagingController,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          builderDelegate: PagedChildBuilderDelegate<OrderListModel>(
            itemBuilder: (context, item, index) {
              return OrderListCard(
                data: item,
                isRefreshed: (bool isRefreshed) {
                  if (isRefreshed)
                    Future.sync(() => controller.pagingController.refresh());
                },
              );
            },
            noItemsFoundIndicatorBuilder: (context) => OrderEmpty(
              svgAsset: 'assets/svg/order_done.svg',
              text: 'Transaksi yang udah selesai\ntampil di sini, ya!',
            ),
            firstPageProgressIndicatorBuilder: (context) {
              return OrderCardShimmer(
                onRefresh: () =>
                    Future.sync(() => controller.pagingController.refresh()),
              );
            },
            newPageProgressIndicatorBuilder: (context) {
              return OrderCardShimmer(
                onRefresh: () =>
                    Future.sync(() => controller.pagingController.refresh()),
              );
            },
          ),
        ),
      ),
    );
  }
}
