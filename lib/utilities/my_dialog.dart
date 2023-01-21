import 'package:flutter/material.dart';

import 'constants.dart';

Future showMyDialog(context, String title, String msg,
    {int disposeAfterMillis = 2000, bool isError = true}) async {
  return showDialog(
    context: context,
    builder: (context) {
      Future.delayed(Duration(milliseconds: disposeAfterMillis), () {
        Navigator.pop(context);
      });
      return AlertDialog(
        title: Center(
            child: Text(title,
                style: kTitleStyle.copyWith(
                    color: isError ? Colors.red : Colors.blue, fontSize: 22))),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
      );
    },
  );
}
