import 'package:flutter/material.dart';

class ExpenditureErrorList extends StatelessWidget {
  const ExpenditureErrorList({Key? key, this.error}) : super(key: key);
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text('Error: $error'),
    ));
  }
}
