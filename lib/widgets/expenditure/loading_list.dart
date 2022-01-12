import 'package:flutter/material.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class ExpenditureLoadingList extends StatelessWidget {
  const ExpenditureLoadingList({Key? key}) : super(key: key);

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
            title: Wrap(
              children: [
                MyShimmer.rectangular(
                  width: 200.0,
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.0,
                ),
                MyShimmer.rectangular(),
                SizedBox(
                  height: 4.0,
                ),
                MyShimmer.rectangular(width: 70)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
