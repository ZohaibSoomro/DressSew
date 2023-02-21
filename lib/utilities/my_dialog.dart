import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

Future showMyBanner(context, text) async {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      onVisible: () {
        Future.delayed(Duration(milliseconds: 1200)).then((value) =>
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner());
      },
      content: Text(
        text,
        style: kTextStyle,
      ).tr(),
      backgroundColor: Colors.white70,
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('Dismiss', style: kInputStyle).tr(),
        )
      ],
    ),
  );
}

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
                        color: isError ? Colors.red : Colors.blue,
                        fontSize: 22))
                .tr()),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ).tr(),
      );
    },
  );
}
