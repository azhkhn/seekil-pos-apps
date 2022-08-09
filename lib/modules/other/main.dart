import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/home_menu.constant.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OtherMenuPage extends StatelessWidget {
  const OtherMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Lainnya'),
      backgroundColor: Colors.white,
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: HomeMenuConstant.menus.length,
        itemBuilder: (context, index) {
          var item = HomeMenuConstant.menus[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var menu in item['menu'])
                ListTile(
                  minLeadingWidth: 10.0,
                  leading: Container(
                    height: double.infinity,
                    child: menu['menu_leading_icon'],
                  ),
                  title: Text(
                    menu['menu_title'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(menu['menu_subtitle']),
                  onTap: menu['menu_action'],
                ),
            ],
          );
        },
      ),
    );
  }
}
