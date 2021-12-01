import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/services_list.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';

class MasterServices extends StatefulWidget {
  const MasterServices({Key? key}) : super(key: key);

  @override
  _MasterServicesState createState() => _MasterServicesState();
}

class _MasterServicesState extends State<MasterServices> {
  WordTransformation wt = WordTransformation();
  late Future<List<ServicesListModel>> servicesList;

  @override
  void initState() {
    super.initState();
    _fetchServicesList();
  }

  Future<void> _fetchServicesList() async {
    setState(() {
      servicesList = ServicesListModel.fetchServicesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _fetchServicesList,
        child: FutureBuilder(
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
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ExpansionPanelList(
                      expandedHeaderPadding: EdgeInsets.zero,
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          data[panelIndex].isExpanded = !isExpanded;
                        });
                      },
                      children: data.map((element) {
                        return ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: element.isExpanded,
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                                title: Text(element.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)));
                          },
                          body: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.description,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text('Estimasi ${element.estimate} hari',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    wt.currencyFormat(element.price),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return Container();
            }
          },
        ));
  }
}
