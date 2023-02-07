import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dresssew/models/app_user.dart';
import 'package:dresssew/models/customer.dart';
import 'package:dresssew/models/measurement.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/item_rate_input_tile.dart';
import 'package:dresssew/utilities/my_dialog.dart';
import 'package:dresssew/utilities/rectangular_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tailor.dart';
import 'home.dart';
import 'login.dart';

class CustomerRegistration extends StatefulWidget {
  final AppUser userData;
  //from which screen user has navigated to this screen if its signup then pop back to login
  //or if its login then push to home
  final String fromScreen;

  const CustomerRegistration(
      {super.key, required this.userData, this.fromScreen = Login.id});
  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  Customer? customer;
  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final phoneNoController = TextEditingController();
  String countryCode = '+92';
  final addressController = TextEditingController();
  Gender? gender;
  bool isVerifyingPhoneNumber = false;
  bool isNextBtnPressed = false;
  bool phoneNumberVerified = true;
  bool isUploadingProfileImage = false;
  bool isRegisterBtnPressed = false;
  String? profileImageUrl;
  String? initialImageUrl;

  bool isSavingDataInFirebase = false;

  final storage = FirebaseStorage.instance.ref();

  List<Measurement> measurements = List.generate(
      Measurements.values.length,
      (index) => Measurement(
          title: capitalizeText(
              spaceSeparatedNameOfMeasurement(Measurements.values[index].name)),
          measure: 0));
  final measurementsControllers = List.generate(
      Measurements.values.length, (index) => TextEditingController(text: '0'));

  @override
  void initState() {
    super.initState();
    initialImageUrl = 'assets/user.png';
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
    addressController.dispose();
    measurementsControllers.forEach((element) {
      element.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingOverlay(
      progressIndicator: buildLoadingSpinner(),
      isLoading: isVerifyingPhoneNumber || isSavingDataInFirebase,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register as Customer',
            style: kInputStyle,
          ),
          centerTitle: true,
          actions: [if (phoneNumberVerified) buildClearFormButton(context)],
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
                    if (phoneNumberVerified && customer == null)
                      buildPersonalInfoColumn(context),
                    if (phoneNumberVerified && customer != null)
                      buildAddMeasurementsPage(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SpinKitDoubleBounce buildLoadingSpinner() {
    return SpinKitDoubleBounce(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.blue : Colors.white,
          ),
        );
      },
    );
  }

  RectangularRoundedButton buildRegisterButton() {
    return RectangularRoundedButton(
      buttonName: 'Register',
      onPressed: () async {
        bool taskSuccessful = false;
        if (mounted) {
          setState(() {
            isRegisterBtnPressed = true;
          });
        }
        if (formKey.currentState!.validate()) {
          if (mounted) {
            setState(() {
              isRegisterBtnPressed = true;
              isSavingDataInFirebase = true;
            });
          }
          //62 seconds as timeout
          Future.delayed(Duration(seconds: 60, milliseconds: 2000))
              .then((value) {
            if (mounted) {
              setState(() => isSavingDataInFirebase = false);
              if (!taskSuccessful) showMyBanner(context, 'Timed out.');
            }
          });
          customer!.measurements = measurements;
          print('customer: $customer');
          try {
            //inserting customer data
            await FirebaseFirestore.instance
                .collection('customers')
                .add(customer!.toJson())
                .then((doc) {
              customer!.id = doc.id;
              //update display user name
              FirebaseAuth.instance.currentUser!
                  .updateDisplayName(widget.userData.name)
                  .then((value) => print('Display name updated.'));
              //updating customer id field
              doc.update(customer!.toJson()).then((value) {
                widget.userData.isRegistered = true;
                if (mounted) {
                  setState(() {
                    taskSuccessful = true;
                  });
                }
                //updating corresponding app user record in users collection
                doc.update(customer!.toJson()).then((value) {
                  widget.userData.isRegistered = true;
                  widget.userData.customerOrTailorId = doc.id;
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userData.id)
                      .update(widget.userData.toJson());
                  print("App user Data updated");
                }).then((value) {
                  if (taskSuccessful) {
                    if (widget.fromScreen == Login.id) {
                      Navigator.pushReplacementNamed(context, Home.id);
                    } else {
                      //1 inidicates it was a customer registration & was successful
                      if (mounted) {
                        setState(() {
                          isRegisterBtnPressed = false;
                          isSavingDataInFirebase = false;
                        });
                      }
                      FirebaseAuth.instance
                          .signOut()
                          .then((value) => SharedPreferences.getInstance().then(
                              (pref) =>
                                  pref.setBool(Login.isLoggedInText, false)))
                          .then((value) => showMyDialog(context, 'Success',
                                  'Customer registration successful.',
                                  isError: false, disposeAfterMillis: 1200)
                              .then((value) => Navigator.pop(context, 1)));
                    }
                  }
                });
              });
            });
          } catch (e) {
            print('Exception while saving in customer registration: $e');
          }
          onClearButtonPressed();
          print('Customer data: ${customer!.toJson().toString()}');
        }
      },
    );
  }

  Widget buildImageItem(size, String? url, {required VoidCallback onRemove}) =>
      Container(
          width: size.width * 0.4,
          height: size.width * 0.38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: (url == null
                  ? const AssetImage('assets/user.png')
                  : NetworkImage(url) as ImageProvider),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: onRemove,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.clear,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ),
          ));

  TextButton buildClearFormButton(BuildContext context) {
    return TextButton(
      onPressed: () => {
        onClearButtonPressed(),
        showMyBanner(context, "Form cleared successfully.")
      },
      child: Text(
        'Clear',
        style: kTextStyle.copyWith(color: Colors.white),
      ),
    );
  }

  Column buildPersonalInfoColumn(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: size.height * 0.01),
        Text(
          'Personal Info.',
          style: kTitleStyle.copyWith(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.width * 0.01),
        Align(alignment: Alignment.center, child: buildProfilePicture(size)),
        buildSelectProfileImageButton(size),
        SizedBox(height: size.height * 0.01),
        buildGenderRow(),
        SizedBox(height: size.height * 0.01),
        buildTextFormField(
          'address',
          addressController,
          FontAwesomeIcons.locationDot,
          'enter shop address',
          keyboard: TextInputType.streetAddress,
        ),
        SizedBox(height: size.height * 0.015),
        buildNextButton(),
      ],
    );
  }

  Widget buildProfilePicture(Size size) {
    return CircleAvatar(
      radius: size.width * 0.25,
      backgroundColor: Colors.blue,
      child: Center(
        child: CircleAvatar(
          radius: size.width * 0.247,
          backgroundColor:
              isUploadingProfileImage ? Colors.white54 : Colors.white,
          backgroundImage:
              (profileImageUrl != null && profileImageUrl != initialImageUrl
                  ? NetworkImage(profileImageUrl!)
                  : AssetImage(initialImageUrl!) as ImageProvider),
          child: isUploadingProfileImage
              ? Center(child: buildLoadingSpinner())
              : null,
        ),
      ),
    );
  }

  Container buildSelectProfileImageButton(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.25, vertical: size.height * 0.002),
      child: RectangularRoundedButton(
        padding: EdgeInsets.zero,
        fontSize: 15,
        buttonName: 'Select',
        onPressed: isUploadingProfileImage
            ? null
            : () async {
                bool taskSuccessful = false;
                final file =
                    await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  if (mounted) {
                    setState(() {
                      isUploadingProfileImage = true;
                    });
                  }
                  Future.delayed(
                    const Duration(seconds: 30),
                  ).then((value) {
                    if (mounted)
                      setState(() {
                        isUploadingProfileImage = false;
                        if (!taskSuccessful)
                          showMyBanner(context, 'Timed out.');
                      });
                  });
                  final storageRef = storage
                      .child('${widget.userData.email}/profileImage.png');
                  final uploadTask = await storageRef.putFile(File(file.path));
                  final downloadUrl = await uploadTask.ref.getDownloadURL();
                  if (mounted) {
                    setState(() {
                      profileImageUrl = downloadUrl;
                      taskSuccessful = true;
                      isUploadingProfileImage = false;
                    });
                  }
                }
              },
      ),
    );
  }

  RectangularRoundedButton buildNextButton() {
    return RectangularRoundedButton(
      buttonName: 'Next',
      onPressed: () async {
        if (mounted) {
          setState(() {
            isNextBtnPressed = true;
            if (formKey.currentState!.validate() &&
                gender != null &&
                !isUploadingProfileImage) {
              print("Validation successful");
              customer = Customer(
                name: capitalizeText(widget.userData.name),
                email: widget.userData.email,
                gender: gender!,
                phoneNumber: countryCode + phoneNoController.text,
                profileImageUrl: profileImageUrl,
                userDocId: widget.userData.id,
                address: capitalizeText(addressController.text.trim()),
              );
              print("customer data: $customer");
              isNextBtnPressed = false;
            }
          });
        }
      },
    );
  }

  static String spaceSeparatedNameOfMeasurement(String title) {
    String str = "";
    for (int i = 0; i < title.length; i++) {
      if (title[i] == title[i].toUpperCase()) {
        str += " ${title[i].toLowerCase()}";
      } else {
        str += title[i];
      }
    }
    return str;
  }

  Container buildPhoneNumberVerificationPage(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Verify phone number',
            style: kTitleStyle.copyWith(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.05),
          buildPhoneNumberField(),
          buildSendCodeButton(),
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
            : () => {
                  setState(() {
                    isVerifyingPhoneNumber = true;
                  }),
                  sendCodeToNumber()
                },
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: LoadingOverlay(
                isLoading: isVerifyingPhoneNumber,
                progressIndicator: buildLoadingSpinner(),
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
                              showMyBanner(
                                  overallContext, 'Verification failed.');
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

  static String capitalizeText(String text) {
    text = text.trim();
    return text[0].toUpperCase() + text.substring(1);
  }

  void onClearButtonPressed() {
    setState(() {
      isNextBtnPressed = false;
      gender = null;
      profileImageUrl = initialImageUrl;
      addressController.clear();
      measurementsControllers.forEach((element) {
        element.clear();
      });
      formKey.currentState?.reset();
    });
  }

  Widget buildAddMeasurementsPage() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: size.width * 0.01,
        ),
        Text(
          'Add Measurements',
          textAlign: TextAlign.center,
          style: kTitleStyle.copyWith(fontSize: 30),
        ),
        SizedBox(
          height: size.width * 0.01,
        ),
        Text(
          'You can skip field(s) that you don\'t have measurements of, for now.',
          textAlign: TextAlign.center,
          style: kTitleStyle.copyWith(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(
          height: size.width * 0.02,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            measurements.length,
            (i) => ItemRateInputTile(
              title: capitalizeText(
                spaceSeparatedNameOfMeasurement(measurements[i].title),
              ),
              onChanged: (val) {
                if (val != null && val.isNotEmpty) {
                  measurements[i].measure = double.parse(val);
                  if (mounted) setState(() {});
                }
              },
              validateField: false,
              controller: measurementsControllers[i],
            ),
          ),
        ),
        SizedBox(height: size.width * 0.02),
        buildRegisterButton(),
      ],
    );
  }
}