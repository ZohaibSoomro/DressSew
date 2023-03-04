import 'package:dresssew/models/tailor.dart';
import 'package:dresssew/screens/tailor/tailor_profle.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TailorCard extends StatelessWidget {
  const TailorCard({Key? key, required this.tailor}) : super(key: key);
  final Tailor tailor;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: kInputStyle.copyWith(locale: context.locale, fontSize: 20),
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                  textAlign: TextAlign.start,
                ),
                trailing: IconButton(
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  icon: Icon(FontAwesomeIcons.arrowRight,
                      size: 20, color: Theme.of(context).primaryColor),
                  onPressed: () {
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
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Stitches for: ",
                      style: kInputStyle.copyWith(fontSize: 15),
                    ).tr(),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    Text(
                      tailor.stitchingType == StitchingType.both
                          ? capitalizeText("Gents, Ladies.")
                          : capitalizeText('${tailor.stitchingType.name}.'),
                      style: kTextStyle.copyWith(fontSize: 12),
                    ).tr(),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(15.0, 5, 0, 0),
              //   child: Text(
              //     'Expertise:',
              //     style: kInputStyle.copyWith(fontSize: 15),
              //   ),
              // ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              tailor.stitchingType == StitchingType.both
                  ? Column(
                      children: [
                        buildExpertiseList("Gents", true),
                        buildExpertiseList("Ladies", false),
                      ],
                    )
                  : buildExpertiseList(tailor.stitchingType.name,
                      tailor.stitchingType == StitchingType.gents),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionTile buildExpertiseList(String listTitle, bool isForMen) {
    return ExpansionTile(
      title: Text(
        capitalizeText(listTitle),
        style: kInputStyle.copyWith(fontSize: 15),
      ),
      children: categorizeExpertise(tailor.expertise, isForMen).keys.map((key) {
        return ListTile(
          title: Text(
            key,
            style:
                kInputStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Wrap(
            spacing: 5,
            children: [
              ...List.generate(
                categorizeExpertise(tailor.expertise, isForMen)[key]!.length,
                (index) => InputChip(
                  label: Text(
                      categorizeExpertise(
                          tailor.expertise, isForMen)[key]![index],
                      style: kTextStyle.copyWith(fontSize: 12)),
                  onSelected: (val) {},
                  backgroundColor: Colors.grey.shade200,
                  avatar: const FlutterLogo(),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}

Map<String, List<String>> categorizeExpertise(
    List<String> expertise, bool isForMen) {
  Map<String, List<String>> finalMap = {};
  switch (isForMen) {
    case true:
      for (String element in expertise) {
        for (String key in menCategories.keys) {
          if (menCategories[key]!.contains(element)) {
            if (!finalMap.containsKey(key)) {
              finalMap[key] = [];
            }
            finalMap[key]!.add(element);
            break;
          }
        }
      }
      break;
    case false:
      for (String element in expertise) {
        for (String key in ladiesCategories.keys) {
          if (ladiesCategories[key]!.contains(element)) {
            if (!finalMap.containsKey(key)) {
              finalMap[key] = [];
            }
            finalMap[key]!.add(element);
            break;
          }
        }
      }
      break;
  }
  return finalMap;
}
