// ignore_for_file: prefer_const_constructors

import 'package:aqar_detailes/data.dart';
import 'package:aqar_detailes/settingPages/user/user_data.dart';
import 'package:aqar_detailes/settingPages/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class EditPassFormPage extends StatefulWidget {
  @override
  _EditPassFormPageState createState() => _EditPassFormPageState();
}

class _EditPassFormPageState extends State<EditPassFormPage> {
  final _formKey = GlobalKey<FormState>();
  final pwdController = TextEditingController();
  final pwdController2 = TextEditingController();

  var user = UserData.myUser;
  bool hidePasswoed = true;
  Icon c = Icon(Icons.visibility);
  Icon c2 = Icon(Icons.visibility);
  bool hidePasswoed2 = true;
  @override
  void dispose() {
    pwdController.dispose();
    pwdController2.dispose();
    super.dispose();
  }

  void updateUserValue(String description) {
    user.Password = description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: 320,
                    child: const Text(
                      "Upadate your password",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Current Password.';
                            }
                            if (value != Data.userInfo[0]['Password']) {
                              return "This is not current password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Current Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePasswoed2 = !hidePasswoed2;
                                      if (hidePasswoed2 == false) {
                                        c2 = Icon(Icons.visibility_off);
                                      } else
                                        c2 = Icon(Icons.visibility);
                                    });
                                  },
                                  icon: c2)),
                          controller: pwdController2,
                          obscureText: hidePasswoed2,
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your New Password.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'New Password ',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePasswoed = !hidePasswoed;
                                      if (hidePasswoed == false) {
                                        c = Icon(Icons.visibility_off);
                                      } else
                                        c = Icon(Icons.visibility);
                                    });
                                  },
                                  icon: c)),
                          controller: pwdController,
                          obscureText: hidePasswoed,
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 220,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.brown),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateUserValue(pwdController.text);
                                ////////////////////////////////
                                String password = pwdController.text;
                                print("current Password : " +
                                    pwdController2.text);
                                print("New Password : " + pwdController.text);
                                UserData.updateUserInfo(
                                    "update_userPassword.php",
                                    "password",
                                    password);
                                Data.userInfo[0]['Password'] = password;
                                //////////////////////////////////
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
  }

  void Passwordview() {
    hidePasswoed = !hidePasswoed;
    setState(() {});
  }
}
