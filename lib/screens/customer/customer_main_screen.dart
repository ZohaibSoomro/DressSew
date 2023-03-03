import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dresssew/main.dart';
import 'package:dresssew/screens/customer/customer_home.dart';
import 'package:dresssew/screens/customer/customer_profile.dart';
import 'package:dresssew/screens/customer/search_tailor.dart';
import 'package:dresssew/screens/store_screen.dart';
import 'package:dresssew/utilities/constants.dart';
import 'package:dresssew/utilities/my_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerMainScreen extends StatefulWidget {
  static const id = "/customer_main_screen";

  const CustomerMainScreen({super.key});
  @override
  _CustomerMainScreenState createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final controller = ZoomDrawerController();
  int index = 0;

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
            icon: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.menu),
            ),
          ),
        ),
        body: index == 0
            ? CustomerHomeView()
            : index == 1
                ? SearchTailor()
                : index == 2
                    ? StoreScreen()
                    : CustomerProfile(),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [
            FontAwesomeIcons.house,
            FontAwesomeIcons.magnifyingGlass,
            FontAwesomeIcons.shop,
            FontAwesomeIcons.user,
          ],
          activeColor: Colors.blue,
          activeIndex: index,
          gapLocation: GapLocation.none,
          // notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => this.index = index),
          //other params
        ),
      ),
    );
  }
}
