import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/home_menu.constant.dart';

class HomeOthers extends StatelessWidget {
  const HomeOthers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: HomeMenuConstant.menus.length,
      itemBuilder: (context, index) {
        var item = HomeMenuConstant.menus[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 8.0,
              ),
              child: Text(item['title'],
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ),
            for (var menu in item['menu'])
              ListTile(
                minLeadingWidth: 10.0,
                dense: true,
                leading: Container(
                  height: double.infinity,
                  child: menu['menu_leading_icon'],
                ),
                title: Text(
                  menu['menu_title'],
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  menu['menu_subtitle'],
                  style: TextStyle(fontSize: 12.5),
                ),
                onTap: menu['menu_action'],
              ),
          ],
        );
      },
    );
  }
}
