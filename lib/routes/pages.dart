import 'package:get/get.dart';
import 'package:seekil_back_office/main.widget.dart';
import 'package:seekil_back_office/modules/auth/login.dart';
import 'package:seekil_back_office/modules/expenditure/current_month/main.dart';
import 'package:seekil_back_office/modules/expenditure/fixed_monthly/main.dart';
import 'package:seekil_back_office/modules/home/bluetooth_page/main.dart';
import 'package:seekil_back_office/modules/home/employee/main.dart';
import 'package:seekil_back_office/modules/home/layanan/main.dart';
import 'package:seekil_back_office/modules/home/pelanggan/main.dart';
import 'package:seekil_back_office/modules/home/pembayaran/main.dart';
import 'package:seekil_back_office/modules/home/product/main.dart';
import 'package:seekil_back_office/modules/home/promosi/main.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/main.dart';
import 'package:seekil_back_office/modules/home/store/main.dart';
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
  static final appPages = [
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.home, page: () => Home()),
    GetPage(name: AppRoutes.order, page: () => AllOrder()),
    GetPage(
        name: AppRoutes.expenditureIncomingAndExpenses,
        page: () => ExpenditureIncomingAndExpenses()),
    GetPage(
        name: AppRoutes.expenditureCurrentMonth,
        page: () => ExpenditureCurrentMonth()),
    GetPage(
        name: AppRoutes.expenditureFixedMonthly,
        page: () => ExpenditureFixedMonthly()),
    GetPage(name: AppRoutes.orderDetail, page: () => OrderDetail()),
    GetPage(name: AppRoutes.orderAdd, page: () => OrderAddNew()),
    GetPage(name: AppRoutes.orderList, page: () => Order()),
    GetPage(name: AppRoutes.orderInvoice, page: () => OrderInvoice()),
    GetPage(name: AppRoutes.orderTracking, page: () => OrderTracking()),
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.mainWidget, page: () => MainWidget()),
    GetPage(name: AppRoutes.bluetoothPage, page: () => BluetoothPage()),
    GetPage(name: AppRoutes.servicesPage, page: () => ServicesPage()),
    GetPage(name: AppRoutes.paymentPage, page: () => PaymentPage()),
    GetPage(name: AppRoutes.customerPage, page: () => CustomerPage()),
    GetPage(name: AppRoutes.promotionPage, page: () => PromotionPage()),
    GetPage(name: AppRoutes.statistic, page: () => StatisticPage()),
    GetPage(name: AppRoutes.product, page: () => ProductPage()),
    GetPage(name: AppRoutes.employee, page: () => EmployeePage()),
    GetPage(name: AppRoutes.store, page: () => StorePage()),
  ];
}
