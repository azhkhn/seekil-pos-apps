import 'package:flutter/material.dart';
import 'package:seekil_back_office/modules/home/main.dart';
import 'package:seekil_back_office/modules/order/list/main.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedNavbarIndex = 0;

  void _onNavbarTapped(int index) {
    setState(() {
      _selectedNavbarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _pages = <Widget>[Home(), Order()];

    final _bottomNavbarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Beranda',
          activeIcon: Icon(Icons.home_rounded)),
      BottomNavigationBarItem(
          icon: Icon(Icons.receipt_outlined),
          label: 'Transaksi',
          activeIcon: Icon(Icons.receipt_rounded)),
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
          onTap: _onNavbarTapped,
          currentIndex: _selectedNavbarIndex,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: ColorConstant.DEF,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed),
    );
  }
}
