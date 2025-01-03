import 'dart:convert';

import 'package:aqar_detailes/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  late Widget f;
  Future<void> getFavorite() async {
    Data.favorite.clear();
    String url = "${Data.apiPath}select_favorite.php?uid_favorite=${Data.userInfo[0]['UID']}";

    f = const Center(child: CircularProgressIndicator());

    var response = await http.get(Uri.parse(url));

    var responsebody = jsonDecode(response.body);

    Data.favorite.addAll(responsebody);

    if (Data.favorite.isNotEmpty) {
      Data.getFinalFavorite();
      f = body();
    } else {
      f = const Center(child: Text("You don't have any favorite real estate", style: TextStyle(fontSize: 20)));
    }
    setState(() {});
    //print("Length Favorite: ${Data.favorite.length}");
  }

  Future<void> deleteFavorite(int index) async {
    String url = "${Data.apiPath}delete_favorite.php";
    var response = await http.post(Uri.parse(url), body: {
      "uid": "${Data.userInfo[0]['UID']}",
      "rid": "${Data.FinalFavorite[index]['RID']}",
    });
  }

  Future<void> getOwnerInfo(var ownerId) async {
    Data.ownerInfo.clear();
    String url = "${Data.apiPath}select_user_owner.php?uid=$ownerId";

    var response = await http.get(Uri.parse(url));
    var responsebody = jsonDecode(response.body);
    Data.ownerInfo.addAll(responsebody);
  }

  @override
  void initState() {
    if (Data.isLogin) {
      getFavorite();
    } else {
      f = notLogin();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
        leading: const Icon(Icons.favorite),
        actions: [
          InkWell(
            child: CircleAvatar(
              radius: 20,
              backgroundImage: Data.userInfo.isNotEmpty ? NetworkImage("${Data.imgPath}${Data.userInfo[0]['ImgProfileName']}") : NetworkImage("${Data.imgPath}user.png"),
            ),
            onTap: () {
              if (Data.isLogin) {
                Navigator.of(context).pushNamed("setting");
              } else {
                Navigator.of(context).pushNamed("login");
              }
            },
          ),
          IconButton(
            icon: Data.loginOut,
            onPressed: () async {
              if (Data.isLogin) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.scale,
                  btnOkColor: Colors.brown,
                  title: 'Are you sure ?',
                  desc: 'Are you sure you want to logout?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    setState(() {
                      f = notLogin();
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
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).pushNamed("filtering");
            },
          ),
        ],
      ),
      body: f,
    );
  }

  Widget notLogin() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("You have to \n", style: TextStyle(fontSize: 20)),
          InkWell(
            child: const Text("Login", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context).pushNamed("login");
            },
          ),
          const Text("\n to get you'r favorite real estate", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: getFavorite,
      child: ListView.builder(
        itemCount: Data.FinalFavorite.length,
        itemBuilder: (context, i) {
          return Dismissible(
            key: UniqueKey(), // Key("$i")
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              print("${Data.FinalFavorite.length}");
              await deleteFavorite(i);
              Data.FinalFavorite.removeAt(i);
              print("${Data.FinalFavorite.length}");
            },
            child: InkWell(
              child: Card(
                child: Row(children: [
                  Expanded(child: Image.network("${Data.imgPath}${Data.FinalFavorite[i]['ImageName']}")),
                  Expanded(
                    child: ListTile(
                      title: Text("${Data.FinalFavorite[i]['Governorate']}"),
                      subtitle: Text("${Data.FinalFavorite[i]['Price']}JD"),
                    ),
                  ),
                ]),
              ),
              onTap: () async {
                await getOwnerInfo(Data.FinalFavorite[i]['PublisherID']);
                setState(() {
                  Data.DetailesRE.clear();
                  print("i : $i");
                  print("${Data.FinalFavorite[i]}");
                  Data.DetailesRE.add(Data.FinalFavorite[i]);
                  Data.pageFrom = "f";
                  Navigator.of(context).pushNamed('detailes');
                  print("DetailesRE: ${Data.DetailesRE[0]['RID']}");
                });
              },
            ),
          );
        },
      ),
    );
  }
}
