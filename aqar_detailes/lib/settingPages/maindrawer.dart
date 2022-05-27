// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:aqar_detailes/settingPages/drawer_item.dart';
import 'package:aqar_detailes/settingPages/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Material(
          color: Colors.white38,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                          "https://media.istockphoto.com/vectors/user-profile-icon-flat-red-round-button-vector-illustration-vector-id1162440985?k=20&m=1162440985&s=170667a&w=0&h=cQJ5HDdUKK_8nNDd_6RBoeDQfILERZnd_EirHTi7acI=",
                        ),
                      ),*/
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "name@gmail.com",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Divider(
                      thickness: 1,
                      height: 10,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    DrawerItem(
                        name: 'My Account',
                        icon: Icons.account_box_rounded,
                        onPressed: () => onItemPressed(context, index: 0)),
                    const SizedBox(
                      height: 30,
                    ),
                    DrawerItem(
                      name: 'My Advertisements',
                      icon: Icons.campaign_rounded,
                      onPressed: () => onItemPressed(context, index: 1),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DrawerItem(
                        name: 'Chats',
                        icon: Icons.message_outlined,
                        onPressed: () => onItemPressed(context, index: 2)),
                    const SizedBox(
                      height: 30,
                    ),
                    DrawerItem(
                        name: 'Favourites',
                        icon: Icons.favorite_outline,
                        onPressed: () => onItemPressed(context, index: 3)),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(
                      thickness: 1,
                      height: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DrawerItem(
                        name: 'Setting',
                        icon: Icons.settings,
                        onPressed: () => onItemPressed(context, index: 4)),
                    const SizedBox(
                      height: 30,
                    ),
                    DrawerItem(
                        name: 'Log out',
                        icon: Icons.logout,
                        onPressed: () => onItemPressed(context, index: 5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);

    switch (index) {
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }
}
