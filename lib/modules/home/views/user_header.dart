import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class HomeGreetings extends StatelessWidget {
  HomeGreetings(this.onLogout, {Key? key}) : super(key: key);
  final void Function()? onLogout;
  final WordTransformation wt = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HomeLogo(),
          Text(
            'Selamat ${wt.greeting()}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          HomeUserHeader(onLogout),
        ],
      ),
    );
  }
}

class HomeUserHeader extends StatelessWidget {
  const HomeUserHeader(this.onLogout, {Key? key}) : super(key: key);
  final void Function()? onLogout;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.only(right: 8.0),
        leading: Icon(
          Icons.account_circle_rounded,
          color: Colors.white,
          size: 48.0,
        ),
        title: Text(AuthHelper.isLoggedIn() ? AuthHelper.user().name : '-',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
        subtitle: Text(
            AuthHelper.isLoggedIn()
                ? AuthHelper.user().level.toUpperCase()
                : '-',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12.0)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.order),
              child: Icon(
                Icons.receipt_long_outlined,
                color: Colors.white,
                size: 32.0,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            GestureDetector(
                onTap: () => Get.dialog(
                    AlertDialog(
                      title: Text('Konfirmasi'),
                      content: Text('Anda yakin ingin keluar dari aplikasi?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text('Batal',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              primary: ColorConstant.DEF),
                        ),
                        TextButton(
                          child: Text('Keluar',
                              style: TextStyle(
                                  color: ColorConstant.DEF,
                                  fontWeight: FontWeight.bold)),
                          onPressed: onLogout,
                        ),
                      ],
                    ),
                    barrierDismissible: false),
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                  size: 32.0,
                )),
          ],
        ));
  }
}
