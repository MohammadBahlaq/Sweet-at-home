// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:aqar_detailes/data.dart';
import 'package:aqar_detailes/settingPages/pages/edit_email.dart';
import 'package:aqar_detailes/settingPages/pages/edit_name.dart';
import 'package:aqar_detailes/settingPages/pages/edit_password.dart';
import 'package:aqar_detailes/settingPages/pages/edit_phone.dart';
import 'package:flutter/material.dart';
import '../user/user.dart';
import '../user/user_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
//////////////////////////////////////////////////
  List<PlatformFile>? _files;

  Future<void> uploadFile() async {
    var uri = Uri.parse('${Data.apiPath}upload_file.php');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
        'file', _files!.first.path.toString()));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded ...');
    } else {
      print('Something went wrong!');
    }
  }

  Future<void> _openFileExplorer() async {
    _files = (await FilePicker.platform.pickFiles(
            type: FileType.any, allowMultiple: false, allowedExtensions: null))!
        .files;
    await uploadFile();
    await updateImage(_files!.first.name);
    print('Loaded file Name is : ${_files!.first.name}');
  }

  Future<void> updateImage(String imgName) async {
    String url = "${Data.apiPath}update_imageProfile.php";
    http.post(Uri.parse(url), body: {
      "imgprofilename": imgName,
      "uid": "${Data.userInfo[0]['UID']}",
    });
    setState(() {
      Data.userInfo[0]['ImgProfileName'] = imgName;
    });
  }

//////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final user = UserData.myUser;

    return Scaffold(
      body: Column(
        children: [
          AppBar(
              centerTitle: true,
              backgroundColor: Colors.brown,
              title: Text(
                'Account setting',
              )),
          buildUserImage(),
          buildUserInfoDisplay(user.name, 'Name', EditNameFormPage()),
          buildUserInfoDisplay(user.phone, 'Phone', EditPhoneFormPage()),
          buildUserInfoDisplay(user.email, 'Email', EditEmailFormPage()),
          Expanded(
            child: buildpass(user),
            flex: 4,
          )
        ],
      ),
    );
  }

  Widget buildUserImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 50),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 70,
            child: ClipOval(
              child: Data.userInfo.isNotEmpty
                  ? Image.network(
                      "${Data.imgPath}${Data.userInfo[0]['ImgProfileName']}",
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      '${Data.imgPath}user.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                height: 40,
                width: 40,
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  color: Colors.white,
                  onPressed: () async {
                    await _openFileExplorer();
                  },
                ),
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ))
        ],
      ),
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Expanded(
                    child: TextButton(
                        onPressed: () {
                          navigateSecondPage(editPage);
                        },
                        child: Row(children: [
                          Text(
                            getValue,
                            style: TextStyle(fontSize: 16, height: 1.4),
                          ),
                          Spacer(),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                            size: 40.0,
                          )
                        ]))),
              ),
            ],
          ));

  Widget buildpass(User user) => Padding(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Container(
              width: 350,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      navigateSecondPage(EditPassFormPage());
                    },
                    child: Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
                          size: 40.0,
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Container(
                width: 350,
                child: Divider(
                  thickness: 1,
                  height: 3,
                  color: Colors.black38,
                )),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      
                    },
                    child: Text("UPLOADE",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black54)),
                  ),
                ),
               SizedBox(
                  width: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white))),
                ),
              ],
            )*/
          ],
        ),
      );

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
