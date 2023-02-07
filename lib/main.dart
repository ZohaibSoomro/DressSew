import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dresssew/models/app_user.dart';
import 'package:dresssew/screens/customer_registration.dart';
import 'package:dresssew/screens/forgot_password.dart';
import 'package:dresssew/screens/home.dart';
import 'package:dresssew/screens/login.dart';
import 'package:dresssew/screens/sign_up.dart';
import 'package:dresssew/screens/tailor_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? isLoggedIn;
AppUser? appUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool(Login.isLoggedInText);
  print('Is Logged In: $isLoggedIn');
  if (isLoggedIn != null && isLoggedIn!) {
    final appUserData = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .limit(1)
        .get();
    appUser = AppUser.fromJson(appUserData.docs.first.data());
  }
  runApp(const DressSewApp());
}

class DressSewApp extends StatelessWidget {
  const DressSewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn == null || !isLoggedIn!
          ? Login()
          : appUser != null && appUser!.isRegistered
              ? Home()
              : appUser!.isTailor
                  ? TailorRegistration(userData: appUser!)
                  : CustomerRegistration(
                      userData: appUser!,
                    ),
      routes: {
        Home.id: ((context) => Home()),
        Login.id: ((context) => Login()),
        SignUp.id: ((context) => SignUp()),
        ForgotPassword.id: ((context) => ForgotPassword()),
      },
    );
  }
}
