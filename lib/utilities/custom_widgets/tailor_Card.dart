import 'package:dresssew/models/tailor.dart';
import 'package:dresssew/screens/tailor_profle.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TailorCard extends StatelessWidget {
  const TailorCard({Key? key, required this.tailor}) : super(key: key);
  final Tailor tailor;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: kInputStyle.copyWith(locale: context.locale, fontSize: 20),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            print("Tailor card tapped");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TailorProfile(
                  tailor: tailor,
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(tailor.profileImageUrl!),
                        backgroundColor: Colors.white,
                        radius: 25,
                      ),
                    ),
                    title: Text(
                      tailor.tailorName,
                      style: kInputStyle,
                    ),
                    subtitle: Text(
                      "${tailor.shop!.name}(${tailor.shop!.city})",
                      style: kTextStyle.copyWith(fontSize: 12),
                    ),
                    trailing: Text(
                      "${tailor.experience.toString()} years approx.",
                      style: kInputStyle.copyWith(
                          color: Colors.grey, fontSize: 10),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10, 0, 0),
                    child: Text(
                      'Expertise:',
                      style: kInputStyle,
                    ),
                  ),
                  Wrap(
                    spacing: 5,
                    children: [
                      ...List.generate(
                        tailor.expertise.length,
                        (index) => InputChip(
                          label: Text(tailor.expertise[index],
                              style: kTextStyle.copyWith(fontSize: 12)),
                          onSelected: (val) {},
                          backgroundColor: Colors.grey.shade200,
                          avatar: const FlutterLogo(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
