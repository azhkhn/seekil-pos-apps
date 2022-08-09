import 'package:flutter/material.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Produk'),
    );
  }
}
