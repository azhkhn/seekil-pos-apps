import 'package:flutter/material.dart';
import 'package:seekil_back_office/modules/master/partnership/list/master_partnership.dart';
import 'package:seekil_back_office/modules/master/promo/list/master_promo.dart';
import 'package:seekil_back_office/modules/master/services/list/master_services.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class MasterData extends StatefulWidget {
  const MasterData({Key? key}) : super(key: key);

  @override
  _MasterDataState createState() => _MasterDataState();
}

class _MasterDataState extends State<MasterData>
    with AutomaticKeepAliveClientMixin<MasterData> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: WidgetHelper.appBar(
          'Master Data',
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              // Tab(text: 'Order'),
              Tab(text: 'Services'),
              Tab(text: 'Partnership'),
              Tab(text: 'Promo'),
            ],
          ),
        ),
        body: TabBarView(
          children: [MasterServices(), MasterPartnership(), MasterPromo()],
        ),
      ),
    );
  }
}
