import 'package:dresssew/utilities/rate_input_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ItemRateInputTile extends StatelessWidget {
  final String title;
  final Function(String?) onChanged;
  final TextEditingController controller;
  final bool validateField;

  const ItemRateInputTile({
    super.key,
    this.validateField = true,
    required this.title,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kInputStyle.copyWith(fontSize: 16),
          ).tr(),
          RateInputField(
            validateField: validateField,
            controller: controller,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
