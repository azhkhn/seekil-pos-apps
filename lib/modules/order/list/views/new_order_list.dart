import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list_card.dart';

class OrderNewList extends StatelessWidget {
  OrderNewList({Key? key, required this.pagingController}) : super(key: key);
  final PagingController<int, OrderListModel> pagingController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: PagedListView<int, OrderListModel>(
        shrinkWrap: true,
        pagingController: pagingController,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        builderDelegate: PagedChildBuilderDelegate<OrderListModel>(
          itemBuilder: (context, item, index) {
            return OrderListCard(
              data: item,
              isRefreshed: (bool isRefreshed) {
                if (isRefreshed) Future.sync(() => pagingController.refresh());
              },
            );
          },
          noItemsFoundIndicatorBuilder: (context) => OrderEmpty(
            svgAsset: 'assets/svg/order_progress.svg',
            text: 'Transaksi yang baru masuk\ntampil di sini, ya!',
          ),
          firstPageProgressIndicatorBuilder: (context) {
            return OrderCardShimmer(
              onRefresh: () => Future.sync(() => pagingController.refresh()),
            );
          },
          newPageProgressIndicatorBuilder: (context) {
            return OrderCardShimmer(
              onRefresh: () => Future.sync(() => pagingController.refresh()),
            );
          },
        ),
      ),
    );
  }
}
