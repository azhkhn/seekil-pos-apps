import 'package:flutter/material.dart';

class MyFutureBuilder extends StatelessWidget {
  const MyFutureBuilder(
      {Key? key,
      required this.future,
      required this.onLoading,
      required this.onSuccess,
      required this.onEmpty,
      required this.onSuccessCallback})
      : super(key: key);
  final Future<dynamic> future;
  final Widget onLoading;
  final Widget onSuccess;
  final Widget onEmpty;
  final ValueChanged<Widget> onSuccessCallback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return onLoading;
          case ConnectionState.done:
            if (snapshot.hasData) {
              return onSuccess;
            }
            return onEmpty;
        }
      },
    );
  }
}
