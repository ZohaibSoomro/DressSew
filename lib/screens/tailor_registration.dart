import 'dart:convert';

import 'package:dresssew/main.dart';
import 'package:dresssew/models/customer.dart';
import 'package:dresssew/models/shop.dart';
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
  final shopNameController = TextEditingController();
  final shopAddressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  Gender? gender;
  bool isNextBtnPressed = false;
  Uint8List? profileImageBytes;
  Uint8List? logoImageBytes;
  List<Uint8List> shopImagesBytesList = [];
  Uint8List? initialImageBytes;
  StitchingType? stitchingType;

  List<String> selectedExpertise = [];
  List<String> unSelectedExpertise = [];

  final experienceController = TextEditingController();
  bool customizesDresses = false;
  Tailor? tailor;

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
    overallExpertise.sort();
    (rootBundle.load("assets/user.png")).then((value) => setState(() => {
          initialImageBytes = value.buffer.asUint8List(),
          profileImageBytes = initialImageBytes
        }));
    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      // data = ModalRoute.of(context)!.settings.arguments as Customer;
      // print(data?.toJson());
      data = Customer.fromJson(
        json.decode(
            '{"address": null,"is_registered":false, "name": "Zohaib Hassan", "gender":"male","orders": [], "phone_number": null, "profile_image_bytes": [], "id": "AMjpKhlvWYfXbPAYqmb6", "date_joined": "2023-01-21T18:25:34.369762", "is_tailor": true, "email": "z1@gmail.com"}'),
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
    shopAddressController.dispose();
    shopNameController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
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
          actions: [buildClearFormButton(context)],
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
                    if (!phoneNumberVerified)
                      buildPhoneNumberVerificationPage(size),
                    if (phoneNumberVerified && tailor == null)
                      buildPersonalInfoColumn(size, context),
                    if (phoneNumberVerified && tailor != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height * 0.01),
                          Text(
                            'Shop Info.',
                            style: kTitleStyle.copyWith(fontSize: 35),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.02),
                          buildTextFormField(
                            'website url(optional)',
                            websiteUrlController,
                            FontAwesomeIcons.globe,
                            null,
                            keyboard: TextInputType.url,
                          ),
                          buildTextFormField(
                            'shop name',
                            shopNameController,
                            FontAwesomeIcons.shop,
                            'enter shop name',
                            keyboard: TextInputType.name,
                          ),
                          buildTextFormField(
                            'address',
                            shopAddressController,
                            FontAwesomeIcons.locationDot,
                            'enter shop address',
                            keyboard: TextInputType.streetAddress,
                          ),
                          buildTextFormField(
                            'city',
                            cityController,
                            FontAwesomeIcons.city,
                            'enter city name',
                          ),
                          buildTextFormField(
                            'postal code',
                            postalCodeController,
                            Icons.code,
                            'enter postal code',
                            keyboard: TextInputType.number,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: size.height * 0.25,
                              child: Column(
                                children: [
                                  Text(
                                    'Shop Logo',
                                    style: kInputStyle.copyWith(fontSize: 18),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Expanded(
                                    child: Container(
                                      width: size.width * 0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: MemoryImage(logoImageBytes ??
                                              initialImageBytes!),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  RectangularRoundedButton(
                                    padding: EdgeInsets.zero,
                                    fontSize: 15,
                                    buttonName: 'Upload',
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          RectangularRoundedButton(
                            buttonName: 'Register',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                Shop shop = Shop(
                                    websiteUrl:
                                        websiteUrlController.text.trim(),
                                    address: shopAddressController.text.trim(),
                                    city: cityController.text.trim(),
                                    name: shopNameController.text.trim(),
                                    postalCode: int.parse(
                                        postalCodeController.text.trim()));
                                tailor!.shop = shop;
                                setState(() {});
                                print('Tailor data: ${tailor!.toJson()}');
                              }
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

  TextButton buildClearFormButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isNextBtnPressed = false;
          stitchingType = null;
          gender = null;
          experienceController.clear();
          profileImageBytes = initialImageBytes;
          customizesDresses = false;
          selectedExpertise.clear();
          unSelectedExpertise.clear();

          formKey.currentState?.reset();
        });
        showMyBanner(context, "Form cleared successfully.");
      },
      child: Text(
        'Clear',
        style: kTextStyle.copyWith(color: Colors.white),
      ),
    );
  }

  Column buildPersonalInfoColumn(Size size, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: size.height * 0.01),
        Text(
          'Personal Info.',
          style: kTitleStyle.copyWith(fontSize: 35),
          textAlign: TextAlign.center,
        ),
        buildProfilePicture(size),
        buildSelectImageButton(size),
        SizedBox(height: size.height * 0.01),
        buildGenderRow(),
        SizedBox(height: size.height * 0.01),
        buildStitchingTypeRow(size),
        SizedBox(height: size.height * 0.01),
        buildCustomizesDressQuestionTile(),
        SizedBox(height: size.height * 0.01),
        buildTextFormField('Experience in no of years', experienceController,
            null, "Enter experience in no of years",
            keyboard: TextInputType.number),
        SizedBox(height: size.height * 0.01),
        buildExpertiseRowAndList(context, size),
        buildNextButton(),
      ],
    );
  }

  CircleAvatar buildProfilePicture(Size size) {
    return CircleAvatar(
      radius: size.width * 0.25,
      backgroundColor: Colors.blue,
      child: CircleAvatar(
        radius: size.width * 0.247,
        backgroundColor: Colors.white,
        backgroundImage:
            profileImageBytes == null ? null : MemoryImage(profileImageBytes!),
      ),
    );
  }

  Container buildSelectImageButton(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.25, vertical: size.height * 0.002),
      child: RectangularRoundedButton(
        padding: EdgeInsets.zero,
        fontSize: 15,
        buttonName: 'Select',
        onPressed: () async {
          final file = await picker.pickImage(source: ImageSource.gallery);
          if (file != null) {
            profileImageBytes = await file.readAsBytes();
            setState(() {});
          }
        },
      ),
    );
  }

  CheckboxListTile buildCustomizesDressQuestionTile() {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.only(left: 10),
      title: Text(
        'Do you customize dresses?',
        style: kInputStyle.copyWith(fontSize: 18),
      ),
      subtitle: !isNextBtnPressed
          ? null
          : RichText(
              text: TextSpan(
                text: "You answered: ",
                style: kTextStyle,
                children: [
                  TextSpan(
                    text: customizesDresses ? 'Yes' : 'No',
                    style: kTextStyle.copyWith(
                        color: Colors.blue, fontWeight: FontWeight.w900),
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
    );
  }

  Padding buildExpertiseRowAndList(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAddExpertiseRow(context),
          SizedBox(height: size.height * 0.005),
          buildExpertiseWrappedList(size),
        ],
      ),
    );
  }

  Row buildAddExpertiseRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Expertise',
          style: kInputStyle.copyWith(
              fontSize: 18,
              color: selectedExpertise.isEmpty && isNextBtnPressed
                  ? Colors.red
                  : Colors.black),
        ),
        RectangularRoundedButton(
          buttonName: 'Add',
          fontSize: 15,
          onPressed: () {
            if (stitchingType == null) {
              showMyBanner(context, 'Please select a stitching type.');
            } else {
              onAddYourSkillsPressed();
            }
          },
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  RectangularRoundedButton buildNextButton() {
    return RectangularRoundedButton(
      buttonName: 'Next',
      onPressed: () async {
        setState(() {
          isNextBtnPressed = true;
          if (formKey.currentState!.validate() &&
              gender != null &&
              stitchingType != null &&
              selectedExpertise.isNotEmpty) {
            print("Validation successful");
            tailor = Tailor(
              tailorName: customer!.name,
              email: customer!.email,
              gender: gender!,
              stitchingType: stitchingType!,
              expertise: selectedExpertise,
              phoneNumber: countryCode + phoneNoController.text,
              profileImageBytes: profileImageBytes!.toList(),
              customizes: customizesDresses,
              experience: int.parse(experienceController.text.trim()),
            );

            isNextBtnPressed = false;
          }
        });
      },
    );
  }

  Container buildPhoneNumberVerificationPage(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Verify phone number',
            style: kTitleStyle.copyWith(fontSize: 35),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.05),
          buildPhoneNumberField(),
          buildSendCodeButton(),
        ],
      ),
    );
  }

  Widget buildExpertiseWrappedList(Size size) {
    return Wrap(
      children: List.generate(selectedExpertise.length,
          (index) => buildExpertiseItem(selectedExpertise[index])),
    );
  }

  Card buildExpertiseItem(String text) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 7.0,
        horizontal: 3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(
          color: Colors.grey,
          width: 0.3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'CenturyGothic',
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
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
                color: stitchingType == null && isNextBtnPressed
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
                  unSelectedExpertise = stitchingType == StitchingType.gents
                      ? List.from(menExpertise)
                      : stitchingType == StitchingType.ladies
                          ? List.from(ladiesExpertise)
                          : List.from(overallExpertise);
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
              color: gender == null && isNextBtnPressed
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
      IconData? icon, String? errorText,
      {TextInputType? keyboard}) {
    return Container(
      // ignore: prefer_const_constructors
      margin: EdgeInsets.all(5),
      child: TextFormField(
        style: kInputStyle,
        controller: controller,
        validator: (val) {
          if (errorText == null) return null;
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
                  child: Icon(icon, size: 18)),
          hintText: hint,
          hintStyle: kTextStyle.copyWith(fontSize: 13),
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

  void onAddYourSkillsPressed() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.07,
            vertical: MediaQuery.of(context).size.width * 0.15,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 15,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Expertise',
                    style: kInputStyle.copyWith(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      Wrap(
                        spacing: 3,
                        children: List.generate(
                          selectedExpertise.length,
                          (index) => InputChip(
                            label: Text(
                              selectedExpertise[index],
                              style:
                                  const TextStyle(fontFamily: 'CenturyGothic'),
                            ),
                            deleteIconColor: Colors.red,
                            onSelected: (isSelected) {},
                            backgroundColor: Colors.white,
                            elevation: 1,
                            onDeleted: () {
                              unSelectedExpertise.add(selectedExpertise[index]);
                              unSelectedExpertise.sort();
                              setState(() {});
                              selectedExpertise.removeAt(index);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: unSelectedExpertise.length,
                        itemBuilder: (context, index) => Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 5,
                          ),
                          elevation: 1.0,
                          child: ListTile(
                            title: Text(
                              unSelectedExpertise[index],
                              style:
                                  const TextStyle(fontFamily: 'CenturyGothic'),
                            ),
                            onTap: () {
                              selectedExpertise.add(unSelectedExpertise[index]);
                              selectedExpertise.sort();
                              unSelectedExpertise.removeAt(index);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: RectangularRoundedButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      print("Skill List: $selectedExpertise");
                    },
                    buttonName: 'Done',
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
    setState(() {});
  }
}
