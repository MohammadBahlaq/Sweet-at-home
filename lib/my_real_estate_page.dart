import 'dart:convert';

import 'package:aqar_detailes/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyRealEstate extends StatefulWidget {
  const MyRealEstate({super.key});

  @override
  State<MyRealEstate> createState() => _MyRealEstateState();
}

class _MyRealEstateState extends State<MyRealEstate> {
  late Widget m;
  Future<void> getMyRealEstate() async {
    Data.UserRealEstate.clear();
    String url = "${Data.apiPath}select_realEstatePublisher.php?publisherid=${Data.userInfo[0]['UID']}";

    m = const Center(child: CircularProgressIndicator());

    var response = await http.get(Uri.parse(url));

    var responsebody = jsonDecode(response.body);

    Data.UserRealEstate.addAll(responsebody);

    if (Data.UserRealEstate.isNotEmpty) {
      Data.getFinalUserRealEstate();
      m = body();
    } else {
      m = const Center(child: Text("You don't have any Real Estate", style: TextStyle(fontSize: 20)));
    }
    setState(() {});
  }

  Future<void> getOwnerInfo(var OwnerId) async {
    Data.ownerInfo.clear();
    String url = "${Data.apiPath}select_user_owner.php?uid=$OwnerId";

    var response = await http.get(Uri.parse(url));
    var responsebody = jsonDecode(response.body);
    Data.ownerInfo.addAll(responsebody);
    // Data.ownerInfo.addAll(Data.userInfo);
    // print("UserInfo: ${Data.userInfo}");
    // print("OwnerInfo: ${Data.ownerInfo}");
  }

  Future<void> deletRealEstate(int index) async {
    String url = "${Data.apiPath}delete_realEstate.php";

    var response = await http.post(Uri.parse(url), body: {
      "ridfk": "${Data.FinalUserRealEstate[index]['RID']}",
      "favoriterid": "${Data.FinalUserRealEstate[index]['RID']}",
      "rid": "${Data.FinalUserRealEstate[index]['RID']}",
    });
    setState(() {});
  }

  @override
  void initState() {
    Set x = {1, 1, 2, 3, 4, 5};
    print(x);
    if (Data.isLogin) {
      getMyRealEstate();
    } else {
      m = notLogin();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Real estate"),
        leading: const Icon(Icons.my_library_add),
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
                      m = notLogin();
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
      body: m,
    );
  }

  Widget notLogin() {
    return Center(
      // StreamBuilder(
      //   stream: stream,
      //   initialData: initialData,
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     return Container(
      //       child: child,
      //     );
      //   },
      // ),
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
          const Text("\n to get you'r published real estate", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: getMyRealEstate,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: Data.FinalUserRealEstate.length,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    "${Data.imgPath}${Data.FinalUserRealEstate[i]['ImageName']}",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      "Real estate number: ${Data.FinalUserRealEstate[i]['RID']}\n ${Data.FinalUserRealEstate[i]['Title']}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      "${Data.FinalUserRealEstate[i]['Governorate']}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange,
                        ),
                        child: Text(
                          "${Data.FinalUserRealEstate[i]['Price']}JD",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.scale,
                              btnOkColor: Colors.brown,
                              title: 'Are you sure ?',
                              desc: 'Are you sure you want to Delete?',
                              btnOkText: "Delete",
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                await deletRealEstate(i);
                                Data.FinalUserRealEstate.removeAt(i);
                              },
                            ).show();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.delete),
                              Text("Delete"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Data.DetailesRE.clear();
                            Data.DetailesRE.add(Data.FinalUserRealEstate[i]);
                            await Data.getImagesUserRealEstate(Data.FinalUserRealEstate[i]['RID']);
                            print("${Data.Images.length}");
                            Data.isDragable = true;
                            //Data.addEdit = "edit";

                            print("Governorate: ${Data.DetailesRE[0]['Governorate']}");
                            print("RealEstateType: ${Data.DetailesRE[0]['RealEstateType']}");

                            Navigator.of(context).pushNamed("add");
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Edit"),
                              Icon(Icons.edit),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () async {
                await getOwnerInfo(Data.FinalUserRealEstate[i]['PublisherID']);
                setState(() {
                  Data.DetailesRE.clear();
                  Data.DetailesRE.add(Data.FinalUserRealEstate[i]);
                  Data.pageFrom = "m";
                  Navigator.of(context).pushNamed("detailes");
                });
              },
            ),
          );
        },
      ),
    );
  }
}
