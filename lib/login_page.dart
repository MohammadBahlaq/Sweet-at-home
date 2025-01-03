import 'dart:convert';

import 'package:aqar_detailes/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberpwd = false;
  bool sec = true;
  var visable = const Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = const Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );
////////////////////////////////////////////////////////////////////////////////
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  Future<void> loginApi() async {
    Data.userInfo.clear();

    String url = "${Data.apiPath}login.php?email=${emailControler.text}&password=${passwordControler.text}";

    var response = await http.get(
      Uri.parse(url),
      //body: {"email": "$emailText", "password": "$passwordText"},
    );

    var responsebody = jsonDecode(response.body);
    //print("responsebody: $responsebody");
    Data.userInfo.addAll(responsebody);
    print("userInfo: ${Data.userInfo}");
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Login"),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Colors.white,
                  //     Colors.brown.shade100,
                  //     Colors.brown.shade200,
                  //     Colors.brown.shade300,
                  //     Colors.brown.shade400,
                  //     Colors.brown.shade500,
                  //     Colors.brown.shade600,
                  //     Colors.brown.shade700,
                  //   ],
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formState,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          buildEmail(),
                          const SizedBox(
                            height: 30,
                          ),
                          buildPassword(),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildRememberassword(),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          buildLoginButton(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              InkWell(
                                child: const Text(
                                  " Signup",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed("signup");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: const Color(0xffebefff), borderRadius: BorderRadius.circular(10), boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
            )
          ]),
          child: TextFormField(
            controller: emailControler,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Enter an email please";
              }
              if (!EmailValidator.validate(text)) {
                return 'Enter a valid email please';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff4c5166),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color(0xffebefff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
            ],
          ),
          height: 60,
          child: TextFormField(
            controller: passwordControler,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Enter a password please";
              }
              return null;
            },
            obscureText: sec,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      sec = !sec;
                    });
                  },
                  icon: sec ? visableoff : visable,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: const Icon(
                  Icons.vpn_key,
                  color: Color(0xff4c5166),
                ),
                hintText: "pwd",
                hintStyle: const TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildRememberassword() {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: rememberpwd,
                checkColor: Colors.blueGrey,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    rememberpwd = value!;
                    print("remember: $rememberpwd");
                  });
                },
              )),
          const Text(
            "Remember me",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(40.0)),
          child: const Align(
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
          ),
        ),
        onTap: () async {
          //////////////////////////////////////////////////////////////////////
          if (formState.currentState!.validate()) {
            await loginApi();
            if (Data.userInfo.isNotEmpty) {
              //print("Correct Login");
              Data.loginOut = const Icon(Icons.logout);
              Data.isLogin = true;
              if (rememberpwd) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                print("prefs is clear");
                Data.savePrefs();
                Data.checkprefs = true;
              } else {
                Data.checkprefs = false;
              }
              Navigator.of(context).pushReplacementNamed("bottomBar");
            } else {
              Data.loginOut = const Icon(Icons.login);
              Data.isLogin = false;
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.scale,
                      btnOkColor: Colors.red,
                      title: 'Not Correct',
                      desc: 'Email or Password is not correct',
                      btnOkOnPress: () {})
                  .show();
              //print("User Name or Password not correct");
            }
          }
          //print("Emai: $emailText \n Password: $passwordText");
          //////////////////////////////////////////////////////////////////////
        },
      ),
    );
  }
}
