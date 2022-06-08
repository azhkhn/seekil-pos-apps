import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/routes/routes.dart';

class HomeMenuConstant {
  static Color iconColor = Colors.black;
  static List<Map<String, dynamic>> menuStoreFeatures = [
    {
      'menu_icon': Icon(Icons.local_laundry_service_outlined,
          color: iconColor, size: 40.0),
      'menu_title': 'Layanan',
      'menu_action': () => Get.toNamed(AppRoutes.servicesPage)
    },
    {
      'menu_icon': Icon(Icons.groups_outlined, color: iconColor, size: 40.0),
      'menu_title': 'Pelanggan',
      'menu_action': () => Get.toNamed(AppRoutes.customerPage)
    },
    {
      'menu_icon': Icon(Icons.payment_outlined, color: iconColor, size: 40.0),
      'menu_title': 'Pembayaran',
      'menu_action': () => Get.toNamed(AppRoutes.paymentPage)
    },
    {
      'menu_icon':
          Icon(Icons.local_offer_outlined, color: iconColor, size: 40.0),
      'menu_title': 'Promosi',
      'menu_action': () => Get.toNamed(AppRoutes.promotionPage)
    },
    {
      'menu_icon':
          Icon(Icons.price_check_outlined, color: iconColor, size: 40.0),
      'menu_title': 'Pengeluaran Tetap',
      'menu_action': () => Get.toNamed(AppRoutes.expenditureFixedMonthly),
    },
    {
      'menu_icon':
          Icon(Icons.shopping_cart_outlined, color: iconColor, size: 40.0),
      'menu_title': 'Pengeluaran Bulanan',
      'menu_action': () => Get.toNamed(AppRoutes.expenditureCurrentMonth),
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
