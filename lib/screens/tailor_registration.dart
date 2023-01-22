import 'dart:convert';

import 'package:dresssew/models/customer.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_dialog.dart';
import 'package:dresssew/utilities/rectangular_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../models/tailor.dart';

class TailorRegistration extends StatefulWidget {
  static const id = '/tailorRegistration';
  @override
  _TailorRegitrationState createState() => _TailorRegitrationState();
}

class _TailorRegitrationState extends State<TailorRegistration> {
  Customer? data;
  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final phoneNoController = TextEditingController();
  String countryCode = '+92';
  bool phoneNumberVerified = true;
  bool isVerifyingPhoneNumber = false;
  final websiteUrlController = TextEditingController();
  Gender? gender;
  bool registerPressed = false;
  Uint8List? imageBytes;
  Uint8List? initialImageBytes;
  StitchingType? stitchingType;

  List<String> selectedExpertise = [];
  List<String> unSelectedExpertise = [];

  final experienceController = TextEditingController();

  bool customizesDresses = false;
  @override
  void initState() {
    super.initState();
    //remove duplicates
    for (int i = 0; i < overallExpertise.length - 1; i++) {
      for (int j = i + 1; j < overallExpertise.length; j++) {
        if (overallExpertise[i] == overallExpertise[j]) {
          overallExpertise.removeAt(j);
        }
      }
    }
    (rootBundle.load("assets/user.png")).then((value) => setState(() => {
          initialImageBytes = value.buffer.asUint8List(),
          imageBytes = initialImageBytes
        }));
    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      // data = ModalRoute.of(context)!.settings.arguments as Customer;
      // print(data?.toJson());
      data = Customer.fromJson(
        json.decode(
            '{"address": null,"is_registered":false, "name": "Zohaib Hassan", "gender":"male","orders": [], "phone_number": null, "profile_image_url": null, "id": "AMjpKhlvWYfXbPAYqmb6", "date_joined": "2023-01-21T18:25:34.369762", "is_tailor": true, "email": "z1@gmail.com"}'),
      );
      print(data!.toJson());
    });
    phoneNoController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    phoneNoController.dispose();
    websiteUrlController.dispose();
    experienceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingOverlay(
      progressIndicator: SpinKitDoubleBounce(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.blue : Colors.white,
            ),
          );
        },
      ),
      isLoading: isVerifyingPhoneNumber,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register as Tailor',
            style: kInputStyle,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  registerPressed = false;
                  stitchingType = null;
                  gender = null;
                  experienceController.clear();
                  imageBytes = initialImageBytes;
                  customizesDresses = false;
                });
                showMyBanner(context, "Form cleared successfully.");
              },
              child: Text(
                'Clear',
                style: kTextStyle.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.01),
          child: SingleChildScrollView(
            child: AutofillGroup(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!phoneNumberVerified) buildPhoneNumberField(),
                    if (!phoneNumberVerified) buildSendCodeButton(),
                    if (phoneNumberVerified)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height * 0.01),
                          CircleAvatar(
                            radius: size.width * 0.25,
                            backgroundColor: Colors.blue,
                            child: CircleAvatar(
                              radius: size.width * 0.247,
                              backgroundColor: Colors.white,
                              backgroundImage: imageBytes == null
                                  ? null
                                  : MemoryImage(imageBytes!),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.25,
                                vertical: size.height * 0.002),
                            child: RectangularRoundedButton(
                              padding: EdgeInsets.zero,
                              fontSize: 15,
                              buttonName: 'Select',
                              onPressed: () async {
                                final file = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (file != null) {
                                  imageBytes = await file.readAsBytes();
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          buildGenderRow(),
                          SizedBox(height: size.height * 0.01),
                          buildStitchingTypeRow(size),
                          SizedBox(height: size.height * 0.01),
                          CheckboxListTile(
                            contentPadding: const EdgeInsets.only(left: 10),
                            title: Text(
                              'Do you customize dresses?',
                              style: kInputStyle.copyWith(fontSize: 18),
                            ),
                            subtitle: !registerPressed
                                ? null
                                : RichText(
                                    text: TextSpan(
                                      text: "You answered: ",
                                      style: kTextStyle,
                                      children: [
                                        TextSpan(
                                          text:
                                              customizesDresses ? 'Yes' : 'No',
                                          style: kTextStyle.copyWith(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ),
                            value: customizesDresses,
                            onChanged: (val) {
                              setState(() {
                                customizesDresses = val ?? false;
                              });
                            },
                          ),
                          SizedBox(height: size.height * 0.01),
                          buildTextFormField(
                              'Experience in no of years',
                              experienceController,
                              null,
                              "Enter experience in no of years",
                              keyboard: TextInputType.number),
                          SizedBox(height: size.height * 0.05),
                          RectangularRoundedButton(
                            buttonName: 'Register',
                            onPressed: () async {
                              setState(() {
                                registerPressed = true;
                                if (formKey.currentState!.validate() &&
                                    gender != null &&
                                    stitchingType != null) {
                                  print("Validation successful");
                                }
                              });
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildStitchingTypeRow(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Stitching type',
            style: kInputStyle.copyWith(
                fontSize: 18,
                color: stitchingType == null && registerPressed
                    ? Colors.red
                    : Colors.black),
          ),
          SizedBox(
            width: size.width * 0.3,
            child: DropdownButton<StitchingType>(
              value: stitchingType,
              borderRadius: BorderRadius.circular(10),
              icon: Icon(FontAwesomeIcons.chevronDown, size: 15),
              isDense: true,
              isExpanded: true,
              style: kTextStyle.copyWith(fontSize: 15),
              elevation: 2,
              iconEnabledColor: Colors.blue,
              items: List.generate(
                StitchingType.values.length,
                (index) => DropdownMenuItem(
                  value: StitchingType.values[index],
                  child: Text(
                      capitalizeMenuItem(StitchingType.values[index].name)),
                ),
              ),
              onChanged: (item) {
                setState(() {
                  stitchingType = item;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Row buildGenderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Gender',
          style: kInputStyle.copyWith(
              fontSize: 18,
              color: gender == null && registerPressed
                  ? Colors.red
                  : Colors.black),
        ),
        buildRadioTile('Male', Gender.male),
        buildRadioTile('Female', Gender.female),
      ],
    );
  }

  Row buildRadioTile(String text, Gender value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<Gender>(
          value: value,
          groupValue: gender,
          onChanged: (val) {
            setState(() {
              gender = val;
            });
          },
        ),
        Text(text, style: kTextStyle.copyWith(fontSize: 15)),
      ],
    );
  }

  Align buildSendCodeButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: RectangularRoundedButton(
        buttonName: 'Send code',
        fontSize: 13,
        padding: const EdgeInsets.symmetric(vertical: 2),
        onPressed: phoneNoController.text.trim().length != 10
            ? null
            : sendCodeToNumber,
      ),
    );
  }

  IntlPhoneField buildPhoneNumberField() {
    return IntlPhoneField(
      readOnly: phoneNumberVerified,
      enabled: !phoneNumberVerified,
      controller: phoneNoController,
      flagsButtonPadding: const EdgeInsets.all(10),
      decoration: kTextFieldDecoration.copyWith(
          suffixIcon: phoneNumberVerified
              ? const Icon(Icons.check, color: Colors.green)
              : null),
      initialCountryCode: 'PK',
      onCountryChanged: (country) {
        countryCode = "+${country.dialCode}";
      },
    );
  }

  Widget buildTextFormField(String hint, TextEditingController controller,
      IconData? icon, String errorText,
      {TextInputType? keyboard}) {
    return Container(
      // ignore: prefer_const_constructors
      margin: EdgeInsets.all(5),
      child: TextFormField(
        style: kInputStyle,
        controller: controller,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return errorText;
          }
          return null;
        },
        decoration: kTextFieldDecoration.copyWith(
          prefixIcon: icon == null
              ? null
              : IconTheme(
                  data: const IconThemeData(color: Colors.black54),
                  child: Icon(icon)),
          hintText: hint,
          hintStyle: kTextStyle,
          errorStyle: kTextStyle.copyWith(color: Colors.red),
        ),
        keyboardType: keyboard,
      ),
    );
  }

  void sendCodeToNumber() async {
    setState(() {
      isVerifyingPhoneNumber = true;
    });
    final overallContext = context;
    final pincodeController = TextEditingController();
    final phoneNumber = countryCode + phoneNoController.text;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (userCredential) {
        print("verification auto completed");
      },
      verificationFailed: (e) {
        showMyDialog(context, e.code, e.message ?? 'Error!');
      },
      codeSent: (verId, codeSent) async {
        showMyBanner(context, 'pin code sent successfully.');

        await showDialog(
          context: context,
          builder: (context) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.26,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter pin code sent to ${countryCode + phoneNoController.text}',
                    style: kInputStyle.copyWith(fontSize: 20, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: PinCodeTextField(
                          autofocus: true,
                          controller: pincodeController,
                          maxLength: 6,
                          pinTextStyle: kInputStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  RectangularRoundedButton(
                    buttonName: 'Submit',
                    onPressed: () async {
                      if (pincodeController.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.currentUser!
                              .linkWithCredential(
                            PhoneAuthProvider.credential(
                              verificationId: verId,
                              smsCode: pincodeController.text.trim(),
                            ),
                          );
                          showMyBanner(
                              overallContext, 'Verification successful.');
                          setState(() {
                            phoneNumberVerified = true;
                          });
                          Future.delayed(const Duration(milliseconds: 10))
                              .then((value) => Navigator.pop(context));
                        } on FirebaseAuthException catch (e) {
                          print('Exception : ${e.code}');
                          showMyBanner(overallContext, 'Error: ${e.code}');
                        } catch (e) {
                          print(
                              'Exception other than firebase auth in otp: $e');
                          showMyBanner(overallContext, 'Verification failed.');
                        }
                      }
                      setState(() {
                        isVerifyingPhoneNumber = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print("Timout: ");
      },
    );
    if (isVerifyingPhoneNumber) {
      setState(() {
        isVerifyingPhoneNumber = false;
      });
    }
  }

  String capitalizeMenuItem(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}
