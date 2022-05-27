// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, avoid_single_cascade_in_expression_statements

import 'package:aqar_detailes/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
////////////////////////////////////////////////////////////////Start
  double ranknum = 1;
  List<double> percents = [0, 0, 0, 0, 0];
  Future<void> getMyRealEstate() async {
    Data.ownerRealEstate.clear();
    String url =
        "${Data.apiPath}select_realEstatePublisher.php?publisherid=${Data.ownerInfo[0]['UID']}";

    var response = await http.get(Uri.parse(url));

    var responsebody = jsonDecode(response.body);

    Data.ownerRealEstate.addAll(responsebody);

    if (Data.ownerRealEstate.isNotEmpty) {
      Data.getFinalOwnerRealEstate();
    }
    setState(() {});
  }

  Future<void> makeReview(String apiName) async {
    String url = "${Data.apiPath}$apiName";

    var response = await http.post(Uri.parse(url), body: {
      "rankeruser": "${Data.userInfo[0]['UID']}",
      "rankeduser": "${Data.ownerInfo[0]['UID']}",
      "ranknum": "$ranknum",
    });
    setState(() {
      getReviews();
    });
  }

  Future<void> getReviews() async {
    Data.Review.clear();
    String url =
        "${Data.apiPath}select_userRank.php?rankeduser=${Data.ownerInfo[0]['UID']}";

    var response = await http.get(Uri.parse(url));
    var responsebody = jsonDecode(response.body);

    Data.Review.addAll(responsebody);
    if (Data.Review.isNotEmpty) {
      setState(() {
        percents[0] = calculatePersents(1) / Data.Review.length;
        percents[1] = calculatePersents(2) / Data.Review.length;
        percents[2] = calculatePersents(3) / Data.Review.length;
        percents[3] = calculatePersents(4) / Data.Review.length;
        percents[4] = calculatePersents(5) / Data.Review.length;
      });
    }
    setState(() {});
    print("${Data.Review}");
  }

  int calculatePersents(int sNum) {
    int sum = 0;
    for (int i = 0; i < Data.Review.length; i++) {
      if (Data.Review[i]['RankNum'] == sNum) {
        setState(() {
          sum += 1;
        });
      }
    }
    print("The Number of users select $sNum Stars : $sum");
    setState(() {});
    return sum;
  }

  bool isRanker() {
    for (int i = 0; i < Data.Review.length; i++) {
      if (Data.userInfo[0]['UID'] == Data.Review[i]['RankerUser']) {
        return true;
      }
    }
    return false;
  }

  void setRanknum() {
    for (int i = 0; i < Data.Review.length; i++) {
      if (Data.userInfo[0]['UID'] == Data.Review[i]['RankerUser']) {
        print("nummmmmber is ${Data.Review[i]['RankNum']}");
        ranknum = double.parse(Data.Review[i]['RankNum'].toString());
        return;
      }
    }
  }

  @override
  void initState() {
    getMyRealEstate();
    getReviews();
    super.initState();
  }

////////////////////////////////////////////////////////////////End
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profiles details"),
          centerTitle: true,
          /*actions: [
            InkWell(
              child: CircleAvatar(
                radius: 20,
                backgroundImage: Data.userInfo.isNotEmpty
                    ? NetworkImage(
                        "${Data.imgPath}${Data.userInfo[0]['ImgProfileName']}")
                    : NetworkImage("${Data.imgPath}user.png"),
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
                    dialogType: DialogType.QUESTION,
                    animType: AnimType.SCALE,
                    btnOkColor: Colors.brown,
                    title: 'Are you sure ?',
                    desc: 'Are you sure you want to logout?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      setState(() {
                        Data.isLogin = false;
                        Data.checkprefs = false;
                        Data.loginOut = Icon(Icons.login);
                        Data.userInfo.clear();
                        Data.FinalFavorite.clear();
                        Data.FinalUserRealEstate.clear();
                      });
                    },
                  )..show();
                } else {
                  Navigator.of(context).pushNamed("login");
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.of(context).pushNamed("filtering");
              },
            ),
          ],*/
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 70,
                    child: ClipOval(
                      child: Image.network(
                        '${Data.imgPath}${Data.ownerInfo[0]['ImgProfileName']}',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 40),
              child: Text(
                '${Data.ownerInfo[0]['Name']}',
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TabBar(
              labelColor: Colors.brown,
              labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              tabs: [
                Tab(child: Text("Information")),
                Tab(child: Text("Real estates")),
                Tab(child: Text("Ranking")),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: 374,
                width: double.infinity,
                child: TabBarView(
                  children: [
                    Info(),
                    owenerRealEstate(),
                    ownerRanking(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Info() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          /*decoration: BoxDecoration(
             borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),*/
          /*gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.brown, Color.fromRGBO(216, 204, 201, 1)],
            ),
              ),*/
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.person_sharp,
                              color: Color.fromRGBO(90, 70, 69, 1)),
                          SizedBox(width: 20),
                          Text(
                            '${Data.ownerInfo[0]['Name']}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.0, color: Colors.black)),*/
                ),
              ),
              Divider(endIndent: 20, indent: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.email,
                              color: Color.fromRGBO(90, 70, 69, 1)),
                          SizedBox(width: 20),
                          Text(
                            '${Data.ownerInfo[0]['Email']}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.0, color: Colors.black)),*/
                ),
              ),
              Divider(endIndent: 20, indent: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.call,
                              color: Color.fromRGBO(90, 70, 69, 1)),
                          SizedBox(width: 20),
                          Text(
                            '${Data.ownerInfo[0]['PhoneNumber']}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.0, color: Colors.black)),*/
                ),
              ),
              Divider(endIndent: 20, indent: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget owenerRealEstate() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: Data.FinalOwnerRealEstate.length,
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.all(10),
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
                  "${Data.imgPath}${Data.FinalOwnerRealEstate[i]['ImageName']}",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Real estate number: ${Data.FinalOwnerRealEstate[i]['RID']}\n ${Data.FinalOwnerRealEstate[i]['Title']}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "${Data.FinalOwnerRealEstate[i]['Governorate']}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.orange,
                      ),
                      child: Text(
                        "${Data.FinalOwnerRealEstate[i]['Price']}JD",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () async {
              setState(() {
                Data.DetailesRE.clear();
                Data.DetailesRE.add(Data.FinalOwnerRealEstate[i]);
                Data.pageFrom = "o";
                Navigator.of(context).pushNamed("detailes");
              });
            },
          ),
        );
      },
    );
  }

  Widget ownerRanking() {
    return Column(
      children: [
        RankBar(5, percents[4]),
        RankBar(4, percents[3]),
        RankBar(3, percents[2]),
        RankBar(2, percents[1]),
        RankBar(1, percents[0]),
        SizedBox(height: 46),
        ElevatedButton.icon(
          label: Text("Make review", style: TextStyle(fontSize: 18)),
          icon: Icon(Icons.star),
          onPressed: () {
            if (Data.isLogin) {
              setRanknum();
              if (Data.userInfo[0]['UID'] != Data.ownerInfo[0]['UID']) {
                showDialog(true);
                setState(() {});
              } else {
                showDialog(false);
              }
            } else {
              Navigator.of(context).pushNamed("login");
            }
          },
        ),
        SizedBox(height: 25)
      ],
    );
  }

  AwesomeDialog showDialog(bool b) {
    if (b) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.SCALE,
        btnOkColor: Colors.brown,
        title: 'Review',
        body: RatingBar.builder(
          initialRating: ranknum,
          minRating: 1,
          direction: Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            ranknum = rating;
            print(ranknum);
          },
        ),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          print(ranknum);

          if (isRanker()) {
            await makeReview("update_userRanking.php");
          } else {
            await makeReview("insert_userRanking.php");
          }
          setState(() {});
        },
      )..show();
    } else {
      return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          btnOkColor: Colors.red,
          title: 'ERROR',
          desc: "You can't review yourself!", //فش حد بحكي عن زيته عكر يا معلم
          btnOkOnPress: () {})
        ..show();
    }
  }

  Widget RankBar(int sNum, double percentage) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(height: 10),
          LinearPercentIndicator(
            animation: true,
            animationDuration: 1000,
            center: Text(
              "${(percentage * 100).toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "${calculatePersents(sNum)} person",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            leading: Text(
              "$sNum Stars",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            lineHeight: 25,
            percent: percentage,
            backgroundColor: Colors.brown[200],
            progressColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
