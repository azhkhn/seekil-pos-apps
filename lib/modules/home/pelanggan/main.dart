import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/customer_list.model.dart';
import 'package:seekil_back_office/modules/home/pelanggan/controller.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class CustomerPage extends StatelessWidget {
  final controller = Get.put(CustomerPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetHelper.appBar(
        'Pelanggan',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: SearchBar(controller: controller),
          ),
        ),
      ),
      body: GetBuilder<CustomerPageController>(
        builder: (controller) => RefreshIndicator(
          onRefresh: () =>
              Future.sync(() => controller.pagingController.refresh()),
          child: PagedListView<int, CustomerListModel>(
            shrinkWrap: true,
            pagingController: controller.pagingController,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            builderDelegate: PagedChildBuilderDelegate<CustomerListModel>(
              itemBuilder: (context, item, index) {
                return ListTile(
                  leading: Icon(
                    Icons.account_circle_rounded,
                    color: ColorConstant.DEF,
                    size: 48.0,
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.whatsapp),
                  trailing: IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {
                      OrderUtils().launchWhatsapp(
                        number: item.whatsapp,
                        message: 'Hi *${item.name}*',
                      );
                    },
                  ),
                );
              },
              // noItemsFoundIndicatorBuilder: (context) => OrderEmpty(
              //   svgAsset: 'assets/svg/order_done.svg',
              //   text: 'Transaksi yang udah selesai\ntampil di sini, ya!',
              // ),
              // firstPageProgressIndicatorBuilder: (context) {
              //   return OrderCardShimmer(
              //     onRefresh: () =>
              //         Future.sync(() => controller.pagingController.refresh()),
              //   );
              // },
              // newPageProgressIndicatorBuilder: (context) {
              //   return OrderCardShimmer(
              //     onRefresh: () =>
              //         Future.sync(() => controller.pagingController.refresh()),
              //   );
              // },
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.controller}) : super(key: key);

  final CustomerPageController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        // key: Key(controller.searchInput.value),
        cursorColor: ColorConstant.DEF,
        initialValue: controller.searchInput.value,
        onFieldSubmitted: controller.onFieldSubmitted,
        textInputAction: TextInputAction.search,
        onChanged: controller.onChangeSearchInput,
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          fillColor: Colors.grey[200],
          hintText: 'Cari Nama Pelanggan',
          hintStyle: TextStyle(fontSize: 14.0),
          suffixIconConstraints: BoxConstraints(minWidth: 40.0),
          prefixIconConstraints: BoxConstraints(minWidth: 40.0),
          prefixIcon: Icon(Icons.search, color: ColorConstant.DEF),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          suffixIcon: controller.searchInput.value.isNotEmpty
              ? GestureDetector(
                  onTap: controller.resetSearchBar,
                  child: Icon(Icons.close_rounded, color: ColorConstant.DEF),
                )
              : null,
        ),
      ),
    );
  }
}
