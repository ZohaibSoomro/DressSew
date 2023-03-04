import 'package:dresssew/models/tailor.dart';
import 'package:dresssew/screens/customer/customer_main_screen.dart';
import 'package:dresssew/screens/customer/customer_measurements_page.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DressSewingChoiceScreen extends StatelessWidget {
  const DressSewingChoiceScreen({Key? key, required this.chosenTailor})
      : super(key: key);
  final Tailor chosenTailor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Choose an item to proceed',
                  style: kInputStyle.copyWith(fontSize: 25),
                  textAlign: TextAlign.center,
                ).tr(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Expanded(
                child: ListView.builder(
                  itemCount: chosenTailor.rates.length,
                  // itemExtent: 100,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerMeasurementsPage(
                                    customer: currentCustomer!,
                                    chosenDressItem: chosenTailor.rates[index],
                                  )),
                        );
                      },
                      title: Text(
                        chosenTailor.rates[index].category,
                        style: kInputStyle,
                      ),
                      subtitle: Text(
                        "Rs.${chosenTailor.rates[index].price}",
                        style: kTextStyle.copyWith(color: Colors.white),
                      ),
                      trailing: const Icon(
                        FontAwesomeIcons.arrowRight,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
