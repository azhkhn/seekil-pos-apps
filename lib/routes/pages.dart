import 'package:get/get.dart';
import 'package:seekil_back_office/main.widget.dart';
import 'package:seekil_back_office/modules/auth/login.dart';
import 'package:seekil_back_office/modules/order/detail/main.dart';
import 'package:seekil_back_office/modules/order/invoice/main.dart';
import 'package:seekil_back_office/modules/order/tracking/main.dart';
import 'package:seekil_back_office/modules/settings/layanan/main.dart';
import 'package:seekil_back_office/modules/settings/pelanggan/main.dart';
import 'package:seekil_back_office/modules/settings/pembayaran/main.dart';
import 'package:seekil_back_office/modules/settings/promosi/main.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/splash_screen.dart';
import 'package:seekil_back_office/modules/home/main.dart';
import 'package:seekil_back_office/modules/order/add_new/main.dart';
import 'package:seekil_back_office/modules/order/all_order/main.dart';
import 'package:seekil_back_office/modules/order/list/main.dart';
import 'package:seekil_back_office/modules/settings/bluetooth_page/main.dart';
import 'package:seekil_back_office/modules/settings/main.dart';

class AppPages {
  static final Transition _defaultTransition = Transition.cupertino;
  static final appPages = [
    GetPage(
        name: AppRoutes.login,
        page: () => LoginPage(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.home,
        page: () => Home(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.order,
        page: () => AllOrder(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.orderDetail,
        page: () => OrderDetail(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.orderAdd,
        page: () => OrderAddNew(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.orderList,
        page: () => Order(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.orderInvoice,
        page: () => OrderInvoice(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.orderTracking,
        page: () => OrderTracking(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.splashScreen,
        page: () => SplashScreen(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.mainWidget,
        page: () => MainWidget(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.settingsPage,
        page: () => SettingsPage(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.bluetoothPage,
        page: () => BluetoothPage(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.servicesPage,
        page: () => ServicesPage(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.paymentPage,
        page: () => PaymentPage(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.customerPage,
        page: () => CustomerPage(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.promotionPage,
        page: () => PromotionPage(),
        transition: _defaultTransition)
  ];
}
