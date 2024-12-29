import 'dart:convert';

import 'package:aqar_detailes/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Widget r;
  void getResults() async {
    String apiUrl = "";
    r = const Center(child: CircularProgressIndicator());

    //http://10.0.2.2
    apiUrl =
        "${Data.apiPath}select_realEstate.php?nbedrooms1=${Data.nBedRooms[0]}&nbedrooms2=${Data.nBedRooms[1]}&nbedrooms3=${Data.nBedRooms[2]}&nbedrooms4=${Data.nBedRooms[3]}&nbathrooms1=${Data.nBathRooms[0]}&nbathrooms2=${Data.nBathRooms[1]}&nbathrooms3=${Data.nBathRooms[2]}&nkitchens1=${Data.nKitchens[0]}&nkitchens2=${Data.nKitchens[1]}&nkitchens3=${Data.nKitchens[2]}&nlivingrooms1=${Data.nLivingRooms[0]}&nlivingrooms2=${Data.nLivingRooms[1]}&nlivingrooms3=${Data.nLivingRooms[2]}&nlivingrooms4=${Data.nLivingRooms[3]}&price1=${Data.minPrice}&price2=${Data.maxPrice}&space1=${Data.minSpace}&space2=${Data.maxSpace}&governorate=${Data.selected}&realestatetype=${Data.realEstateType}";

    Data.Results.clear();
    var response = await http.get(Uri.parse(apiUrl));
    var resbody = jsonDecode(response.body);
    Data.Results.addAll(resbody);

    //print("Results >>>${Data.Results}");

    if (Data.Results.isNotEmpty) {
      Map m = Data.Results.first;
      print(Data.Results.first);
      //print(m['RID']);
      Data.getFinalResults();
      r = body();
    } else {
      r = const Center(child: Text("No Results", style: TextStyle(fontSize: 20)));
    }
    setState(() {});
  }

  Future<void> getOwnerInfo(var OwnerId) async {
    Data.ownerInfo.clear();
    String url = "${Data.apiPath}select_user_owner.php?uid=$OwnerId";

    var response = await http.get(Uri.parse(url));
    var responsebody = jsonDecode(response.body);
    Data.ownerInfo.addAll(responsebody);
  }

  @override
  void initState() {
    getResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: const Icon(Icons.apartment),
        title: const Text("Results"),
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
      body: r,
    );
  }

  Widget body() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: Data.FinalResults.length,
      itemBuilder: (context, i) {
        return Container(
          clipBehavior: Clip.hardEdge,
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
                  "${Data.imgPath}${Data.FinalResults[i]['ImageName']}",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Real estate number: ${Data.FinalResults[i]['RID']}\n ${Data.FinalResults[i]['Title']}", //$i
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "${Data.FinalResults[i]['Governorate']}", //Amman
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange,
                  ),
                  child: Text(
                    "${Data.FinalResults[i]['Price']}JD", //300
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              await getOwnerInfo(Data.FinalResults[i]['PublisherID']);
              setState(() {
                Data.DetailesRE.clear();
                Data.DetailesRE.add(Data.FinalResults[i]);
                print("publisherId : ${Data.FinalResults[i]['PublisherID']}");
                Data.pageFrom = "r";
                Navigator.of(context).pushNamed("detailes");
                //print("DetailesRE: ${Data.DetailesRE}");
              });
            },
          ),
        );
      },
    );
  }
}
