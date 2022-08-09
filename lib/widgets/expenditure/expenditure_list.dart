import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class ExpenditureList extends StatelessWidget {
  ExpenditureList(this.list, {Key? key, this.onEdit}) : super(key: key);
  final List<dynamic> list;
  final WordTransformation wt = WordTransformation();
  final void Function(ExpenditureModel)? onEdit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
      itemCount: list.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        ExpenditureModel item = list[index];
        return Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                item.name as String,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.description as String),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    wt.currencyFormat(item.price),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: IconButton(
                  tooltip: 'Edit',
                  onPressed: () => onEdit!(item),
                  icon: Icon(Icons.edit_outlined)),
            ),
          ),
        );
      },
    );
  }
}
