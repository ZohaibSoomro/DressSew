import 'package:dresssew/utilities/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExpandableListTile extends StatelessWidget {
  const ExpandableListTile({
    Key? key,
    this.initiallyExpanded = false,
    required this.listTitle,
    required this.childList,
    required this.onChildListItemPressed,
    this.onExpanded,
  }) : super(key: key);
  final bool initiallyExpanded;
  final Function(bool)? onExpanded;
  final String listTitle;
  final List<String> childList;
  final Function(String) onChildListItemPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5,
        ),
        elevation: 1.0,
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            listTitle,
            style: kInputStyle,
          ).tr(),
          onExpansionChanged: onExpanded,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemCount: childList.length,
              itemBuilder: (context, index2) => Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 5,
                ),
                elevation: 1.0,
                child: ListTile(
                  minLeadingWidth: MediaQuery.of(context).size.width * 0.02,
                  leading: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  title: Text(
                    childList[index2],
                    style: kTextStyle.copyWith(locale: context.locale),
                  ).tr(),
                  trailing: const Icon(Icons.add),
                  onTap: () => onChildListItemPressed(childList[index2]),
                ),
              ),
            ),
          ],
        ));
  }
}
