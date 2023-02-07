import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dresssew/models/app_user.dart';
import 'package:dresssew/models/customer.dart';
import 'package:dresssew/models/shop.dart';
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

class TailorRegistration extends StatefulWidget {
  final AppUser userData;
  //from which screen user has navigated to this screen if its signup then pop back to login
  //or if its login then push to home
  final String fromScreen;

  const TailorRegistration(
      {super.key, required this.userData, this.fromScreen = Login.id});
  @override
  _TailorRegitrationState createState() => _TailorRegitrationState();
}

class _TailorRegitrationState extends State<TailorRegistration> {
  Customer? data;
  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final shopFormKey = GlobalKey<FormState>();
  final phoneNoController = TextEditingController();
  String countryCode = '+92';
  final websiteUrlController = TextEditingController();
  final shopNameController = TextEditingController();
  final shopAddressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  Gender? gender;
  bool isVerifyingPhoneNumber = false;
  bool isNextBtnPressed = false;
  bool phoneNumberVerified = true;
  bool isUploadingLogo = false;
  bool isUploadingShop1Image = false;
  bool isUploadingShop2Image = false;
  bool isUploadingProfileImage = false;
  bool isRegisterBtnPressed = false;
  String? profileImageUrl;
  String? logoImageUrl;
  List<String?> shopImagesList = [];
  String? initialImageUrl;
  StitchingType? stitchingType;
  List<String> selectedExpertise = [];
  List<Rates> expertiseRatesList = [];
  List<String> unSelectedExpertise = [];

  final experienceController = TextEditingController();
  List<TextEditingController> ratesFieldsController = [];
  bool customizesDresses = false;
  Tailor? tailor;

  bool isSavingDataInFirebase = false;

  final storage = FirebaseStorage.instance.ref();

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
    websiteUrlController.dispose();
    experienceController.dispose();
    shopAddressController.dispose();
    shopNameController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    ratesFieldsController.forEach((element) {
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
            'Register as Tailor',
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
                    if (phoneNumberVerified && tailor == null)
                      buildPersonalInfoColumn(size, context),
                    if (phoneNumberVerified && tailor != null)
                      buildShopInfoColumn(size),
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

  Widget buildShopInfoColumn(Size size) {
    return Form(
      key: shopFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: size.height * 0.01),
          Text(
            'Shop Info.',
            style: kTitleStyle.copyWith(fontSize: 30),
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
          buildShopLogoContainer(size),
          buildShopImagesContainer(size),
          SizedBox(height: size.height * 0.02),
          buildRegisterButton(),
        ],
      ),
    );
  }

  RectangularRoundedButton buildRegisterButton() {
    return RectangularRoundedButton(
      buttonName: 'Register',
      onPressed: () async {
        bool taskSuccessful = false;
        setState(() {
          isRegisterBtnPressed = true;
        });
        if (formKey.currentState!.validate() &&
            shopFormKey.currentState!.validate() &&
            shopImagesList.length == 2 &&
            logoImageUrl != null) {
          setState(() {
            isRegisterBtnPressed = true;
            isSavingDataInFirebase = true;
          });
          //62 seconds as timeout
          Future.delayed(Duration(seconds: 60, milliseconds: 2000))
              .then((value) {
            if (mounted) {
              setState(() => isSavingDataInFirebase = false);
              if (!taskSuccessful) showMyBanner(context, 'Timed out.');
            }
          });
          Shop shop = Shop(
            websiteUrl: websiteUrlController.text.trim(),
            address: shopAddressController.text.trim(),
            city: capitalizeText(cityController.text.trim()),
            name: capitalizeText(shopNameController.text.trim()),
            postalCode: int.parse(postalCodeController.text.trim()),
            shopImage1Url: shopImagesList[0],
            shopImage2Url: shopImagesList[1],
            logoImageUrl: logoImageUrl!,
          );
          tailor!.shop = shop;
          try {
            await FirebaseFirestore.instance
                .collection('tailors')
                .add(tailor!.toJson())
                .then((doc) {
              tailor!.id = doc.id;
              FirebaseAuth.instance.currentUser!
                  .updateDisplayName(widget.userData.name)
                  .then((value) => print('Display name updated.'));
              doc.update(tailor!.toJson()).then((value) {
                widget.userData.isRegistered = true;
                if (mounted) {
                  setState(() {
                    taskSuccessful = true;
                  });
                }
                tailor!.id = doc.id;
                doc.update(tailor!.toJson()).then((value) {
                  widget.userData.isRegistered = true;
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userData.id)
                      .update(widget.userData.toJson());
                  print("Customer Data updated");
                }).then((value) {
                  if (taskSuccessful) {
                    if (widget.fromScreen == Login.id) {
                      Navigator.pushReplacementNamed(context, Home.id,
                          arguments: {'tailorRegisteredRecently': true});
                    } else {
                      //1 inidicates it was a tailor registration & was successful
                      FirebaseAuth.instance.signOut().then((value) =>
                          SharedPreferences.getInstance().then((pref) =>
                              pref.setBool(Login.isLoggedInText, false)));
                      showMyDialog(context, 'Success',
                              'Tailor registration successful.',
                              isError: false, disposeAfterMillis: 1200)
                          .then((value) => Navigator.pop(context, 1));
                    }
                  }
                });
              });
            });
          } catch (e) {
            print('Exception while saving: $e');
          }
          onClearButtonPressed();
          print('Tailor data: ${tailor!.toJson().toString()}');
          setState(() {
            isRegisterBtnPressed = false;
            isSavingDataInFirebase = false;
          });
        }
      },
    );
  }

  Padding buildShopImagesContainer(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Shop images',
                style: kInputStyle.copyWith(
                  fontSize: 18,
                ),
              ),
              if (shopImagesList.isNotEmpty)
                Text(
                  "(${shopImagesList.length}/2)",
                  style: kInputStyle.copyWith(
                    fontSize: 15,
                  ),
                ),
              if (shopImagesList.length < 2 && isRegisterBtnPressed)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('(Add at least 2 images)',
                        style: kTextStyle.copyWith(
                            color: Colors.red, fontSize: 12)),
                  ),
                )
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //shop image 1 container(while he hasn't uploaded any image)
              shopImagesList.isNotEmpty
                  ? buildImageItem(size, shopImagesList[0], onRemove: () {
                      shopImagesList.removeWhere(
                          (element) => element == shopImagesList[0]);
                      setState(() {});
                    })
                  : buildUploadShopImageContainer(size, 1),
              shopImagesList.length > 1
                  ? buildImageItem(size, shopImagesList[1], onRemove: () {
                      shopImagesList.removeWhere(
                          (element) => element == shopImagesList[1]);
                      setState(() {});
                    })
                  : buildUploadShopImageContainer(size, 2),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildShopLogoContainer(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: size.height * 0.22,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Shop Logo',
                  style: kInputStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                if (logoImageUrl == null && isRegisterBtnPressed)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('(Add your shop\'s logo)',
                          style: kTextStyle.copyWith(
                              color: Colors.red, fontSize: 12)),
                    ),
                  )
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Expanded(
              child: logoImageUrl == null
                  ? buildUploadImageContainer(
                      size,
                      isUploadingLogo,
                      onPressed: () async {
                        final file =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            isUploadingLogo = true;
                          });

                          final storageRef = storage
                              .child('${widget.userData.email}/logoUrl.png');
                          final uploadTask =
                              await storageRef.putFile(File(file.path));
                          final downloadUrl =
                              await uploadTask.ref.getDownloadURL();
                          setState(() {
                            logoImageUrl = downloadUrl;
                            isUploadingLogo = false;
                          });
                        }
                      },
                    )
                  : buildImageItem(size, logoImageUrl, onRemove: () {
                      logoImageUrl = null;
                      setState(() {});
                    }),
            ),
          ],
        ),
      ),
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

  Column buildPersonalInfoColumn(Size size, BuildContext context) {
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
                  setState(() {
                    isUploadingProfileImage = true;
                  });
                  Future.delayed(
                    const Duration(seconds: 30),
                  ).then((value) => setState(() {
                        isUploadingProfileImage = false;
                        if (!taskSuccessful)
                          showMyBanner(context, 'Timed out.');
                      }));
                  final storageRef = storage
                      .child('${widget.userData.email}/profileImage.png');
                  final uploadTask = await storageRef.putFile(File(file.path));
                  final downloadUrl = await uploadTask.ref.getDownloadURL();
                  setState(() {
                    profileImageUrl = downloadUrl;
                    taskSuccessful = true;
                    isUploadingProfileImage = false;
                  });
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
          buildExpertiseRatesTextFields(size),
          // buildExpertiseWrappedList(size),
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
              tailorName: capitalizeText(widget.userData.name),
              email: widget.userData.email,
              userDocId: widget.userData.id,
              gender: gender!,
              stitchingType: stitchingType!,
              expertise: selectedExpertise,
              phoneNumber: countryCode + phoneNoController.text,
              profileImageUrl: profileImageUrl,
              customizes: customizesDresses,
              customerDocId: widget.userData.id,
              rates: expertiseRatesList,
              experience: int.parse(experienceController.text.trim()),
            );
            print("Rates: $expertiseRatesList");
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
                  child: Text(capitalizeText(StitchingType.values[index].name)),
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
                  selectedExpertise.clear();
                  ratesFieldsController.clear();
                  expertiseRatesList.clear();
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

  String capitalizeText(String text) {
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
                              expertiseRatesList.removeWhere((e) =>
                                  e.category == selectedExpertise[index]);
                              ratesFieldsController.removeAt(index);
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
                              ratesFieldsController
                                  .add(TextEditingController());
                              expertiseRatesList.add(Rates(
                                  category: unSelectedExpertise[index],
                                  price: 0));
                              // expertiseRatesList.sort((n1, n2) {
                              //   return n1.category.compareTo(n2.category);
                              // });
                              // selectedExpertise.sort();
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

  buildUploadImageContainer(size, bool isUploading,
          {required VoidCallback onPressed, String text = 'Upload'}) =>
      Container(
          width: size.width * 0.4,
          height: size.width * 0.38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, offset: Offset(1, 1), color: Colors.grey),
            ],
          ),
          child: isUploading
              ? Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LoadingOverlay(
                        isLoading: true,
                        progressIndicator: buildLoadingSpinner(),
                        child: Text('')),
                  ),
                )
              : IconButton(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.upload,
                          color: Colors.grey.shade600),
                      Text(text, style: kTextStyle.copyWith(fontSize: 18))
                    ],
                  ),
                  onPressed: onPressed,
                ));

  void onClearButtonPressed() {
    setState(() {
      isNextBtnPressed = false;
      stitchingType = null;
      gender = null;
      profileImageUrl = initialImageUrl;
      websiteUrlController.clear();
      shopNameController.clear();
      experienceController.clear();
      postalCodeController.clear();
      cityController.clear();
      shopAddressController.clear();
      customizesDresses = false;
      selectedExpertise.clear();
      unSelectedExpertise.clear();
      logoImageUrl = null;
      shopImagesList.clear();
      formKey.currentState?.reset();
    });
  }

  buildUploadShopImageContainer(size, int imageNo) => buildUploadImageContainer(
        size,
        imageNo == 1 ? isUploadingShop1Image : isUploadingShop2Image,
        onPressed: () async {
          if (shopImagesList.length < 2) {
            final file = await picker.pickImage(source: ImageSource.gallery);
            if (file != null) {
              setState(() {
                if (imageNo == 1) {
                  isUploadingShop1Image = true;
                } else {
                  isUploadingShop2Image = true;
                }
              });

              final storageRef = storage
                  .child('${widget.userData.email}/shopImage$imageNo.png');
              final uploadTask = await storageRef.putFile(File(file.path));
              final downloadUrl = await uploadTask.ref.getDownloadURL();
              setState(() {
                shopImagesList.add(downloadUrl);
                if (imageNo == 1) {
                  isUploadingShop1Image = false;
                } else {
                  isUploadingShop2Image = false;
                }
              });
            }
          }
        },
      );

  Widget buildExpertiseRatesTextFields(Size size) {
    return Column(
        children: List.generate(
      selectedExpertise.length,
      (index) {
        return ItemRateInputTile(
            title: selectedExpertise[index],
            controller: ratesFieldsController[index],
            onChanged: (val) {
              setState(() {
                if (val != null && val.isNotEmpty) {
                  expertiseRatesList[index].price = int.parse(val);
                }
              });
            });
      },
    ));
  }
}

// TextButton buildUploadImageButton(VoidCallback onPressed,
//     [String text = 'Upload']) {
//   return TextButton(
//     style: TextButton.styleFrom(
//       padding: EdgeInsets.zero,
//     ),
//     onPressed: onPressed,
//     child: Text(
//       text,
//       style: kTextStyle.copyWith(
//           fontSize: 18,
//           color: Colors.blue,
//           decoration: TextDecoration.underline),
//     ),
//   );
// }
