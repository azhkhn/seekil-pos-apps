import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/routes/routes.dart';

class HomeContentStaff extends StatelessWidget {
  const HomeContentStaff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height / 2,
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: ColorConstant.INFO,
            border: Border.all(color: ColorConstant.INFO_BORDER),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'Transaksi di atas tanggal 25, pembayaran harus di awal '
                  'karena untuk closing akhir bulan',
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 32.0),
          child: SvgPicture.asset(
            'assets/svg/order_add_new.svg',
            fit: BoxFit.cover,
            height: 170.0,
          ),
        ),
        Container(
          width: Get.width / 2,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.orderAdd),
            child: Text(
              'Buat Transaksi Baru',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: ColorConstant.DEF,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
