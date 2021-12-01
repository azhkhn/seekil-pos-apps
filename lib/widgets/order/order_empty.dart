import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight
          ),
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/order_empty.svg',
                  fit: BoxFit.cover,
                  height: 200.0,
                ),
                SizedBox(height: 16.0),
                Text('Belum ada pesanan', style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
