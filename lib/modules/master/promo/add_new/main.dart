import 'package:flutter/material.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class AddNewPromo extends StatefulWidget {
  const AddNewPromo({Key? key}) : super(key: key);

  @override
  _AddNewPromoState createState() => _AddNewPromoState();
}

class _AddNewPromoState extends State<AddNewPromo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: WidgetHelper.appBar('title'));
  }
}
