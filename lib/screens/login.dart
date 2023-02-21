import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dresssew/main.dart';
import 'package:dresssew/screens/tailor_registration.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_dialog.dart';
import 'package:dresssew/utilities/rectangular_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import 'customer_registration.dart';
import 'forgot_password.dart';
import 'home.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  static const String isLoggedInText = "isLoggedIn";
  static const String id = '/login';
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  bool rememberMe = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  clearText() {
    emailController.clear();
    passwordController.clear();
    setState(() {});
  }

  bool isLoading = false;
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
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01),
                child: SingleChildScrollView(
                  child: AutofillGroup(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.2),
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
                            height: size.height * 0.1,
                          ),
                          TextFormField(
                            autofillHints: const [AutofillHints.email],
                            style: kInputStyle,
                            controller: emailController,
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
                                    ? 'ایک درست ای میل درج کریں'
                                    : "Enter a valid email address";
                              }
                              return null;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              prefixIcon: const IconTheme(
                                  data: IconThemeData(color: Colors.black54),
                                  child: Icon(Icons.email)),
                              hintText: isUrduActivated ? 'ای میل' : 'Email',
                              hintStyle: kTextStyle,
                              errorStyle:
                                  kTextStyle.copyWith(color: Colors.redAccent),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            autofillHints: const [AutofillHints.password],
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
                              hintText:
                                  isUrduActivated ? 'پاس ورڈ' : "Password",
                              hintStyle: kTextStyle,
                              errorStyle:
                                  kTextStyle.copyWith(color: Colors.redAccent),
                            ),
                            obscureText: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                clearText();

                                Navigator.pushNamed(context, ForgotPassword.id);
                              },
                              child: Text(
                                'Forgot password?',
                                style: kTextStyle.copyWith(color: Colors.blue),
                              ).tr(),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          RectangularRoundedButton(
                            buttonName: 'Login',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final response = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: password);

                                  await showMyDialog(
                                      context, 'Info', 'Login Successful.',
                                      disposeAfterMillis: 300, isError: false);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool(Login.isLoggedInText, true);
                                  print("Login Successful");
                                  print(response.user);
                                  final appUserData = await FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .where('email', isEqualTo: email.trim())
                                      .limit(1)
                                      .get();
                                  final appUser = AppUser.fromJson(
                                      appUserData.docs.first.data());
                                  print("Customer loaded: ${appUser.toJson()}");
                                  //if is not registered as customer or tailor but just has created account
                                  if (!appUser.isRegistered) {
                                    //if not registered as tailor but creaed account as  tialor
                                    if (appUser.isTailor) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorRegistration(
                                                  userData: appUser),
                                        ),
                                      );
                                    }
                                    //if not registered as customer but created account as customer
                                    else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerRegistration(
                                                  userData: appUser),
                                        ),
                                      );
                                    }
                                  }
                                  //if already registered.
                                  else {
                                    Navigator.pushReplacementNamed(
                                        context, Home.id);
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == "user-not-found") {
                                    showMyDialog(context, 'Login Error!',
                                        'User Not Registered.',
                                        disposeAfterMillis: 1000);
                                  } else if (e.code == "wrong-password") {
                                    showMyDialog(context, 'Login Error!',
                                        'Incorrect password.');
                                  } else if (e.code ==
                                      "network-request-failed") {
                                    showMyDialog(context, 'Login Error!',
                                        'No Internet Connection',
                                        disposeAfterMillis: 700);
                                  } else if (e.code == "invalid-email") {
                                    showMyDialog(context, 'Error!',
                                        'Invalid email entered.',
                                        disposeAfterMillis: 700);
                                  }
                                  print(e.code);
                                }
                                // Navigator.pushNamed(context, HomeScreen.id);
                              } else {
                                debugPrint("Validation failed!");
                              }
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New here?',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.w500),
                              ).tr(),
                              TextButton(
                                onPressed: () async {
                                  clearText();
                                  final tailorRegistered =
                                      await Navigator.pushNamed(
                                          context, SignUp.id);
                                  if (tailorRegistered != null &&
                                      tailorRegistered == 1) {
                                    // ignore: use_build_context_synchronously
                                    showMyBanner(context,
                                        'Tailor registered successfully.');
                                  }
                                },
                                child: Text(
                                  'Create an Account',
                                  style: kTextStyle.copyWith(
                                      color: Colors.blueAccent),
                                ).tr(),
                              )
                            ],
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
                      setState(() {});
                    }),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
