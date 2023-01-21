import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_dialog.dart';
import 'package:dresssew/utilities/rectangular_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'forgot_password.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
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
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.01),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width * 0.2),
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
                      style: kInputStyle,
                      controller: emailController,
                      onChanged: (value) {
                        email = value.trim() ?? '';
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter your email";
                        }
                        if (!EmailValidator.validate(val.trim())) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: const IconTheme(
                            data: IconThemeData(color: Colors.black54),
                            child: Icon(Icons.email)),
                        hintText: 'Username or email',
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
                      controller: passwordController,
                      style: kInputStyle,
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter your password";
                        }
                        if (val.length < 6) {
                          return "password length can't be less than 6";
                        }
                        return null;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: const IconTheme(
                            data: IconThemeData(color: Colors.black54),
                            child: Icon(CupertinoIcons.lock_fill)),
                        hintText: 'Password',
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
                        ),
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
                            await prefs.setBool('isLoggedIn', true);
                            print("Login Successful");
                            print(response.user);
                            await Navigator.pushReplacementNamed(
                                context, Home.ID);
                            showMyDialog(context, 'Info.', 'Logout successful',
                                isError: false);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "user-not-found") {
                              showMyDialog(context, 'Login Error!',
                                  'User Not Registered.',
                                  disposeAfterMillis: 1000);
                            } else if (e.code == "wrong-password") {
                              showMyDialog(context, 'Login Error!',
                                  'Incorrect password.');
                            } else if (e.code == "network-request-failed") {
                              showMyDialog(context, 'Login Error!',
                                  'No Interet Connection',
                                  disposeAfterMillis: 700);
                            } else if (e.code == "invalid-email") {
                              showMyDialog(
                                  context, 'Error!', 'Invalid email entered.',
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
                          style:
                              kTextStyle.copyWith(fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            clearText();
                            Navigator.pushNamed(context, SignUp.id);
                          },
                          child: Text(
                            'Create an Account',
                            style:
                                kTextStyle.copyWith(color: Colors.blueAccent),
                          ),
                        )
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
}
