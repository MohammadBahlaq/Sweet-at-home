import 'package:aqar_detailes/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:string_validator/string_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
////////////////////////////////////////////////////
  final ke = GlobalKey<FormState>();

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  var id = 0;
  List<PlatformFile>? _files = [];
  Future<void> uploadFile() async {
    var uri = Uri.parse('${Data.apiPath}upload_file.php');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', _files!.first.path.toString()));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded ...');
    } else {
      print('Something went wrong!');
    }
  }

  Future<void> _openFileExplorer() async {
    _files = (await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false, allowedExtensions: null))!.files;
    await uploadFile();
    setState(() {});
    print('Loaded file Name is : ${_files!.first.name}');
  }

  Future<void> SignupUser(String imgName) async {
    String url = "${Data.apiPath}insert_user.php";
    var response = await http.post(Uri.parse(url), body: {
      "name": userName.text,
      "email": email.text,
      "phonenumber": phoneNumber.text,
      "password": password.text,
      "imgprofilename": imgName,
    });
    var responsbody = response.body.toString();
    id = int.parse(responsbody);
    print("UserID: $id");
  }

////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SignUp")),
      body: Form(
        key: ke,
        child: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(20),
                  ),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [Colors.white, Color.fromRGBO(20, 5, 20, 4)],
                  // ),
                ),
                child: Column(
                  children: <Widget>[
                    buildUserImage(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                      child: TextFormField(
                        controller: userName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          } else if (!isAlpha(value.replaceAll(" ", ""))) {
                            return 'Only Letters Please';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintTextDirection: TextDirection.ltr,
                            labelText: 'Name',
                            labelStyle: const TextStyle(fontSize: 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            prefixIcon: const Icon(Icons.person),
                            hintText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            hintTextDirection: TextDirection.ltr,
                            labelText: 'email',
                            labelStyle: const TextStyle(fontSize: 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            prefixIcon: const Icon(Icons.email),
                            hintText: 'email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter an email please";
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'Enter a valid email please';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                      child: TextFormField(
                        controller: password,
                        decoration: InputDecoration(
                            hintTextDirection: TextDirection.ltr,
                            labelText: 'password',
                            labelStyle: const TextStyle(fontSize: 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            prefixIcon: const Icon(Icons.password),
                            hintText: 'password'),
                        validator: (value) {
                          print("${value!.length}");
                          if (value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          if (value.length < 8) {
                            return 'Please Password must be at least 8 character';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                      child: TextFormField(
                        controller: phoneNumber,
                        decoration: InputDecoration(
                            hintTextDirection: TextDirection.ltr,
                            labelText: 'phone number',
                            labelStyle: const TextStyle(fontSize: 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            prefixIcon: const Icon(Icons.phone_android),
                            hintText: 'phone number'),
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (isAlpha(value)) {
                            return 'Only Numbers Please';
                          } else if (value.length != 10) {
                            return 'Please enter a VALID phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(40.0)),
                          child: const Align(
                            child: Text(
                              'Signup',
                              style: TextStyle(color: Colors.white70, fontSize: 20),
                            ),
                          ),
                        ),
                        onTap: () async {
                          //
                          if (ke.currentState!.validate() && EmailValidator.validate(email.text)) {
                            //
                            if (_files!.isNotEmpty) {
                              await SignupUser(_files!.first.name);
                            } else {
                              await SignupUser("default.png");
                            }

                            if (id == 0) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.scale,
                                btnOkColor: Colors.red,
                                title: 'Exist',
                                desc: 'Please, this account is already exist',
                                btnOkOnPress: () {
                                  setState(() {
                                    Data.isLogin = false;
                                    Data.checkprefs = false;
                                    Data.loginOut = const Icon(Icons.login);
                                    Data.userInfo.clear();
                                    Data.FinalFavorite.clear();
                                    Data.FinalUserRealEstate.clear();
                                  });
                                },
                              ).show();
                            } else {
                              Navigator.of(context).pushNamed("login");
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 83),
                  ],
                ),
              ),
            ))
          ],
        ),
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
              child: _files!.isNotEmpty
                  ? Image.network(
                      "${Data.imgPath}${_files!.first.name}",
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
                decoration: const BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  color: Colors.white,
                  onPressed: () async {
                    await _openFileExplorer();
                    setState(() {});
                  },
                ),
              ))
        ],
      ),
    );
  }
}
