import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class GridFilterMenu extends StatelessWidget {
  const GridFilterMenu({
    Key? key,
    required this.title,
    required this.data,
    required this.itemBuilder,
  }) : super(key: key);
  final dynamic data;
  final String title;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8.0,
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3.3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0),
              itemCount: data.length,
              itemBuilder: itemBuilder),
        ],
      ),
    );
  }

  static GestureDetector rowMenuButton(
      {required Function() onTap,
      required bool selected,
      required String menuName}) {
    return GestureDetector(
        onTap: onTap,
        child: Badge(
          toAnimate: false,
          shape: BadgeShape.square,
          badgeColor: selected ? ColorConstant.INFO : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
              width: selected ? 2.0 : 1.0,
              color: selected ? ColorConstant.INFO_BORDER : Colors.grey),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          badgeContent: Text(
            menuName,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
