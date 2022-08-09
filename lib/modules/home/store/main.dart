import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/modules/home/store/controller.dart';
import 'package:seekil_back_office/modules/home/store/views/cabang_list.dart';
import 'package:seekil_back_office/modules/home/store/views/drop_point_list.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class StorePage extends StatelessWidget {
  StorePage({Key? key}) : super(key: key);
  final controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        'Toko',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: TabBar(
            controller: controller.tabController,
            labelColor: ColorConstant.DEF,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            indicatorColor: ColorConstant.DEF,
            tabs: [
              Tab(text: 'Cabang'),
              Tab(text: 'Drop Point'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          StoreCabangList(),
          StoreDropPointList(),
        ],
      ),
    );
  }
}
