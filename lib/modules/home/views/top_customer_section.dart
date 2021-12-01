import 'package:flutter/material.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class TopCustomerSection extends StatefulWidget {
  const TopCustomerSection({Key? key, required this.topCustomerList})
      : super(key: key);

  final Future<List<dynamic>> topCustomerList;

  @override
  _TopCustomerSectionState createState() => _TopCustomerSectionState();
}

class _TopCustomerSectionState extends State<TopCustomerSection> {
  OrderUtils orderUtils = OrderUtils();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Paling sering cuci',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: Card(
                elevation: 4.0,
                child: FutureBuilder(
                    future: widget.topCustomerList,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return _customersShimmer();
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            List<dynamic> data = snapshot.data as List<dynamic>;

                            if (data.isNotEmpty) {
                              return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: data.length,
                                  separatorBuilder: (context, index) => Divider(
                                        height: 2.0,
                                        color: Colors.grey,
                                      ),
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child:
                                            Icon(Icons.account_circle_rounded),
                                      ),
                                      title: Text(data[index]['customer.name']),
                                      subtitle: Text(
                                          '${data[index]['total_order']} items'),
                                    );
                                  });
                            } else {
                              return Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'Tidak ada data ditemukan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 16.0),
                                ),
                              ));
                            }
                          }
                          return Container();
                      }
                    })),
          )
        ],
      ),
    );
  }

  Widget _customersShimmer() {
    return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => Divider(
              height: 2.0,
              color: Colors.grey,
            ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: MyShimmer(child: CircleAvatar()),
            title: MyShimmer(
              width: 100,
              height: 10,
            ),
            subtitle: MyShimmer(
              width: 80,
              height: 10,
            ),
          );
        });
  }
}
