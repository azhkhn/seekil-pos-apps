import 'package:flutter/material.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class MyOrderEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WordTransformation wt = WordTransformation();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('0', style: TextStyle(fontSize: 24.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('0 items'), Text(wt.currencyFormat(0))],
        )
      ],
    );
  }
}
