import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';

class MasterPartnership extends StatefulWidget {
  const MasterPartnership({Key? key}) : super(key: key);

  @override
  _MasterPartnershipState createState() => _MasterPartnershipState();
}

class _MasterPartnershipState extends State<MasterPartnership>
    with AutomaticKeepAliveClientMixin {
  WordTransformation wt = WordTransformation();
  Future<List<dynamic>>? _partnershipList;

  @override
  void initState() {
    super.initState();
    fetchPartnerships();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> fetchPartnerships() async {
    setState(() {
      _partnershipList = MasterDataModel.fetchMasterPartnership();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
        onRefresh: fetchPartnerships,
        child: FutureBuilder(
          future: _partnershipList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return LoadingIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List<dynamic>? data = snapshot.data as List<dynamic>;

                  return ListView.separated(
                    itemCount: data.length,
                    padding: const EdgeInsets.all(16.0),
                    separatorBuilder: (context, index) {
                      return Divider(height: 8.0, color: Colors.grey);
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data[index]['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),
                              Text('${data[index]['potongan']}% Off',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(data[index]['address'],
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Start Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0)),
                                        Text(
                                            wt.dateFormatter(
                                                date: data[index]
                                                    ['start_date']),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16.0)),
                                      ],
                                    ),
                                    SizedBox(width: 8.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('End Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0)),
                                        Text(
                                            wt.dateFormatter(
                                                date: data[index]['end_date']),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16.0)),
                                      ],
                                    ),
                                  ],
                                )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Drop Point',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0)),
                                    Text(data[index]['drop_zone'].toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16.0)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return Container();
            }
          },
        ));
  }
}
