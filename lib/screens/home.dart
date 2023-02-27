import 'package:dresssew/main.dart';
import 'package:dresssew/networking/firestore_helper.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/custom_widgets/tailor_Card.dart';
import 'package:dresssew/utilities/my_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../models/tailor.dart';

class Home extends StatefulWidget {
  static const id = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = ZoomDrawerController();
  final FireStoreHelper fireStorer = FireStoreHelper();
  List<Tailor> tailors = [];

  @override
  void initState() {
    super.initState();
    fireStorer.loadAllTailors().then((value) {
      tailors = value;
      if (mounted) setState(() {});
      print("Tailors length: ${tailors.length}");
    });
    Future.delayed(const Duration(milliseconds: 20)).then((value) {
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
    return LoadingOverlay(
      isLoading: appUser == null,
      child: MyDrawer(
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
          body: SingleChildScrollView(
            child: Column(
              children: List.generate(
                tailors.length,
                (index) {
                  return TailorCard(
                    tailor: tailors[index],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
