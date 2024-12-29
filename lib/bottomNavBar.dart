import 'package:aqar_detailes/data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String? email = "";
  String? password = "";

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    email = prefs.getString("email");
    password = prefs.getString("password");

    if (email != null && password != null) {
      print("Emailprefs: $email \n Passwordprefs: $password");

      await loginApi();

      if (Data.userInfo.isNotEmpty) {
        setState(() {
          Data.isLogin = true;
          Data.loginOut = const Icon(Icons.logout);
        });
      }
    } else {
      Data.checkprefs = false;
      print("it is null");
    }
  }

  Future<void> loginApi() async {
    Data.userInfo.clear();
    String url = "${Data.apiPath}login.php?email=$email&password=$password";

    var response = await http.get(
      Uri.parse(url),
      //body: {"email": "$emailText", "password": "$passwordText"},
    );

    var responsebody = jsonDecode(response.body);
    //print("responsebody: $responsebody");
    Data.userInfo.addAll(responsebody);
    print("userInfo: ${Data.userInfo}");
  }

  @override
  void initState() {
    if (Data.checkprefs && !Data.isLogin) {
      getPrefs();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.brown,
        color: Colors.brown,
        height: 50,
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.library_add, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
        ],
        index: Data.currentIndex,
        onTap: (index) {
          setState(() {
            Data.currentIndex = index;
          });
        },
      ),
      body: Data.pages[Data.currentIndex],
    );
  }
}
