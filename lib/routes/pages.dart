import 'package:get/get.dart';
import 'package:seekil_back_office/main.widget.dart';
import 'package:seekil_back_office/modules/auth/login.dart';
import 'package:seekil_back_office/modules/expenditure/current_month/main.dart';
import 'package:seekil_back_office/modules/expenditure/fixed_monthly/main.dart';
import 'package:seekil_back_office/modules/home/bluetooth_page/main.dart';
import 'package:seekil_back_office/modules/home/layanan/main.dart';
import 'package:seekil_back_office/modules/home/pelanggan/main.dart';
import 'package:seekil_back_office/modules/home/pembayaran/main.dart';
import 'package:seekil_back_office/modules/home/promosi/main.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/main.dart';
import 'package:seekil_back_office/modules/order/detail/main.dart';
import 'package:seekil_back_office/modules/order/invoice/main.dart';
import 'package:seekil_back_office/modules/order/tracking/main.dart';
import 'package:seekil_back_office/modules/statistic/main.dart';
import 'package:seekil_back_office/routes/routes.dart';
import 'package:seekil_back_office/splash_screen.dart';
import 'package:seekil_back_office/modules/home/main.dart';
import 'package:seekil_back_office/modules/order/add_new/main.dart';
import 'package:seekil_back_office/modules/order/all_order/main.dart';
import 'package:seekil_back_office/modules/order/list/main.dart';

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
        name: AppRoutes.expenditureIncomingAndExpenses,
        page: () => ExpenditureIncomingAndExpenses(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.expenditureCurrentMonth,
        page: () => ExpenditureCurrentMonth(),
        transition: _defaultTransition),
    GetPage(
        name: AppRoutes.expenditureFixedMonthly,
        page: () => ExpenditureFixedMonthly(),
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
        transition: _defaultTransition),
    GetPage(
      name: AppRoutes.statistic,
      page: () => StatisticPage(),
      transition: _defaultTransition,
    ),
  ];
}
