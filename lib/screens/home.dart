import 'package:dresssew/screens/login.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static const id = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!', style: kInputStyle.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool(Login.isLoggedInText, false);
              Navigator.pushReplacementNamed(context, Login.id);
            },
            icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Hello! \n${FirebaseAuth.instance.currentUser?.displayName}',
          style: kTitleStyle.copyWith(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
