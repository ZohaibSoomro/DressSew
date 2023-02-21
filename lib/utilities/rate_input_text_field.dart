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
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        validator: !validateField
            ? null
            : (val) {
                if (val == null || val.isEmpty) {
                  return "enter a value";
                }
                return null;
              },
        style: kInputStyle,
        decoration: kTextFieldDecoration.copyWith(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          hintStyle: kInputStyle.copyWith(fontSize: 12),
          errorStyle: kInputStyle.copyWith(fontSize: 10),
          suffixText: suffixText,
          suffixStyle: kInputStyle.copyWith(fontSize: 12, color: Colors.grey),
        ),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }
}
