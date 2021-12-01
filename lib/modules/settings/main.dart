import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/store_page_menu.constant.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          toolbarHeight: Get.height * .16,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark),
          title: Column(
            children: [
              Text(
                AuthHelper.user().username,
                style: TextStyle(color: Colors.black, fontSize: 24.0),
              ),
              Text(
                AuthHelper.user().level,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: StoreMenuConstant.menus.length,
          itemBuilder: (context, index) {
            var item = StoreMenuConstant.menus[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    item['title'],
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
                for (var menu in item['menu'])
                  ListTile(
                    minLeadingWidth: 8.0,
                    leading: menu['menu_leading_icon'],
                    title: Text(menu['menu_title']),
                    onTap: menu['menu_action'],
                  )
              ],
            );
          },
        ));
  }
}
