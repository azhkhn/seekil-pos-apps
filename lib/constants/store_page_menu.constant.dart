import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/routes/routes.dart';

class StoreMenuConstant {
  static Color iconColor = Colors.black;

  static List<Map<String, dynamic>> menus = [
    {
      'title': 'Toko Saya',
      'menu': [
        {
          'menu_leading_icon': Icon(
            Icons.local_laundry_service_outlined,
            color: iconColor,
          ),
          'menu_title': 'Layanan',
          'menu_action': () => Get.toNamed(AppRoutes.servicesPage)
        },
        {
          'menu_leading_icon': Icon(
            Icons.person_outline_rounded,
            color: iconColor,
          ),
          'menu_title': 'Pelanggan',
          'menu_action': () => Get.toNamed(AppRoutes.customerPage)
        },
        {
          'menu_leading_icon': Icon(
            Icons.payments_outlined,
            color: iconColor,
          ),
          'menu_title': 'Pembayaran',
          'menu_action': () => Get.toNamed(AppRoutes.paymentPage)
        },
        {
          'menu_leading_icon': Icon(
            Icons.price_change_outlined,
            color: iconColor,
          ),
          'menu_title': 'Promosi',
          'menu_action': () => Get.toNamed(AppRoutes.promotionPage)
        },
      ]
    },
    {
      'title': 'Utilitas',
      'menu': [
        {
          'menu_leading_icon': Icon(Icons.print_outlined, color: iconColor),
          'menu_title': 'Printer',
          'menu_action': () => Get.toNamed(AppRoutes.bluetoothPage),
        }
      ]
    },
    {
      'title': 'Lainnya',
      'menu': [
        {
          'menu_leading_icon': Icon(Icons.logout_outlined, color: Colors.black),
          'menu_title': 'Keluar',
          'menu_action': () {
            Get.dialog(AlertDialog(
              title: Text('Konfirmasi'),
              content: Text('Anda yakin ingin keluar dari aplikasi?'),
              actions: [
                TextButton(onPressed: () => Get.back(), child: Text('Batal')),
                TextButton(
                  child: Text('Ya'),
                  onPressed: () {
                    GetStorage().remove(StorageKeyConstant.USER_LOGGED_IN);
                    Get.offAllNamed(AppRoutes.login);
                  },
                ),
              ],
            ));
          }
        }
      ]
    }
  ];
}
