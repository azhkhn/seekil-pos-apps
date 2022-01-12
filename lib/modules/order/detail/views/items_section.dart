import 'package:flutter/material.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class ItemsSection extends StatelessWidget {
  ItemsSection(this.itemsList, {Key? key}) : super(key: key);
  final Map<String, dynamic> itemsList;
  final WordTransformation wt = WordTransformation();

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
          initiallyExpanded: true,
          iconColor: Colors.black,
          textColor: Colors.black,
          title: Text('Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: itemsList['list'].length,
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
                          Text(itemsList['list'][index]['item_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16.0)),
                          SizedBox(height: 4.0),
                          for (var service in itemsList['list'][index]
                              ['services'])
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          if (itemsList['list'][index]['note'] != null)
                            Text(itemsList['list'][index]['note'],
                                style: TextStyle(color: Colors.grey)),
                        ],
                      )),
                    ],
                  ),
                );
              },
            )
          ]),
    );
  }
}
