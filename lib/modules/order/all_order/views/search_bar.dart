import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';

class AllOrderSearchBar extends StatelessWidget {
  AllOrderSearchBar({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: ColorConstant.DEF,
              controller: controller.searchController,
              onFieldSubmitted: controller.handleSearchBar,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                isDense: true,
                prefixIcon: Icon(Icons.search),
                prefixIconConstraints: BoxConstraints(minWidth: 32),
                hintText: 'Cari Nama Pelanggan',
                hintStyle: TextStyle(fontSize: 14.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIconConstraints: BoxConstraints(minWidth: 32),
                suffixIcon: controller.searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: controller.resetSearchBar,
                        child: Icon(Icons.close_rounded),
                      )
                    : null,
                suffixIconColor: controller.searchController.text.isNotEmpty
                    ? Colors.black54
                    : null,
              ),
            ),
          ),
          Badge(
            position: BadgePosition.topEnd(top: -4.0, end: 0.0),
            padding: EdgeInsets.all(6.0),
            showBadge: true,
            badgeColor: ColorConstant.DEF,
            badgeContent: Text(
              '2',
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              onPressed: _modalFilter,
              icon: Icon(Icons.filter_list_rounded),
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  void _modalFilter() {
    Get.bottomSheet(
      BottomSheet(
        onClosing: () => Get.back(),
        builder: (context) => Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.white,
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  margin: EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Filter Transaksi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: ColorConstant.DEF,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
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
                    Text(
                      'Status Pembayaran',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Jenis Pembayaran',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rentang waktu',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      persistent: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24.0),
          topLeft: Radius.circular(24.0),
        ),
      ),
    );
  }
}
