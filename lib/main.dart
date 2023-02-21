import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dresssew/models/app_user.dart';
import 'package:dresssew/screens/customer_registration.dart';
import 'package:dresssew/screens/forgot_password.dart';
import 'package:dresssew/screens/home.dart';
import 'package:dresssew/screens/login.dart';
import 'package:dresssew/screens/sign_up.dart';
import 'package:dresssew/screens/tailor_registration.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? isLoggedIn;
AppUser? appUser;
bool isUrduActivated = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
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

  runApp(
    EasyLocalization(
      supportedLocales: [const Locale('en', 'US'), const Locale('ur', 'PK')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      child: const DressSewApp(),
    ),
  );
}

class DressSewApp extends StatelessWidget {
  const DressSewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn == null || !isLoggedIn!
          ? const Login()
          : appUser != null && appUser!.isRegistered
              ? Home()
              : appUser!.isTailor
                  ? TailorRegistration(userData: appUser!)
                  : CustomerRegistration(
                      userData: appUser!,
                    ),
      routes: {
        Home.id: ((context) => Home()),
        Login.id: ((context) => const Login()),
        SignUp.id: ((context) => const SignUp()),
        ForgotPassword.id: ((context) => ForgotPassword()),
      },
    );
  }
}

buildTranslateButton(BuildContext context,
    {required VoidCallback onTranslated}) {
  if (context.locale == const Locale("ur", "PK")) {
    isUrduActivated = true;
  } else {
    isUrduActivated = false;
  }
  return OutlinedButton(
    style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
    onPressed: () async {
      await context.setLocale(isUrduActivated
          ? const Locale("en", "US")
          : const Locale("ur", "PK"));
      onTranslated();
    },
    child: Text(
      isUrduActivated ? 'English' : "اردو",
      style: kTextStyle.copyWith(color: Colors.blue, fontSize: 15),
    ),
  );
}
