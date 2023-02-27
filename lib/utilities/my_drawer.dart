import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dresssew/main.dart';
import 'package:dresssew/models/app_user.dart';
import 'package:dresssew/screens/login.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/HistoryPage.dart';

class MyDrawer extends StatefulWidget {
  final Widget mainScreen;
  final ZoomDrawerController controller;
  final AppUser userData;
  const MyDrawer(
      {Key? key,
      required this.mainScreen,
      required this.controller,
      required this.userData})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? language;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 20)).then((value) {
      switch (context.locale.languageCode.toLowerCase()) {
        case "en":
          language = "English";
          break;
        case "ur":
          language = "اردو";
          break;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: widget.controller,
      menuScreen: buildDrawerContent(),
      mainScreen: widget.mainScreen,
      borderRadius: 24.0,
      // showShadow: true,
      angle: 0,
      drawerShadowsBackgroundColor: Colors.grey.shade300,
      slideWidth: MediaQuery.of(context).size.width * 0.71,
      menuScreenWidth: MediaQuery.of(context).size.width * 0.7,
      isRtl: isUrduActivated,
      androidCloseOnBackTap: true,
      moveMenuScreen: false,
    );
  }

  buildDrawerContent() {
    final size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: size.width * 0.002),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundImage: (FirebaseAuth
                                              .instance.currentUser!.photoURL !=
                                          null
                                      ? NetworkImage(FirebaseAuth
                                          .instance.currentUser!.photoURL!)
                                      : const AssetImage('assets/user.png'))
                                  as ImageProvider,
                              backgroundColor: Colors.grey.shade300,
                              radius: 35,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.30,
                            height: size.height * 0.05,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: AnimatedToggleSwitch<String>.size(
                                current: language ??
                                    (context.locale == const Locale("ur", "PK")
                                        ? "English"
                                        : "اردو"),
                                values: const ["English", "اردو"],
                                indicatorColor: Colors.white,
                                indicatorBorderRadius: BorderRadius.circular(5),
                                borderColor: Colors.white,
                                borderWidth: 1,
                                innerColor: Colors.transparent,
                                iconOpacity: 1,
                                iconBuilder: (value, size) {
                                  return Center(
                                    child: Text(
                                      value,
                                      style: kInputStyle.copyWith(
                                        fontSize: language == value ? 12 : 12,
                                        color: language == value
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  );
                                },
                                onChanged: onLanguageChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: size.height * 0.01),

                      SizedBox(height: size.height * 0.01),
                      FittedBox(
                        child: Text(
                          widget.userData.name,
                          style: kInputStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.5),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                buildDrawerItem(
                  'Back',
                  FontAwesomeIcons.arrowLeft,
                  onTap: () {
                    widget.controller.close!.call();
                  },
                ),
                buildDrawerItem(
                  'History',
                  FontAwesomeIcons.clockRotateLeft,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const History()),
                    );
                    widget.controller.close!.call();
                  },
                ),
                buildDrawerItem(
                  'Rate Us',
                  FontAwesomeIcons.star,
                  onTap: () {
                    widget.controller.close!.call();
                  },
                ),
                buildDrawerItem(
                  'Log out',
                  FontAwesomeIcons.arrowRightFromBracket,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool(Login.isLoggedInText, false);
                    Navigator.pushReplacementNamed(context, Login.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildDrawerItem(String title, IconData icon,
      {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      onTap: onTap,
      title: Text(
        title,
        style: kInputStyle,
      ),
    );
  }

  onLanguageChanged(val) async {
    if (mounted) {
      setState(() {
        language = val;
        if (language == "English") {
          isUrduActivated = false;
        } else {
          isUrduActivated = true;
        }
      });
    }
    await context.setLocale(language == "English"
        ? const Locale("en", "US")
        : const Locale("ur", "PK"));
    if (mounted) {
      setState(() {});
    }
  }
}
