// ignore_for_file: prefer_const_constructors

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
import 'package:aqar_detailes/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'filtering_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        dividerTheme: DividerThemeData(
          color: Colors.brown[100],
          thickness: 3,
        ),
      ),
      home: BottomNavBar(),
      routes: {
        "filtering": (context) => Filtering(),
        "detailes": (context) => Detailes(),
        "result": (context) => Result(),
        "bottomBar": ((context) => BottomNavBar()),
        "login": (context) => LoginScreen(),
        "account": (context) => Account(),
        "setting": (context) => ProfilePage(),
        "add": (context) => AddProperty(),
        "signup": (context) => SignUp(),
        "slider": (context) => ImgSlider(),
        "map": (context) => MapPage(),
      },
    );
  }
}
