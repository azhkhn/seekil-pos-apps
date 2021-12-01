import 'package:flutter/material.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class ItemsSection extends StatefulWidget {
  const ItemsSection(this.itemsList, {Key? key}) : super(key: key);

  final Future<Map<String, dynamic>> itemsList;

  @override
  _ItemsSectionState createState() => _ItemsSectionState();
}

class _ItemsSectionState extends State<ItemsSection> {
  WordTransformation wt = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 5)),
        ],
      ),
      child: ExpansionTile(
          childrenPadding: EdgeInsets.zero,
          tilePadding: EdgeInsets.zero,
          collapsedIconColor: Colors.black,
          collapsedTextColor: Colors.black,
          iconColor: Colors.black,
          textColor: Colors.black,
          title: Text('Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          children: [
            FutureBuilder(
              future: widget.itemsList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      snapshot.data as Map<String, dynamic>;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: data['list'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['list'][index]['item_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0)),
                                SizedBox(height: 4.0),
                                for (var service in data['list'][index]
                                    ['services'])
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        service['name'],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        wt.currencyFormat(
                                          service['price'],
                                        ),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                SizedBox(height: 4.0),
                                if (data['list'][index]['note'] != null)
                                  Text(data['list'][index]['note'],
                                      style: TextStyle(color: Colors.grey)),
                              ],
                            )),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            )
          ]),
    );
  }
}
