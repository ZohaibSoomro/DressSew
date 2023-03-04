import 'package:dresssew/main.dart';
import 'package:dresssew/models/measurement.dart';
import 'package:dresssew/models/tailor.dart';
import 'package:dresssew/screens/customer/advance_deposit.dart';
import 'package:dresssew/screens/customer/customer_registration.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/custom_widgets/rate_input_text_field.dart';
import 'package:dresssew/utilities/custom_widgets/rectangular_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/customer.dart';

class CustomerMeasurementsPage extends StatefulWidget {
  final Rates chosenDressItem;

  const CustomerMeasurementsPage(
      {Key? key, required this.customer, required this.chosenDressItem})
      : super(key: key);
  final Customer customer;
  @override
  State<CustomerMeasurementsPage> createState() =>
      _CustomerMeasurementsPageState();
}

class _CustomerMeasurementsPageState extends State<CustomerMeasurementsPage> {
  List<Measurement> measurements = List.generate(
    measurementImages.length,
    (index) => Measurement(
        title: capitalizeText(spaceSeparatedNameOfMeasurement(
            measurementImages.keys.elementAt(index))),
        measure: 0),
  );
  final measurementsControllers = List.generate(
      measurementImages.length, (index) => TextEditingController(text: '0'));

  MeasurementChoice? measurementChoice;

  setControllerValuesToCustomers() {
    if (widget.customer.measurements.isNotEmpty) {
      for (int i = 0; i < widget.customer.measurements.length; i++) {
        String val = widget.customer.measurements[i].measure.toString();
        measurementsControllers[i].text = val;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setControllerValuesToCustomers();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: size.width * 0.01,
                      ),
                      Text(
                        'Add Measurements',
                        textAlign: TextAlign.center,
                        style: kTitleStyle.copyWith(fontSize: 30),
                      ).tr(),
                      SizedBox(
                        height: size.width * 0.01,
                      ),
                      Text(
                        'for ${widget.chosenDressItem.category}',
                        textAlign: TextAlign.center,
                        style: kInputStyle.copyWith(fontSize: 20),
                      ).tr(),
                      SizedBox(
                        height: size.width * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          measurements.length,
                          (i) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 2, vertical: size.height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  height: size.height * 0.1,
                                  child: Align(
                                      alignment: isUrduActivated
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () => onMeasurementImageTapped(
                                            measurementImages.values
                                                .elementAt(i)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(measurementImages
                                                .values
                                                .elementAt(i))),
                                      )),
                                ),
                                const SizedBox(),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        capitalizeText(
                                          spaceSeparatedNameOfMeasurement(
                                              measurementImages.keys
                                                  .elementAt(i)),
                                        ),
                                        style: kInputStyle,
                                      ).tr(),
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    RateInputField(
                                      suffixText:
                                          isUrduActivated ? "انچ" : "in",
                                      onChanged: (val) {
                                        if (val != null && val.isNotEmpty) {
                                          try {
                                            measurements[i].measure =
                                                double.parse(val);
                                            if (mounted) setState(() {});
                                          } catch (e) {
                                            print('Exception parsing :$e');
                                          }
                                        }
                                      },
                                      validateField: false,
                                      controller: measurementsControllers[i],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.width * 0.02),
                    ],
                  ),
                ),
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
                        builder: (context) => AdvanceDepositPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onMeasurementImageTapped(String imageUrl) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      image: DecorationImage(
        image: AssetImage(imageUrl),
        fit: BoxFit.cover,
      ),
    );
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
  }
}
