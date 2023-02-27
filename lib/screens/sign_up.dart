import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dresssew/main.dart';
import 'package:dresssew/models/app_user.dart';
import 'package:dresssew/screens/customer_registration.dart';
import 'package:dresssew/screens/tailor_registration.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';

import '../utilities/custom_widgets/rectangular_button.dart';

class SignUp extends StatefulWidget {
  static const String id = '/signUp';
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  bool iAmTailor = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPassController.dispose();
  }

  clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPassController.clear();
    iAmTailor = false;
    setState(() {});
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
      isLoading: isLoading,
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: [
            Padding(
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
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'DressSew',
                          style: kTitleStyle.copyWith(color: Colors.blue),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'your dress on time.',
                            style: kTextStyle.copyWith(color: Colors.blue),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.07,
                        ),
                        TextFormField(
                          controller: nameController,
                          style: kInputStyle,
                          onChanged: (value) {
                            name = value;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return isUrduActivated
                                  ? 'اپنا نام درج کریں'
                                  : "Enter your name";
                            }

                            return null;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            prefixIcon: const IconTheme(
                                data: IconThemeData(color: Colors.black54),
                                child: Icon(Icons.person)),
                            hintText: isUrduActivated ? "نام" : 'Name',
                            errorStyle:
                                kTextStyle.copyWith(color: Colors.redAccent),
                            hintStyle: kTextStyle,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          autofillHints: const [AutofillHints.email],
                          controller: emailController,
                          style: kInputStyle,
                          onChanged: (value) {
                            email = value.trim();
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return isUrduActivated
                                  ? 'اپنا ای میل درج کریں'
                                  : "Enter your email";
                            }
                            if (!EmailValidator.validate(val.trim())) {
                              return isUrduActivated
                                  ? 'ایک درست ای میل ایڈریس درج کریں'
                                  : "Enter a valid email address";
                            }
                            return null;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            prefixIcon: const IconTheme(
                                data: IconThemeData(color: Colors.black54),
                                child: Icon(Icons.email)),
                            hintText:
                                isUrduActivated ? 'ای میل' : 'Email address',
                            errorStyle:
                                kTextStyle.copyWith(color: Colors.redAccent),
                            hintStyle: kTextStyle,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          autofillHints: const [AutofillHints.newPassword],
                          controller: passwordController,
                          style: kInputStyle,
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return isUrduActivated
                                  ? 'اپنا پاس ورڈ درج کریں'
                                  : "Enter your password";
                            }
                            if (val.length < 6) {
                              return isUrduActivated
                                  ? 'پاس ورڈ کی لمبائی 6 سے کم نہیں ہوسکتی'
                                  : "password length can't be less than 6";
                            }
                            return null;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            prefixIcon: const IconTheme(
                                data: IconThemeData(color: Colors.black54),
                                child: Icon(CupertinoIcons.lock_fill)),
                            hintText: isUrduActivated ? 'پاس ورڈ' : "Password",
                            errorStyle:
                                kTextStyle.copyWith(color: Colors.redAccent),
                            hintStyle: kTextStyle,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          autofillHints: const [AutofillHints.newPassword],
                          controller: confirmPassController,
                          style: kInputStyle,
                          onChanged: (value) {
                            setState(() {});
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return isUrduActivated
                                  ? 'تصدیقی پاس ورڈ درج کریں'
                                  : "Enter confirm password";
                            }
                            if (val.length < 6) {
                              return isUrduActivated
                                  ? 'پاس ورڈ کی لمبائی 6 سے کم نہیں ہوسکتی'
                                  : "password length can't be less than 6";
                            }
                            if (val != password) {
                              return isUrduActivated
                                  ? 'پاس ورڈ اور تصدیق پاس ورڈ میچ نہیں کرتے'
                                  : "password & confirm password do not match";
                            }
                            return null;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            prefixIcon: const IconTheme(
                                data: IconThemeData(color: Colors.black54),
                                child: Icon(CupertinoIcons.lock_fill)),
                            hintText: isUrduActivated
                                ? 'پاس ورڈ کی تصدیق کریں'
                                : 'Confirm Password',
                            errorStyle: kTextStyle.copyWith(
                                color: Colors.redAccent, fontSize: 11),
                            hintStyle: kTextStyle,
                          ),
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'I am a tailor',
                                style: kTextStyle.copyWith(fontSize: 18),
                              ).tr(),
                              Checkbox(
                                value: iAmTailor,
                                onChanged: (val) {
                                  setState(() {
                                    iAmTailor = val ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        RectangularRoundedButton(
                          buttonName: 'Sign Up',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final userData = AppUser(
                                  name: name,
                                  email: email,
                                  isTailor: iAmTailor,
                                  dateJoined: DateTime.now().toIso8601String(),
                                );
                                final userCredentials = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);
                                if (userCredentials.user != null) {
                                  //no need to update name in authenticaion fields
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .add(userData.toJson())
                                      .then((docRef) async {
                                    userData.id = docRef.id;
                                    docRef.update(userData.toJson()).then(
                                        (value) => print(
                                            'user id updated in firebase.'));
                                  });
                                  print('app user DATA inserted.');
                                }
                                await showMyDialog(context, 'Info.',
                                    "Account created successfully",
                                    isError: false, disposeAfterMillis: 1000);
                                Location location = new Location();

                                bool _serviceEnabled;
                                PermissionStatus _permissionGranted;
                                LocationData _locationData;

                                _serviceEnabled =
                                    await location.serviceEnabled();
                                if (!_serviceEnabled) {
                                  _serviceEnabled =
                                      await location.requestService();
                                  if (!_serviceEnabled) {
                                    return;
                                  }
                                }

                                _permissionGranted =
                                    await location.hasPermission();
                                if (_permissionGranted ==
                                    PermissionStatus.denied) {
                                  _permissionGranted =
                                      await location.requestPermission();
                                  if (_permissionGranted !=
                                      PermissionStatus.granted) {
                                    return;
                                  }
                                }

                                _locationData = await location.getLocation();
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password)
                                    .then((value) {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                  print("Going to register");
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => userData.isTailor
                                          ? TailorRegistration(
                                              userData: userData,
                                              fromScreen: SignUp.id,
                                            )
                                          : CustomerRegistration(
                                              fromScreen: SignUp.id,
                                              userData: userData,
                                            ),
                                    ),
                                  );
                                });

                                clearFields();
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "email-already-in-use") {
                                  showMyDialog(
                                    context,
                                    'Sign up error!',
                                    'This email is already in use. Try a different one.',
                                    disposeAfterMillis: 2500,
                                  );
                                } else if (e.code == "network-request-failed") {
                                  showMyDialog(context, 'Login Error!',
                                      'No Internet Connection',
                                      disposeAfterMillis: 700);
                                } else if (e.code == "invalid-email") {
                                  showMyDialog(
                                    context,
                                    'Error!',
                                    'Invalid email entered.',
                                    disposeAfterMillis: 700,
                                  );
                                }
                                print("Sign up exception: ${e.code}");
                              } catch (e) {
                                print("Exception while sign up: $e");
                              }
                            }
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Divider(
                                height: 1,
                                color: Colors.black54,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('Or', style: kTextStyle).tr(),
                            ),
                            Flexible(
                              child: Divider(
                                height: 1,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //sign in with google
                        Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          //margin: EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: () async {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final userCredentials = await FirebaseAuth
                                    .instance
                                    .signInWithProvider(GoogleAuthProvider());
                                if (userCredentials.user != null) {
                                  final userData = AppUser(
                                    name: userCredentials.user!.displayName ??
                                        userCredentials.user!.email!.substring(
                                            0,
                                            userCredentials.user!.email!
                                                .indexOf("@")),
                                    email: userCredentials.user!.email!,
                                    isTailor: false,
                                    dateJoined:
                                        DateTime.now().toIso8601String(),
                                  );
                                  //no need to update name in authenticaion fields
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .add(userData.toJson())
                                      .then((docRef) async {
                                    userData.id = docRef.id;
                                    docRef.update(userData.toJson()).then(
                                        (value) => print(
                                            'user id updated in firebase.'));
                                  });
                                  await showMyDialog(context, 'Info.',
                                      "Account created successfully",
                                      isError: false);
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                  print('app user DATA inserted.');
                                  print(
                                      "Going to register as customer frrom google sign in");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerRegistration(
                                        fromScreen: SignUp.id,
                                        userData: userData,
                                      ),
                                    ),
                                  );
                                  clearFields();
                                } else {
                                  showMyBanner(
                                      context, "account creation failed.");
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "email-already-in-use") {
                                  showMyDialog(
                                    context,
                                    'Sign up error!',
                                    'This email is already in use. Try a different one.',
                                    disposeAfterMillis: 2500,
                                  );
                                }
                                print("Sign up exception: ${e.code}");
                              } catch (e) {
                                print('Execption: $e');
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      FontAwesomeIcons.google,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Continue with Google',
                                      style: kTextStyle.copyWith(fontSize: 18),
                                    ).tr(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
                alignment:
                    isUrduActivated ? Alignment.topLeft : Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: buildTranslateButton(context, onTranslated: () {
                    if (mounted) setState(() {});
                  }),
                )),
          ]),
        ),
      ),
    );
  }
}
