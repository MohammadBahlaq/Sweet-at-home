import 'package:aqar_detailes/account_page.dart';
import 'package:aqar_detailes/add_real_estate_page.dart';
import 'package:aqar_detailes/bottomNavBar.dart';
import 'package:aqar_detailes/detailes_page.dart';
import 'package:aqar_detailes/img_slider_page.dart';
import 'package:aqar_detailes/login_page.dart';
import 'package:aqar_detailes/map_page.dart';
import 'package:aqar_detailes/result_page.dart';
import 'package:aqar_detailes/settingPages/pages/profile_page.dart';
import 'package:aqar_detailes/signup_page.dart';
import 'package:flutter/material.dart';

import 'filtering_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        dividerTheme: DividerThemeData(
          color: Colors.brown[100],
          thickness: 3,
        ),
      ),
      home: const BottomNavBar(),
      routes: {
        "filtering": (context) => const Filtering(),
        "detailes": (context) => const Detailes(),
        "result": (context) => const Result(),
        "bottomBar": ((context) => const BottomNavBar()),
        "login": (context) => const LoginScreen(),
        "account": (context) => const Account(),
        "setting": (context) => const ProfilePage(),
        "add": (context) => const AddProperty(),
        "signup": (context) => const SignUp(),
        "slider": (context) => const ImgSlider(),
        "map": (context) => const MapPage(),
      },
    );
  }
}
