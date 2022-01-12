import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class OrderEmpty extends StatelessWidget {
  const OrderEmpty(
      {Key? key,
      this.svgAsset = 'assets/svg/order_empty.svg',
      this.text = 'Belum ada transaksi'})
      : super(key: key);
  final String svgAsset;
  final String text;

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
                  svgAsset,
                  fit: BoxFit.cover,
                  height: 170.0,
                ),
                SizedBox(height: 32.0),
                Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: ColorConstant.DEF,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
