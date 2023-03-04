import 'package:dresssew/models/tailor.dart';
import 'package:dresssew/screens/customer/dress_sewing_item.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/custom_widgets/rectangular_button.dart';
import 'package:dresssew/utilities/custom_widgets/tailor_Card.dart';
import 'package:dresssew/utilities/my_pie_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TailorProfile extends StatefulWidget {
  const TailorProfile({Key? key, required this.tailor}) : super(key: key);
  final Tailor tailor;
  @override
  State<TailorProfile> createState() => _TailorProfileState();
}

class _TailorProfileState extends State<TailorProfile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     PopupMenuButton(itemBuilder: (context) {
      //       return [
      //         const PopupMenuItem(
      //           value: 'Settings',
      //           child: Text(
      //             'Settings',
      //             style: kInputStyle,
      //           ),
      //         ),
      //       ];
      //     }),
      //   ],
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                      CircleAvatar(
                        radius: size.width * 0.2,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          radius: size.width * 0.2 - 1,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: NetworkImage(
                            widget.tailor.profileImageUrl!,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        widget.tailor.tailorName,
                        style: kTitleStyle.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.2),
                  buildQualityItemsRow(),
                  const Divider(thickness: 0.5),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildTailorInfoCard(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildShopInfoCard(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildContactInfoCard(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: RectangularRoundedButton(
                padding: EdgeInsets.symmetric(vertical: 10),
                buttonName: 'Continue',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DressSewingChoiceScreen(
                              chosenTailor: widget.tailor)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildQualityItemsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: MyPieChart(
            title: 'On-time delivery',
            chartValue: widget.tailor.onTimeDelivery!,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.07),
            child: MyPieChart(
              title: 'Rating',
              chartValue: widget.tailor.rating!,
              isRatingChart: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTailorInfoCard() {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tailor Info.',
              style: kInputStyle.copyWith(color: Colors.grey),
            ).tr(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildHorizontalCardItem(
                    'Experience: ',
                    '${widget.tailor.experience} years approximately.',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildHorizontalCardItem(
                    'Stitches for: ',
                    widget.tailor.stitchingType == StitchingType.both
                        ? capitalizeText("Gents, Ladies.")
                        : capitalizeText(
                            '${widget.tailor.stitchingType.name}.'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expertise:',
                        style: kInputStyle,
                      ).tr(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      widget.tailor.stitchingType == StitchingType.both
                          ? Column(
                              children: [
                                buildExpertiseList("Gents", true),
                                buildExpertiseList("Ladies", false),
                              ],
                            )
                          : buildExpertiseList(
                              widget.tailor.stitchingType.name,
                              widget.tailor.stitchingType ==
                                  StitchingType.gents),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShopInfoCard() {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop Info.',
              style: kInputStyle.copyWith(color: Colors.grey),
            ).tr(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildHorizontalCardItem(
                    'Name: ',
                    '${widget.tailor.shop!.name}.',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildHorizontalCardItem(
                    'Address: ',
                    '${widget.tailor.shop!.address}.',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildHorizontalCardItem(
                    'City: ',
                    '${widget.tailor.shop!.city}.',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildHorizontalCardItem(
                    'Postal code: ',
                    '${widget.tailor.shop!.postalCode}.',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shop Images:',
                        style: kInputStyle,
                      ).tr(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildShopImageItem(
                              widget.tailor.shop!.shopImage1Url!),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          buildShopImageItem(widget.tailor.shop!.shopImage2Url!)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfoCard() {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Info.',
              style: kInputStyle.copyWith(color: Colors.grey),
            ).tr(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildHorizontalCardItem(
                    'Phone: ',
                    '${widget.tailor.phoneNumber}.',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildHorizontalCardItem(
                    'Email: ',
                    '${widget.tailor.email}.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShopImageItem(String url) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      image: DecorationImage(
        image: NetworkImage(url),
        fit: BoxFit.cover,
      ),
    );
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.17,
              horizontal: MediaQuery.of(context).size.width * 0.07,
            ),
            decoration: decoration.copyWith(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: decoration,
      ),
    );
  }

  ExpansionTile buildExpertiseList(String listTitle, bool isForMen) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: true,
      title: Text(
        capitalizeText(listTitle),
        style: kInputStyle.copyWith(fontSize: 15),
      ),
      children: categorizeExpertise(widget.tailor.expertise, isForMen)
          .keys
          .map((key) {
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
                categorizeExpertise(widget.tailor.expertise, isForMen)[key]!
                    .length,
                (index) => InputChip(
                  label: Text(
                      categorizeExpertise(
                          widget.tailor.expertise, isForMen)[key]![index],
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

  Row buildHorizontalCardItem(String firstItemText, String secondItemText) {
    return Row(
      children: [
        Text(
          firstItemText,
          style: kInputStyle,
        ).tr(),
        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
        Text(
          secondItemText,
          style: kTextStyle,
        ).tr(),
      ],
    );
  }
}
