import 'package:flutter/material.dart';

class HomeLogo extends StatelessWidget {
  HomeLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_new_white_without_slogan.png',
      // height: 100.0,
      width: 100.0,
    );
  }
}
