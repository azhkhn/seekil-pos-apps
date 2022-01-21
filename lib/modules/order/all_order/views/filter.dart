import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/modules/order/all_order/views/filter_date_range.dart';
import 'package:seekil_back_office/modules/order/all_order/views/filter_payment_method.dart';
import 'package:seekil_back_office/modules/order/all_order/views/filter_payment_status.dart';

class AllOrderFilter extends StatelessWidget {
  AllOrderFilter({Key? key}) : super(key: key);
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Badge(
        position: BadgePosition.topEnd(top: -4.0, end: 0.0),
        padding: EdgeInsets.all(6.0),
        badgeColor: ColorConstant.DEF,
        animationType: BadgeAnimationType.fade,
        showBadge: controller.filterCount.value.isNotEmpty,
        badgeContent: Text(
          controller.filterCount.value,
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(
          onPressed: _modalFilter,
          icon: Icon(Icons.filter_list_rounded),
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _modalFilterTitle() => Row(
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
            onPressed: controller.resetQueryParam,
            child: Text(
              'Reset',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.grey,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
                decorationColor: ColorConstant.DEF,
                decorationThickness: 2.5
              ),
            ),
          )
        ],
      );

  Widget _modalFilterButtonApply() => Container(
        width: Get.width,
        child: ElevatedButton(
          onPressed: controller.onApplyFilter,
          child: Text('Lihat Hasil'),
          style: ElevatedButton.styleFrom(
            primary: ColorConstant.DEF,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  void _modalFilter() {
    Get.bottomSheet(
      BottomSheet(
        onClosing: () {
          controller.resetQueryParam();
          Get.back();
        },
        backgroundColor: Colors.white,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.0),
            topLeft: Radius.circular(24.0),
          ),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.all(16.0),
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
              _modalFilterTitle(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AllOrderFilterPaymentStatus(),
                  AllOrderFilterPaymentMethod(),
                  AllOrderFilterDateRange(this._modalFilter),
                ],
              ),
              _modalFilterButtonApply()
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }
}
