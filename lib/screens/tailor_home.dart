import 'package:dresssew/main.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:loading_overlay/loading_overlay.dart';

class TailorHomeView extends StatefulWidget {
  static const id = "/tailor_home";

  const TailorHomeView({super.key});
  @override
  _TailorHomeViewState createState() => _TailorHomeViewState();
}

class _TailorHomeViewState extends State<TailorHomeView> {
  final controller = ZoomDrawerController();
  bool isLoadingTailors = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 20)).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  loadTailors() {
    toggleLoadingStatus();
  }

  void toggleLoadingStatus() {
    if (mounted) {
      setState(() {
        isLoadingTailors = !isLoadingTailors;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: appUser == null || isLoadingTailors,
      progressIndicator: const CircularProgressIndicator(),
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
              icon: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.menu),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Text('Hello!'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
