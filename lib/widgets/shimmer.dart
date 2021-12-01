import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  const MyShimmer(
      {Key? key, this.width = 120.0, this.height = 16.0, this.child})
      : super(key: key);
  final double width;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      period: Duration(seconds: 1),
      gradient: LinearGradient(
        colors: [Colors.grey, Colors.white, Colors.grey],
      ),
      child: child != null
          ? Container(child: child)
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(4.0)),
            ),
    );
  }
}
