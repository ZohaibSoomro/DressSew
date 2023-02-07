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
          ),
          SizedBox(
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
              ),
              keyboardType: TextInputType.number,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
