import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late Future<List<dynamic>> servicesList;
  final WordTransformation wt = WordTransformation();

  @override
  void initState() {
    super.initState();
    fetchServicesList();
  }

  fetchServicesList() {
    servicesList = MasterDataModel.fetchMasterServices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper.appBar('Layanan'),
        floatingActionButton: AuthHelper.isSuperAdmin()
            ? FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add_outlined),
              )
            : null,
        body: FutureBuilder(
          future: servicesList,
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
                        title: Text(item['name']),
                        subtitle: Text(
                          item['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(wt.currencyFormat(item['price'])),
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
