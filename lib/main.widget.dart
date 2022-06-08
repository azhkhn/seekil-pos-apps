import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seekil_back_office/modules/expenditure/current_month/main.dart';
import 'package:seekil_back_office/modules/home/main.dart';
import 'package:seekil_back_office/modules/order/list/main.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedNavbarIndex = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _firebaseMessagingServices();
  }

  @override
  Widget build(BuildContext context) {
    final _pages = <Widget>[
      Home(),
      Order(),
      if (AuthHelper.isStaff()) ExpenditureCurrentMonth()
    ];

    final _bottomNavbarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Beranda',
          activeIcon: Icon(Icons.home_rounded)),
      BottomNavigationBarItem(
          icon: Icon(Icons.receipt_outlined),
          label: 'Transaksi',
          activeIcon: Icon(Icons.receipt_rounded)),
      if (AuthHelper.isStaff())
        BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'Pengeluaran Bulanan',
            activeIcon: Icon(Icons.payment_rounded)),
    ];

    return Scaffold(
        body: IndexedStack(
          children: _pages,
          index: _selectedNavbarIndex,
        ),
        // body: _pages[_selectedNavbarIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavbarItems,
          backgroundColor: Colors.white,
          iconSize: 24.0,
          currentIndex: _selectedNavbarIndex,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: ColorConstant.DEF,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedNavbarIndex = index;
            });
          },
        ));
  }

  void _firebaseMessagingServices() {
    _firebaseMessaging.getToken().then((value) => {});
    _firebaseMessaging.subscribeToTopic('SeekilNotification');

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // When app is running on foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _handleNotification(message);
    });

    // When app is running on background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message);
    });
  }

  void _handleNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('seekil_channel_1', 'Seekil Channel',
            channelDescription: 'Seekil Notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1,
      notification?.title,
      notification?.body,
      platformChannelSpecifics,
    );
  }
}
