import 'package:aqar_detailes/data.dart';
import 'package:aqar_detailes/settingPages/user/user_data.dart';
import 'package:aqar_detailes/settingPages/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class EditEmailFormPage extends StatefulWidget {
  const EditEmailFormPage({super.key});

  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var user = UserData.myUser;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void updateUserValue(String email) {
    user.email = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            const SizedBox(
                width: 320,
                child: Text(
                  "What's your email?",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                    height: 100,
                    width: 320,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Your email address'),
                      controller: emailController,
                    ))),
            Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.brown),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() && EmailValidator.validate(emailController.text)) {
                            updateUserValue(emailController.text);
                            ////////////////////////////////
                            String email = emailController.text;
                            UserData.updateUserInfo("update_userEmail.php", "email", email);
                            Data.userInfo[0]['Email'] = email;
                            ////////////////////////////////
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
}
