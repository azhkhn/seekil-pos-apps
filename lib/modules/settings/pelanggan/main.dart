import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/customer_list.model.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late Future<List<dynamic>> customerList;

  @override
  void initState() {
    super.initState();
    fetchCustomerList();
  }

  fetchCustomerList() {
    customerList = CustomerListModel.fetchCustomerList('customer');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper.appBar('Pelanggan'),
        body: FutureBuilder(
          future: customerList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return LoadingIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index];
                      return ListTile(
                        leading: CircleAvatar(),
                        title: Text(item.name),
                        subtitle: Text(item.whatsapp ?? '-'),
                        trailing: IconButton(
                          icon: Icon(Icons.chat),
                          onPressed: () {},
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: Text('Tidak ada data'),
                );
            }
          },
        ));
  }
}
