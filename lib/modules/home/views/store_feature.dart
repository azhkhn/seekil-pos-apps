import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/home_menu.constant.dart';

class HomeStoreFeature extends StatelessWidget {
  const HomeStoreFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Menu Toko',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0),
          GridView.count(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
            children: HomeMenuConstant.menuStoreFeatures.map((e) {
              return GestureDetector(
                onTap: e['menu_action'],
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        e['menu_icon'],
                        Flexible(
                          child: Text(
                            e['menu_title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
