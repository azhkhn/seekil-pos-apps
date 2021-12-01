import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';

class MasterPromo extends StatefulWidget {
  const MasterPromo({Key? key}) : super(key: key);

  @override
  _MasterPromoState createState() => _MasterPromoState();
}

class _MasterPromoState extends State<MasterPromo>
    with AutomaticKeepAliveClientMixin {
  WordTransformation wt = WordTransformation();
  Future<List<dynamic>>? _promoList;

  @override
  void initState() {
    super.initState();
    fetchPartnerships();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> fetchPartnerships() async {
    setState(() {
      _promoList = MasterDataModel.fetchMasterPromo();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
        onRefresh: fetchPartnerships,
        child: Scaffold(
          body: FutureBuilder(
            future: _promoList,
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
                        return Divider(height: 16.0, color: Colors.grey);
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data[index]['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                            SizedBox(height: 8.0),
                            Text('Kode : ${data[index]['code']}',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14.0)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(data[index]['description'],
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16.0)),
                            ),
                            Text('Berakhir Pada',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14.0)),
                            Text(
                                data[index]['end_date'] != null
                                    ? wt.dateFormatter(
                                        date: data[index]['end_date'])
                                    : '-',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14.0)),
                          ],
                        );
                      },
                    );
                  }
                  return Container();
              }
            },
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.add_rounded),
          //   tooltip: 'Add New Promo',
          //   onPressed: () {
          //     showModalBottomSheet(
          //       context: context,
          //       builder: (_) => ListView(
          //         padding: const EdgeInsets.all(16.0),
          //         children: [
          //           Expanded(
          //               child: Column(
          //             children: [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Text('Add New Promo',
          //                       style: TextStyle(
          //                           fontSize: 24.0,
          //                           fontWeight: FontWeight.bold)),
          //                   IconButton(
          //                     icon: Icon(Icons.close_rounded),
          //                     onPressed: () => Get.back(),
          //                     iconSize: 32.0,
          //                   )
          //                 ],
          //               ),
          //               SizedBox(height: 24.0),
          //               MyFormField(label: 'Name'),
          //               Row(
          //                 children: [
          //                   Expanded(child: MyFormField(label: 'Code')),
          //                   SizedBox(width: 16.0),
          //                   Expanded(child: MyFormField(label: 'Discount'))
          //                 ],
          //               ),
          //               MyFormField(label: 'Description'),
          //               Row(
          //                 children: [
          //                   Expanded(child: MyFormField(label: 'Start Date')),
          //                   SizedBox(width: 16.0),
          //                   Expanded(child: MyFormField(label: 'End Date'))
          //                 ],
          //               ),
          //             ],
          //           )),
          //           Container(
          //             width: MediaQuery.of(context).size.width,
          //             child: ElevatedButton(
          //               onPressed: () {},
          //               child: Text('Save'),
          //               style: ElevatedButton.styleFrom(
          //                   padding: const EdgeInsets.all(16.0),
          //                   textStyle: TextStyle(
          //                       fontSize: 16.0, fontWeight: FontWeight.bold)),
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ));
  }
}
