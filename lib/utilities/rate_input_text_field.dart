import 'package:dresssew/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RateInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool validateField;
  final Function(String?) onChanged;

  final String? suffixText;

  const RateInputField(
      {super.key,
      this.suffixText,
      required this.controller,
      this.validateField = true,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.32,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        validator: !validateField
            ? null
            : (val) {
                if (val == null || val.isEmpty) {
                  return isUrduActivated ? "ایک قدر درج کریں" : "enter a value";
                }
                return null;
              },
        style: kInputStyle.copyWith(
          locale: context.locale,
        ),
        decoration: kTextFieldDecoration.copyWith(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          hintStyle: kInputStyle.copyWith(fontSize: 12, locale: context.locale),
          errorStyle:
              kInputStyle.copyWith(fontSize: 10, locale: context.locale),
          suffixText: suffixText,
          suffixStyle: kInputStyle.copyWith(
              fontSize: 12, color: Colors.grey, locale: context.locale),
        ),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }
}
