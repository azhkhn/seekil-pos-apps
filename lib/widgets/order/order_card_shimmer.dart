import 'package:flutter/material.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class OrderCardShimmer extends StatelessWidget {
  OrderCardShimmer({required this.onRefresh});
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      itemCount: 3,
      separatorBuilder: (context, index) {
        return Divider(height: 32.0, color: Colors.grey);
      },
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyShimmer(),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyShimmer(width: 80),
                MyShimmer(),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyShimmer(),
                MyShimmer(width: 50),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyShimmer(width: 50),
                MyShimmer(),
              ],
            )
          ],
        );
      },
    );
  }
}
