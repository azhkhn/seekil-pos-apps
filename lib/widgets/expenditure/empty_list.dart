import 'package:flutter/material.dart';

class ExpenditureEmptyList extends StatelessWidget {
  const ExpenditureEmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: 4.0),
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('-'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('-'),
                SizedBox(
                  height: 4.0,
                ),
                Text('Rp-')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
