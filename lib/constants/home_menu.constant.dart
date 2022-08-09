import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/routes/routes.dart';

class HomeMenuConstant {
  static Color iconColor = Colors.black;
  static const iconSize = 32.0;
  static List<Map<String, dynamic>> menuStoreFeatures = [
    {
      'menu_icon': Icon(Icons.local_laundry_service_outlined,
          color: iconColor, size: iconSize),
      'menu_title': 'Layanan',
      'menu_action': () => Get.toNamed(AppRoutes.servicesPage)
    },
    {
      'menu_icon':
          Icon(Icons.groups_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Pelanggan',
      'menu_action': () => Get.toNamed(AppRoutes.customerPage)
    },
    {
      'menu_icon':
          Icon(Icons.payment_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Pembayaran',
      'menu_action': () => Get.toNamed(AppRoutes.paymentPage)
    },
    {
      'menu_icon':
          Icon(Icons.local_offer_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Promosi',
      'menu_action': () => Get.toNamed(AppRoutes.promotionPage)
    },
    {
      'menu_icon':
          Icon(Icons.price_check_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Pengeluaran Tetap',
      'menu_action': () => Get.toNamed(AppRoutes.expenditureFixedMonthly),
    },
    {
      'menu_icon':
          Icon(Icons.shopping_cart_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Pengeluaran Bulanan',
      'menu_action': () => Get.toNamed(AppRoutes.expenditureCurrentMonth),
    },
    {
      'menu_icon':
          Icon(Icons.liquor_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Produk',
      'menu_action': () => Get.toNamed(AppRoutes.product),
    },
    {
      'menu_icon': Icon(Icons.badge_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Karyawan',
      'menu_action': () => Get.toNamed(AppRoutes.employee),
    },
    {
      'menu_icon': Icon(Icons.store_outlined, color: iconColor, size: iconSize),
      'menu_title': 'Store',
      'menu_action': () => Get.toNamed(AppRoutes.store),
    },
  ];
  static List<Map<String, dynamic>> menus = [
    {
      'title': 'Menu Lainnya',
      'menu': [
        {
          'menu_leading_icon': Icon(
            Icons.insights_outlined,
            color: iconColor,
          ),
          'menu_title': 'Data Statistik',
          'menu_subtitle': 'Lihat grafik transaksi',
          'menu_action': () => Get.toNamed(AppRoutes.statistic),
        },
        {
          'menu_leading_icon':
              Icon(Icons.leaderboard_outlined, color: iconColor),
          'menu_title': 'Data Teratas',
          'menu_subtitle': 'Lihat data pelanggan terbanyak, layanan terbanyak',
          'menu_action': () => {}
        },
        {
          'menu_leading_icon': Icon(Icons.print_outlined, color: iconColor),
          'menu_title': 'Printer',
          'menu_subtitle': 'Lihat perangkat printer yang terhubung/tersedia',
          'menu_action': () => Get.toNamed(AppRoutes.bluetoothPage),
        }
      ]
    }
  ];
}
