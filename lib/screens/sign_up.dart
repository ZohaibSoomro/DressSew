import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_dialog.dart';
import 'package:dresssew/utilities/rectangular_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

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

  clearText() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPassController.clear();
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
                    SizedBox(height: size.height * 0.03),
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
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter your name";
                        }

                        return null;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: const IconTheme(
                            data: IconThemeData(color: Colors.black54),
                            child: Icon(Icons.person)),
                        hintText: 'Name',
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
                        hintText: 'Email address',
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
                      controller: passwordController,
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
                      controller: confirmPassController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter confirm password";
                        }
                        if (val.length < 6) {
                          return "password length can't be less than 6";
                        }
                        if (val != password) {
                          return "password & confirm password do not match";
                        }
                        return null;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: const IconTheme(
                            data: IconThemeData(color: Colors.black54),
                            child: Icon(CupertinoIcons.lock_fill)),
                        hintText: 'Confirm Password',
                        errorStyle:
                            kTextStyle.copyWith(color: Colors.redAccent),
                        hintStyle: kTextStyle,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RectangularRoundedButton(
                      buttonName: 'Sign Up',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final userCredentials = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            if (userCredentials.user != null) {
                              await userCredentials.user!
                                  .updateDisplayName(name);
                              setState(() {});
                            }
                            setState(() {
                              isLoading = false;
                            });
                            await showMyDialog(context, 'Info.',
                                "Account created successfully",
                                isError: false);
                            clearText();
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "email-already-in-use") {
                              showMyDialog(
                                context,
                                'Sign up error',
                                'This email is already in use. Try a different one.',
                                disposeAfterMillis: 2500,
                              );
                            } else if (e.code == "network-request-failed") {
                              showMyDialog(context, 'Login Error!',
                                  'No Interet Connection',
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
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Flexible(
                          child: Divider(
                            height: 1,
                            color: Colors.black54,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Or', style: kTextStyle),
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
                            await FirebaseAuth.instance
                                .signInWithProvider(GoogleAuthProvider());
                            setState(() {
                              isLoading = false;
                            });
                            await showMyDialog(context, 'Info.',
                                "Account created successfully",
                                isError: false);
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "email-already-in-use") {
                              showMyDialog(
                                context,
                                'Sign up error',
                                'This email is already in use. Try a different one.',
                                disposeAfterMillis: 2500,
                              );
                            }
                            print("Sign up exception: ${e.code}");
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
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  'Continue with Google',
                                  style: kTextStyle.copyWith(fontSize: 18),
                                ),
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
      ),
    );
  }
}
