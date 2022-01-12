import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class OrderRefresh extends StatelessWidget {
  const OrderRefresh({Key? key, required this.onRefresh}) : super(key: key);
  final void Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/order_refresh.svg',
                  fit: BoxFit.cover,
                  height: 200.0,
                ),
                SizedBox(height: 24.0),
                ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: Icon(Icons.refresh_outlined),
                  label: Text('Muat Ulang'),
                  style: ElevatedButton.styleFrom(
                    primary: ColorConstant.DEF,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
