// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser; //late : معين action  باخر الشك عليه لرن ازو لما تنفذ

class ChatScreen extends StatefulWidget {
  //ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageTextController = TextEditingController();
  String? messageText; //this will give us the Message

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //void getMessagesfromCollection() async {
  // final messages = await _firestore.collection('messages').get();
  // for (var message in messages.docs) {
  //  print(message.data());
  //  }
  // }
  //void MessagesStrems() async {
  //await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //رح تحدث المسج اول باول
  // for (var message in snapshot.docs) {
  //مشان احصل على كل رسالة
  //  print(message.data());
  // }
  //  }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 45,
        backgroundColor: Colors.blue[900],
        title: Row(
          children: [
            SizedBox(width: 3),
            Text("MessageMe"),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //MessagesStrems();
                //add here logout function
                _auth.signOut();
                Navigator.pop(context);
              })
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ClipRRect(
              child: Image.asset(
                "assets/photo.jpg",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: double.infinity,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: [0.0, 0.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MessageStreamBuilder(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: MessageTextController,
                              onChanged: (value) {
                                messageText = value;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                hintText: 'Write your message here...',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              MessageTextController.clear();
                              _firestore.collection('messages').add({
                                'text': messageText,
                                'sender': signedInUser.email,
                                'time': FieldValue.serverTimestamp(),
                              });
                            },
                            child: Text(
                              'send',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.sender, this.text, required this.isMe, Key? key})
      : super(key: key);
  final String? sender;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.blue[100]),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Material(
              elevation: 5,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              color: isMe ? Colors.blue[800] : Colors.white70,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : Colors.pink[900],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  //const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return //QuerySnapshot:Contains the results of a query نكتبت
        //snapshots():firestore هاي من
        //snapshot : AsyncSnapshot هاي من فلتر
        StreamBuilder<QuerySnapshot>(
      //copy data from firestore
      //orderBy:timestamp ترتيب الرسائل حسب timestamp
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            //مؤشر التحميل
            backgroundColor: Colors.blue,
          ));
        }
        final messages = snapshot.data!.docs.reversed; // list data تعطيني
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');

          final currentUser = signedInUser.email; //signedInUser.email

          final messageWidget = MessageLine(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }

        return Expanded(
          child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets),
        );
      },
    );
  }
}
