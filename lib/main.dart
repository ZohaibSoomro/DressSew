import 'package:dresssew/screens/forgot_password.dart';
import 'package:dresssew/screens/login.dart';
import 'package:dresssew/screens/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DressSewApp());
}

class DressSewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        Login.id: ((context) => Login()),
        SignUp.id: ((context) => SignUp()),
        ForgotPassword.id: ((context) => ForgotPassword()),
      },
    );
  }
}

class Home extends StatefulWidget {
  static const ID = "/Home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
