import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:seekil_back_office/constants/order_status.constant.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list_card.dart';

class OrderWaitingList extends StatefulWidget {
  OrderWaitingList({Key? key}) : super(key: key);

  @override
  State<OrderWaitingList> createState() => _OrderWaitingListState();
}

class _OrderWaitingListState extends State<OrderWaitingList>
    with AutomaticKeepAliveClientMixin {
  final PagingController<int, OrderListModel> pagingController =
      PagingController<int, OrderListModel>(firstPageKey: 0);
  WordTransformation wt = WordTransformation();
  int pageSize = 10;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchDoneOrderList(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    pagingController.dispose();
  }

  Future<void> fetchDoneOrderList(dynamic pageKey) async {
    Map<String, String> objectParams = {
      'order_status_id': OrderStatusConstant.waitingList.toString(),
      'start_date': wt.firstDateOfMonth,
      'end_date': wt.endDateOfMonth
    };
    String queryParams = Uri(queryParameters: objectParams).query;

    try {
      final newItems =
          await OrderListModel.fetchOrderList(queryParams, pageKey.toString());
      final isLastPage = newItems.length < pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            svgAsset: 'assets/svg/order_done.svg',
            text: 'Transaksi yang mau dicuci\ntampil di sini, ya!',
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
