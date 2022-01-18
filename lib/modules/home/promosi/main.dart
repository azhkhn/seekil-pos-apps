import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class PromotionPage extends StatefulWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  _PromotionPageState createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  late Future<List<dynamic>> promoList;

  @override
  void initState() {
    super.initState();
    fetchPromoList();
  }

  fetchPromoList() {
    promoList = MasterDataModel.fetchMasterPromo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Promosi'),
      floatingActionButton: AuthHelper.isSuperAdmin()
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: ColorConstant.DEF,
              child: Icon(Icons.add_rounded),
            )
          : null,
      body: FutureBuilder(
        future: promoList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return LoadingIndicator();
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<dynamic> data = snapshot.data as List<dynamic>;
                return ListView.separated(
                  padding: EdgeInsets.all(16.0),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    var item = data[index];
                    bool status = item['status'] == 0 ? true : false;
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetHelper.badgeText(item['code']),
                              Switch(
                                value: status,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(item['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0))),
                          Text(item['description'])
                        ],
                      ),
                    );
                  },
                );
              }
              return Center(child: Text('Tidak ada data'));
          }
        },
      ),
    );
  }
}
