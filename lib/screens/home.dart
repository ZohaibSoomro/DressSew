import 'package:dresssew/main.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';

class Home extends StatefulWidget {
  static const id = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = ZoomDrawerController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 20)).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      userData: appUser!,
      controller: controller,
      mainScreen: Scaffold(
        appBar: AppBar(
          title:
              Text('Welcome dear!', style: kInputStyle.copyWith(fontSize: 20))
                  .tr(),
          leading: IconButton(
            onPressed: () {
              controller.open!.call();
            },
            icon: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(Icons.menu),
            ),
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Text(
                'Hello! \n${FirebaseAuth.instance.currentUser?.displayName}',
                style: kTitleStyle.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
